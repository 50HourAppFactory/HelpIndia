//
//  ASStationInfoService.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/27/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASStationInfoService : NSObject

-(NSMutableArray *)getPoliceContacts;
-(NSMutableArray *)getAllStateArray:(NSMutableArray *)contactsArray;
-(NSMutableArray *)getAllDistrictsFrom:(NSMutableArray *)contactArray andState:(NSString *)stateName;

-(NSMutableDictionary *)getAllDistrictsFrom:(NSMutableArray *)contactArray and:(NSMutableArray *)stateArray;
-(NSMutableArray *)getAllStationsFrom:(NSMutableArray *)contactArray andDistrict:(NSString *)district;
@end
