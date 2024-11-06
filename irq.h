#ifndef _IRQ_H
#define _IRQ_H

#define GIC_BASE  0xff840000
#define BASE_ADDR 0xfe000000

#define DIST                GIC_BASE + 0x1000
#define ICD_TYPE            DIST + 0x4
#define ICD_ISENABLE        DIST + 0x100
#define ICD_ICENABLE        DIST + 0x180
#define ICD_SET_PENDING     DIST + 0x200
#define ICD_SET_ACTIVE      DIST + 0x300
#define ICD_PR              DIST + 0x400
#define ICD_PTR             DIST + 0x800
#define ICD_GROUP           DIST + 0x80
#define ICD_ICFGR           DIST + 0xc00

#define CPU_INTERFACE       GIC_BASE + 0x2000
#define ICC_PR              CPU_INTERFACE + 0x4
#define ICC_ACK             CPU_INTERFACE + 0xc
#define ICC_EOI             CPU_INTERFACE + 0x10


#define TIMER_LOAD          (BASE_ADDR + 0xB400)
#define TIMER_CTL           (BASE_ADDR + 0xB408)
#define TIMER_ACK           (BASE_ADDR + 0xB40C)
#define TIMER_MSKIRQ        (BASE_ADDR + 0xB414)
#define TIMER_PREDIV        (BASE_ADDR + 0xB41c)
 
#endif