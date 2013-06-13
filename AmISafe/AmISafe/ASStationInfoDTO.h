//
//  ASStationInfoDTO.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/26/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASStationInfoDTO : NSObject
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *contactNo;
@property (nonatomic, assign)float latitude;
@property (nonatomic, assign)float longitude;
@property (nonatomic, strong)NSString *googleMapAddress;
@property (nonatomic, strong)NSString *district;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, assign)NSInteger stationNo;
@end
