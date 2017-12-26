//
//  NSObject+DataBase.m
//  exchangeSetter
//
//  Created by wangkun on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "NSObject+DataBase.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WKClassManager.h"
static void *WKDataBaseDealloKey;

static WKClassPropertyModel * getPropertyModel(id self, SEL _cmd)
{
    NSArray <WKClassPropertyModel *> * arr = [WKClassManager getClassPropertysWithClass:[self class]];    
    NSString * setter = NSStringFromSelector(_cmd);
    WKClassPropertyModel * selectedModel = nil;
    for (WKClassPropertyModel * model in arr) {
        if([model.setterName isEqualToString:setter])
        {
            selectedModel = model;
            break;
        }
    }
    return selectedModel;
}

static Ivar getIvar(id self, SEL _cmd)
{
    WKClassPropertyModel * selectedModel = getPropertyModel(self, _cmd);
    if (!selectedModel) {
        return NULL;
    }
    //拼接变量名
    NSString * varName = selectedModel.varName;
    
    unsigned int count = 0;
    //得到变量列表
    Ivar * members = class_copyIvarList([self class], &count);
    
    int index = -1;
    //遍历变量
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        //获得变量名
        const char *memberName = ivar_getName(var);
        //生成string
        NSString * memberNameStr = [NSString stringWithUTF8String:memberName];
        if ([varName isEqualToString:memberNameStr]) {
            index = i;
            break ;
        }
    }
    if (index > -1) {
        return members[index];
    }
    else
    {
        return NULL;
    }
}

static void new_setter_object(id self, SEL _cmd, id newValue)
{
    Ivar member = getIvar(self, _cmd);
    //变量存在则赋值
    if (member != NULL) {
        object_setIvar(self, member, newValue);
//        NSLog(@"修改成功");
        WKClassPropertyModel * model = getPropertyModel(self, _cmd);
        void (*func)(id, SEL,id) = (void *)model.oldsetterIMP;
        func(self,_cmd,newValue);
        NSObject * tmpObj = self;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveToLocal) object:nil];
        [tmpObj.saveKeyValue setObject:newValue forKey:model.name ?: [NSString stringWithUTF8String:ivar_getName(member)]];
        [tmpObj performSelector:@selector(saveToLocal) withObject:nil afterDelay:tmpObj.saveiIntervaltime];

    }
}

static void new_setter_long(id self, SEL _cmd, long long newValue)
{
    Ivar member = getIvar(self, _cmd);
    //变量存在则赋值
    if (member != NULL) {
        object_setIvar(self,member,(__bridge id)((void*)newValue));
//        NSLog(@"修改成功");
        WKClassPropertyModel * model = getPropertyModel(self, _cmd);
        void (*func)(id, SEL,long long) = (void *)model.oldsetterIMP;
        func(self,_cmd,newValue);
        
        NSObject * tmpObj = self;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveToLocal) object:nil];
        [tmpObj.saveKeyValue setObject:@(newValue) forKey:model.name ?: [NSString stringWithUTF8String:ivar_getName(member)]];
        [tmpObj performSelector:@selector(saveToLocal) withObject:nil afterDelay:tmpObj.saveiIntervaltime];
    }
}

@implementation NSObject (DataBase)

+ (void)wk_exchangeSetter
{
    //删除需要被忽略的行数，不参与写入功能
    NSArray * ignorePropertys = [self ignoreProperty];
    NSMutableArray <WKClassPropertyModel *> * arr = [NSMutableArray arrayWithArray:[WKClassManager getClassPropertysWithClass:[self class]]];
    NSArray <WKClassMethodModel *> * methods = [WKClassManager getClassMethodsWithClass:[self class]];
    NSMutableArray * ignorePropertyModel = [NSMutableArray array];
    for (NSString * key in ignorePropertys) {
        for (WKClassPropertyModel * model in arr) {
            if ([key isEqualToString:model.name]) {
                [ignorePropertyModel addObject:model];
            }
        }
    }
    [arr removeObjectsInArray:ignorePropertyModel];
    
    
    for (WKClassMethodModel * methodModel in methods) {
        for (WKClassPropertyModel * model in arr) {
            if([model.setterName isEqualToString:methodModel.name])
            {
                if (model.type == WKPropertyType_Object)
                {
                    method_setImplementation(methodModel.method, (IMP)new_setter_object);
                }
                else if (model.type == WKPropertyType_CNumber)
                {
                    method_setImplementation(methodModel.method, (IMP)new_setter_long);
                }
            }
        }
    }
}

