//
//  ASStationInfoService.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/27/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASStationInfoService.h"
#import "ASRepositoryService.h"
#import "ASStationInfoDTO.h"

@implementation ASStationInfoService

-(NSMutableArray *)getPoliceContacts
{
    ASRepositoryService *repositoryService = [[ASRepositoryService alloc]init];
    return [repositoryService getStationContactInfo];
}

-(NSMutableArray *)getAllStateArray:(NSMutableArray *)contactsArray;
{
    NSMutableArray *stateArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (ASStationInfoDTO *stationInfo in contactsArray) {
        if (![stateArray containsObject:stationInfo.state]) {
            [stateArray addObject:stationInfo.state];
        }
    }
    return stateArray;
}

-(NSMutableDictionary *)getAllDistrictsFrom:(NSMutableArray *)contactArray and:(NSMutableArray *)stateArray
{
    
    NSMutableDictionary *districtDict = [[NSMutableDictionary alloc]initWithCapacity:5];
    for (int i=0; i<[stateArray count]; i++)
    {
        NSMutableArray *districtArray = [[NSMutableArray alloc]initWithCapacity:4];
        for (ASStationInfoDTO *stationInfo in contactArray)
        {
            if(([stationInfo.state isEqualToString:[stateArray objectAtIndex:i]])&&(![districtArray containsObject:stationInfo.district]))
            {
                [districtArray addObject:stationInfo.district];
            }
        }
        [districtDict setObject:districtArray forKey:[stateArray objectAtIndex:i]];
    }
    return districtDict;
}

-(NSMutableArray *)getAllDistrictsFrom:(NSMutableArray *)contactArray andState:(NSString *)stateName
{
    NSMutableArray *districtArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (ASStationInfoDTO *stationInfo in contactArray)
    {
        if(([stationInfo.state isEqualToString:stateName])&&(![districtArray containsObject:stationInfo.district]))
        {
            [districtArray addObject:stationInfo.district];
        }
    }
    return districtArray;
}

-(NSMutableArray *)getAllStationsFrom:(NSMutableArray *)contactArray andDistrict:(NSString *)district
{
    NSMutableArray *stationArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (ASStationInfoDTO *stationInfo in contactArray)
    {
        if([stationInfo.district isEqualToString:district])
        {
            [stationArray addObject:stationInfo];
        }
    }
    return stationArray;
}

@end
