//
//  NSObject+SafeKVO.m
//  OCHookWithLibffi
//
//  Created by wangkun on 2018/7/7.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "NSObject+SafeKVO.h"
#import "WKSwizzle.h"
#import "NSObject+MsgReceiver.h"
#import "WKCrashManager.h"
#import <pthread.h>



static inline void wk_pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive) {
#define WK_MUTEX_ASSERT_ON_ERROR(x_) do { \
__unused volatile int res = (x_); \
assert(res == 0); \
} while (0)
    assert(mutex != NULL);
    if (!recursive) {
        WK_MUTEX_ASSERT_ON_ERROR(pthread_mutex_init(mutex, NULL));
    } else {
        pthread_mutexattr_t attr;
        WK_MUTEX_ASSERT_ON_ERROR(pthread_mutexattr_init (&attr));
        WK_MUTEX_ASSERT_ON_ERROR(pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE));
        WK_MUTEX_ASSERT_ON_ERROR(pthread_mutex_init (mutex, &attr));
        WK_MUTEX_ASSERT_ON_ERROR(pthread_mutexattr_destroy (&attr));
    }
#undef WK_MUTEX_ASSERT_ON_ERROR
}

//不允许被监听
@interface WKKVOProxy : NSObject
{
    __unsafe_unretained NSObject * _observed;
    pthread_mutex_t _lock;
}

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *kvoInfoMap;

@end

@implementation WKKVOProxy

- (instancetype)initWithObserverd:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
        wk_pthread_mutex_init_recursive(&_lock,true);//采用递归锁，疑惑在于如何形成的递归条件？？ 没有递归调用
    }
    return self;
}

- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos) {
            //调用原生方法
            [_observed removeObserver:self forKeyPath:keyPath];
        }
    }
    pthread_mutex_destroy(&_lock);
}

- (NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *)kvoInfoMap {
    if (!_kvoInfoMap) {
        _kvoInfoMap = @{}.mutableCopy;
    }
    return  _kvoInfoMap;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    pthread_mutex_lock(&_lock);
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath].copy;
    for (NSObject  *observer in os) {
        [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    pthread_mutex_unlock(&_lock);


}

///NO 表示已上报，出问题了
- (BOOL)wkkvoproxy_removeObserve:(NSObject *)observer keypath:(NSString *)keyPath
{
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath];
    if (os.count == 0) {
        WKCrashModel * model = [WKCrashModel new];
        model.clasName = NSStringFromClass([self class]);
        model.msg = [NSString stringWithFormat:@"remove %@ for %@ ",NSStringFromClass([observer class]),keyPath];
        model.threadStack = [NSThread callStackSymbols];
        [WKCrashReport crashInfo:model type:(WKCrashType_KVO)];
        return NO;
    }
    pthread_mutex_lock(&_lock);
    [os removeObject:observer];
    pthread_mutex_unlock(&_lock);
    return YES;

}

- (void)wkkvoproxy_addObserve:(NSObject *)observer keypath:(NSString *)keyPath
{
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath];
    pthread_mutex_lock(&_lock);
    BOOL isContains = [os containsObject:observer];
    pthread_mutex_unlock(&_lock);

    if (isContains) {
        WKCrashModel * model = [WKCrashModel new];
        model.clasName = NSStringFromClass([self class]);
        model.msg = [NSString stringWithFormat:@"remove %@ for %@ ",NSStringFromClass([observer class]),keyPath];
        model.threadStack = [NSThread callStackSymbols];
        [WKCrashReport crashInfo:model type:(WKCrashType_KVO)];
    } else {
        pthread_mutex_lock(&_lock);
        [os addObject:observer];
        pthread_mutex_unlock(&_lock);

    }


}

@end


@interface NSObject ()

@property (nonatomic, strong) WKKVOProxy *kvoProxy;

@end

@implementation NSObject (SafeKVO)

- (void)setKvoProxy:(WKKVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WKKVOProxy *)kvoProxy {
    return objc_getAssociatedObject(self, @selector(kvoProxy));
}

+ (void)registerKVOCrash
{
    swizzling_exchangeMethod([self class], @selector(addObserver:forKeyPath:options:context:), @selector(wksafe_addObserver:forKeyPath:options:context:));
    swizzling_exchangeMethod([self class], @selector(removeObserver:forKeyPath:), @selector(wksafe_removeObserver:forKeyPath:));
}

- (void)wksafe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([self isWhiteListWithObj:observer]) {
        [self wksafe_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    
    if (!self.kvoProxy) {
        @autoreleasepool {
            self.kvoProxy = [[WKKVOProxy alloc] initWithObserverd:self];
        }
    }
    
    
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
    if (os.count == 0) {
        os = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0];
        [os addObject:observer];
        [self wksafe_addObserver:self.kvoProxy forKeyPath:keyPath options:options context:context];
        self.kvoProxy.kvoInfoMap[keyPath] = os;
        return ;
    }
    [self.kvoProxy wkkvoproxy_addObserve:observer keypath:keyPath];
}

- (void)wksafe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{

    //与此处判断 WKKVOProxy dealloc 会调用，直接让它正常调用即可，这样最简洁方便，可以考虑其它实现
    if ([self isWhiteListWithObj:observer]) {
        [self wksafe_removeObserver:observer forKeyPath:keyPath];
        return;
    }
    
    //首先内部加锁 更改hashtable的数据
    //返回值yes 表示正常移除，NO表示crash上报
    BOOL isRemove = [self.kvoProxy wkkvoproxy_removeObserve:observer keypath:keyPath];
    //其次如果正常移除后，无数据 则直接移除keypath
    if (isRemove)
    {
        NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
        if (os.count == 0) {
            [self wksafe_removeObserver:self.kvoProxy forKeyPath:keyPath];
            [self.kvoProxy.kvoInfoMap removeObjectForKey:keyPath];
        }
    }
}


//白名单主要针对观察者，因为被观察者很有可能是系统类，所以只能针对观察者处理，如果拦截到系统的观察者，则记录入白名单
+ (NSArray *)kvoWhiteList
{
    static NSArray *whiteList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whiteList = @[@"WKKVOProxy",//自己的
                      @"RACKVOProxy",//RAC的
                      @"BLYSDKManager",//bugly的
                      @"_YYTextKeyboardViewFrameObserver",//YYKit的
                      //相册相关
                      @"PLManagedAlbum",
                      @"AVCapturePhotoOutput",
                      @"AVCaptureStillImageOutput",
                      //3.2.9添加 拍照相关
                      @"AVCaptureSession",
                      @"PLPhotoStreamAlbum",
                      @"AVKVODispatcher",
                      @"PLCloudSharedAlbum",
                      @"AVPlayerPropertyCache",
                      ];//@"AVCaptureFigVideoDevice"
    });
    return whiteList;
}

- (BOOL)isWhiteListWithObj:(NSObject *)obj
{
    for (NSString * str in [NSObject kvoWhiteList]) {
        if ([str isEqualToString:NSStringFromClass([obj class])]) {
            return YES;
        }
    }
    return NO;
    
}

@end

