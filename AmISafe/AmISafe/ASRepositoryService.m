//
//  ASRepositoryService.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/26/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASRepositoryService.h"
#import "CSDatabase.h"
#import "CSDataBaseManager.h"
#import "ASStationInfoDTO.h"

@implementation ASRepositoryService
-(NSMutableArray *) getStationContactInfo
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM stationInfo"];

    NSMutableArray *dataArray = (NSMutableArray *)[db executeQuery:sqlQuery];
    
    NSMutableArray *contactArray= [[NSMutableArray alloc]initWithCapacity:2];
    
    for(NSDictionary *responseDict in dataArray)
    {
        ASStationInfoDTO *stationInfoDto = [[ASStationInfoDTO alloc]init];
        stationInfoDto.name = [responseDict objectForKey:@"name"];
        stationInfoDto.contactNo = [responseDict objectForKey:@"contactno"];
        stationInfoDto.latitude = [[responseDict objectForKey:@"lat"] floatValue];
        stationInfoDto.longitude =[[responseDict objectForKey:@"long"] floatValue];
        stationInfoDto.googleMapAddress =[responseDict objectForKey:@"googleMapString"];
        stationInfoDto.state = [responseDict objectForKey:@"state"];
        stationInfoDto.district = [responseDict objectForKey:@"district"];
        stationInfoDto.stationNo = [[responseDict objectForKey:@"stationno"] integerValue];
        [contactArray addObject:stationInfoDto];
    }
    return contactArray;
}
@end
