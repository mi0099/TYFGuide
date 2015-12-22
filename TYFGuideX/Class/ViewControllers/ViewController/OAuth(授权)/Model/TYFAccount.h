//
//  TYFAccount.h
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/22.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYFAccount : NSObject<NSCoding>
@property(nonatomic, copy)NSString *access_token;
@property(nonatomic, strong)NSDate *expriesTime;//账号过期的时间
//如果账号返回的数字很大,建议用long long (比如主键ID)
@property(nonatomic, assign)long long expires_in;
@property(nonatomic, assign)long long remind_in;
@property(nonatomic, assign)long long uid;

/*
 用户昵称
 */
@property(nonatomic, copy)NSString *name;
+(instancetype)accountWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
