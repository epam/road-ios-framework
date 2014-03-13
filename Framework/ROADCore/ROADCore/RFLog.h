//
//  RFLog.h
//  ROADCore
//
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
// list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing


#ifndef ROADCore_RFLog_h
#define ROADCore_RFLog_h


    #ifdef ROAD_LOGGING_NSLOG

        #ifdef ROAD_LOGGING_LEVEL_ERROR

            #define RFLogError(...) NSLog(__VA_ARGS__)
            #define RFLogWarn(...)
            #define RFLogInfo(...)
            #define RFLogDebug(...)
            #define RFLogVerbose(...)

        #elif ROAD_LOGGING_LEVEL_WARN

            #define RFLogError(...) NSLog(__VA_ARGS__)
            #define RFLogWarn(...) NSLog(__VA_ARGS__)
            #define RFLogInfo(...)
            #define RFLogDebug(...)
            #define RFLogVerbose(...)

        #elif ROAD_LOGGING_LEVEL_INFO

            #define RFLogError(...) NSLog(__VA_ARGS__)
            #define RFLogWarn(...) NSLog(__VA_ARGS__)
            #define RFLogInfo(...) NSLog(__VA_ARGS__)
            #define RFLogDebug(...)
            #define RFLogVerbose(...)

        #elif ROAD_LOGGING_LEVEL_DEBUG

            #define RFLogError(...) NSLog(__VA_ARGS__)
            #define RFLogWarn(...) NSLog(__VA_ARGS__)
            #define RFLogInfo(...) NSLog(__VA_ARGS__)
            #define RFLogDebug(...) NSLog(__VA_ARGS__)
            #define RFLogVerbose(...)

        #else

            #define RFLogError(...) NSLog(__VA_ARGS__)
            #define RFLogWarn(...) NSLog(__VA_ARGS__)
            #define RFLogInfo(...) NSLog(__VA_ARGS__)
            #define RFLogDebug(...) NSLog(__VA_ARGS__)
            #define RFLogVerbose(...) NSLog(__VA_ARGS__)

        #endif

    #else

        #define RFLogError(...)
        #define RFLogWarn(...)
        #define RFLogInfo(...)
        #define RFLogDebug(...)
        #define RFLogVerbose(...)

    #endif


#endif
