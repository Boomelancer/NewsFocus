//
//  SubInfoModel.m
//  焦点新闻
//
//  Created by 金磊 on 15/9/28.
//  Copyright © 2015年 金磊. All rights reserved.
//

//订阅信息管理
#import "SubInfoModel.h"

@implementation SubInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.iconName forKey:@"iconName"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.isChosen forKey:@"isChosen"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.iconName = [aDecoder decodeObjectForKey:@"iconName"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.isChosen = [aDecoder decodeObjectForKey:@"isChosen"];
    }
    return self;
}

@end
