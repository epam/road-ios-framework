//
//  RFWebServiceClientWithRoot.h
//  ROADWebService
//
//  Created by Nikita Leonov on 10/17/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "RFWebServiceClient.h"
#import "RFWebService.h"

RF_ATTRIBUTE(RFWebService, serviceRoot=@"http://google.com")
@interface RFWebServiceClientWithRoot : RFWebServiceClient

@end
