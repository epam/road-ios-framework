//
//  RFWebServiceClient+DynamicMethod.h
//  ROADWebService
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


#import "RFWebServiceClient.h"

@class RFDownloader;

@interface RFWebServiceClient (DynamicMethod)

///**
// Performs the api call for selector, using the values dictionary to replace variables in the url string template and optionally providing an http body. The method is equivalent to call the -apiCall:values:body:startImmediately: method with a shouldStartImmediately argument set to YES and disregarding.
// @param selector The selector name.
// @param values The values of the request.
// @param httpBody The body data.
// @param request The RFWebServiceRequest to represent url request.
// @param processingQueue The queue where the call should start.
// @param prepareForSendRequestBlock The block that will be executed before request sending.
// */
//- (void)performCall:(SEL)selector
//             values:(NSDictionary *const)values
//               body:(NSData *const)httpBody
//            request:(RFDownloader *)request
//    processingQueue:(dispatch_queue_t)processingQueue
//prepareForSendRequestBlock:(RFWebServiceClientPrepareForSendRequestBlock)prepareForSendRequestBlock;
//

@end