- (void)setSaveKeyValue:(NSMutableDictionary *)saveKeyValue
{
    objc_setAssociatedObject(self, @selector(saveKeyValue), saveKeyValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    @autoreleasepool {
        // Need to removeObserver in dealloc
        if (objc_getAssociatedObject(self, &WKDataBaseDealloKey) == nil) {
            __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
            id deallocHelper = [self addDeallocBlock:^{
                //移除线程操作
                [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(saveToLocal) object:nil];
                //存储到本地
                [weakSelf saveToLocal];
            }];
            objc_setAssociatedObject(self, &WKDataBaseDealloKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
        }
    }
}

- (NSMutableDictionary *)saveKeyValue
{
    id obj = objc_getAssociatedObject(self, @selector(saveKeyValue));
    if (!obj || ![obj isKindOfClass:[NSMutableDictionary class]]) {
        obj = [NSMutableDictionary dictionary];
        [self setSaveKeyValue:obj];
    }
    return obj;
}

- (void)setSaveiIntervaltime:(NSTimeInterval)saveiIntervaltime
{
    objc_setAssociatedObject(self, @selector(saveiIntervaltime),@(saveiIntervaltime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)saveiIntervaltime
{
    id obj = objc_getAssociatedObject(self, @selector(saveiIntervaltime));
    if (!obj || ![obj isKindOfClass:[NSNumber class]]) {
        obj = @(5);
        [self setSaveiIntervaltime:[obj doubleValue]];
    }
    return [obj doubleValue];
}

- (void)saveToLocal
{
    
    NSMutableDictionary * mainKeyValue = [self isShouldSave];
    if (!mainKeyValue) {
        return;
    }
    //判断数据是否存在
    NSString * existStr = [NSString stringWithFormat:@"select * from %@ where ",NSStringFromClass([self class])];
    NSArray * mainKeys = [mainKeyValue allKeys];
    for (NSUInteger i = 0; i < mainKeys.count ; i ++) {
        existStr = [existStr stringByAppendingString:[NSString stringWithFormat:@"%@ = %@ ",mainKeys[i],[mainKeyValue objectForKey:mainKeys[i]]]];
        existStr = [existStr stringByAppendingString: i < (mainKeys.count - 1) ? @"and " : @";"];
    }
    
//    BOOL isExist = [[DataBaseManager sharedManager] isExist:existStr];
//    //存在则更新
//    if (isExist) {
//        //更新
//        //生成sql语句
//        NSString * updateStr = [NSString stringWithFormat:@"update ZYTaskModel set "];
//        NSArray * saveKeys = [self.saveKeyValue allKeys];
//        for (NSUInteger i = 0; i < saveKeys.count ; i ++) {
//            updateStr = [updateStr stringByAppendingString:[NSString stringWithFormat:@"%@ = %@ ",saveKeys[i],[self.saveKeyValue objectForKey:saveKeys[i]]]];
//            updateStr = [updateStr stringByAppendingString: i < (saveKeys.count - 1) ? @"," : @" where "];
//        }
//        for (NSUInteger i = 0; i < mainKeys.count ; i ++) {
//            updateStr = [updateStr stringByAppendingString:[NSString stringWithFormat:@"%@ = %@ ",mainKeys[i],[mainKeyValue objectForKey:mainKeys[i]]]];
//            updateStr = [updateStr stringByAppendingString: i < (mainKeys.count - 1) ? @"and " : @";"];
//        }
//        [[DataBaseManager sharedManager]executeUpdateSql:updateStr];
//    }
//    else
//    {
//        //不存在直接调用插入(会新建表)
//        [[DataBaseManager sharedManager] insertTableWithObject:self ignoreColumns:[[self class] ignoreProperty]];
//    }
    //存储完后 移除
    [self.saveKeyValue removeAllObjects];
}

- (NSMutableDictionary *)isShouldSave
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.saveKeyValue.count <= 0) {
        return nil;
    }
    
    NSArray * mainKey = [[self class] DBMainKey];
    if (!mainKey || mainKey.count <= 0 ) {
        return nil;
    }
    NSArray <WKClassPropertyModel *> * arr = [WKClassManager getClassPropertysWithClass:[self class]];
    for (NSString * pn in mainKey)
    {
        for (WKClassPropertyModel * model in arr)
        {
            if([model.name isEqualToString:pn])
            {
                switch (model.type) {
                    case WKPropertyType_Object:
                    {
                        id value = ((id (*)(id, SEL))(void *) objc_msgSend)((id)self, NSSelectorFromString (model.getterName));
                        //主键不能为nil 直接断言
                        if (![[self class] DBMainKeyCanBeEmpty]) {
                            NSAssert(value, @"主键不能为空");
                        }
                        else //可以则警告
                        {
                            if (value != nil) {
                                [dict setObject:value forKey:pn];
                            }
                            else
                            {
                                NSLog(@"Waring Waring Waring 主键为nil");
                            }
                        }
                    }
                        break;
                    case WKPropertyType_CNumber:
                    {
                        long long num = ((bool (*)(id, SEL))(void *) objc_msgSend)((id)self, NSSelectorFromString (model.getterName));
                        [dict setObject:@(num) forKey:pn];
                    }
                        break;
                    default:
                        NSAssert(NO, @"主键类型不正确");
                        break;
                }
            }
        }
    }
    return dict;
}

+ (NSArray *)DBMainKey
{
    return nil;
}

+ (NSArray *)ignoreProperty
{
    return nil;
}
+ (BOOL)DBMainKeyCanBeEmpty
{
    return NO;
}

@end
