//
//  TYFEvaluateModel.h
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYFEvaluateModel : NSObject

@property(nonatomic,copy)NSString *_id;
@property(nonatomic,copy)NSString *avatarUrl;
@property(nonatomic,assign)CGFloat rate;
@property(nonatomic,copy)NSString *userId;

/**昵称*/
@property(nonatomic,copy)NSString *username;
/**正文*/
@property(nonatomic,copy)NSString *content;
/**时间*/
@property(nonatomic,strong)NSNumber *time;

@end
