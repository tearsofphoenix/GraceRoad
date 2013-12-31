//
//  LogService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#define ERLogServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.log"

#define ERLogServiceDebugLogLevel (@0)
#define ERLogServiceInformationLogLevel (@1)
#define ERLogServiceWarningLogLevel (@2)
#define ERLogServiceErrorLogLevel (@3)
#define ERLogServiceAssertLogLevel (@4)
#define ERLogServiceTraceLogLevel (@5)

#define ERLogServiceStandardDomain @"com.eintsoft.gopher-wood.noahs-service.log.standard"
#define ERLogServiceServiceDomain @"com.eintsoft.gopher-wood.noahs-service.log.service"
#define ERLogServiceSystemDomain @"com.eintsoft.gopher-wood.noahs-service.log.system"

#define ERLogServiceLogContent_Domain_Level_Action @"logContent:domain:level:"
#define ERLogServiceFlushLogRecordsAction @"flushLogRecords"
#define ERLogServiceLast500LogRecordsAction @"last500LogRecords"

#define ERDLLog(DOMAIN, LEVEL, FORMAT, ...) [(id<ERLogService>)[ERService serviceWithIdentifier: ERLogServiceIdentifier] logInDomain: (DOMAIN) level: (LEVEL) format: (FORMAT), ##__VA_ARGS__]

#define ERDAssert(CONDITION, DOMAIN, FORMAT, ...) \
do \
{ \
    if (!(CONDITION)) \
    { \
\
        ERDLLog(ERLogServiceStandardDomain, ERLogServiceAssertLogLevel, (FORMAT), ##__VA_ARGS__); \
\
        abort(); \
    } \
} \
while (0)
#define ERDTrace(DOMAIN, FORMAT, ...) ERDLLog((DOMAIN), ERLogServiceTraceLogLevel, (FORMAT), ##__VA_ARGS__)
#define ERDDebug(DOMAIN, FORMAT, ...) ERDLLog((DOMAIN), ERLogServiceDebugLogLevel, (FORMAT), ##__VA_ARGS__)
#define ERDInform(DOMAIN, FORMAT, ...) ERDLLog((DOMAIN), ERLogServiceInformationLogLevel, (FORMAT), ##__VA_ARGS__)
#define ERDWarn(DOMAIN, FORMAT, ...) ERDLLog((DOMAIN), ERLogServiceWarningLogLevel, (FORMAT), ##__VA_ARGS__)
#define ERDReport(DOMAIN, FORMAT, ...) ERDLLog((DOMAIN), ERLogServiceErrorLogLevel, (FORMAT), ##__VA_ARGS__)

#define ERAssert(CONDITION, FORMAT, ...) ERDAssert((long long)(CONDITION), ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)
#define ERTrace(FORMAT, ...) ERDTrace(ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)
#define ERDebug(FORMAT, ...) ERDDebug(ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)
#define ERInform(FORMAT, ...) ERDInform(ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)
#define ERWarn(FORMAT, ...) ERDWarn(ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)
#define ERReport(FORMAT, ...) ERDReport(ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)

#define ERLog(FORMAT, ...) ERTrace((FORMAT), ##__VA_ARGS__)

#define ERTraceObject(OBJECT) ERTrace(@"%@", ((OBJECT) ?: [NSNull null]))

#define ERTracePointer(POINTER) ERTrace(@"%p", (POINTER))

#define ERTraceInteger(INTEGER) ERTrace(@"%lld", (long long)(INTEGER))

#define ERTraceFloat(FLOAT) ERTrace(@"%f", (FLOAT))

#define ERTraceCGRect(RECT) ERTrace(@"%@", [NSValue valueWithCGRect: RECT])

#define ERTraceCGSize(SIZE) ERTrace(@"%@", [NSValue valueWithCGSize: SIZE])

#define ERTraceCGPoint(POINT) ERTrace(@"%@", [NSValue valueWithCGPoint: POINT])

#define ERTraceNSRange(RANGE) ERTrace(@"%@", [NSValue valueWithRange: RANGE])

@protocol ERLogService

- (void)logInDomain: (NSString *)domain
              level: (NSNumber *)level
             format: (NSString *)format, ... NS_FORMAT_FUNCTION(3, 4);

@end
