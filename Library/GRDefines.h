//
//  GRDefines.h
//  GraceRoad
//
//  Created by Mac003 on 14-2-14.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#ifndef GraceRoad_GRDefines_h
#define GraceRoad_GRDefines_h

#if DEBUG
# define NSLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#else
# define NSLog(...) do{}while(0)
#endif


#endif
