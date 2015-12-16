//
//  TYFEvaluateCell.h
//  TYFGuide
//
//  Created by 田雨飞 on 15/12/16.
//  Copyright (c) 2015年 田雨飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYFEvaluateFrame;

@interface TYFEvaluateCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong)TYFEvaluateFrame *evaluateFrame;

@end
