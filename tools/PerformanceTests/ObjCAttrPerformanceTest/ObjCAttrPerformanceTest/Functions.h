//
//  Functions.h
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#include <mach/mach_time.h>
#include <stdint.h>

static const double ElapsedNanoseconds(const uint64_t startTime, const uint64_t endTime) __attribute__((unused));

// http://stackoverflow.com/questions/2129794/how-to-log-a-methods-execution-time-exactly-in-milliseconds
static const double ElapsedNanoseconds(const uint64_t startTime, const uint64_t endTime) {
    const uint64_t elapsedMTU = endTime - startTime;

    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info)) {
        NSLog(@"Error of timer");
    }

    const double elapsedNS = (double)elapsedMTU * (double)info.numer / (double)info.denom;

    return elapsedNS;
}