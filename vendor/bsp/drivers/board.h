/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author            Notes
 * 2021-01-04     iysheng           first version
 */

#ifndef __BOARD_H__
#define __BOARD_H__

#include <gd32e10x.h>

#include "drv_gpio.h"

#define GD32_SRAM_SIZE         32 // or 20
#define GD32_SRAM_END          (0x20000000 + GD32_SRAM_SIZE * 1024)

extern int __bss_end__;
#define HEAP_BEGIN    (&__bss_end__)

#define HEAP_END          GD32_SRAM_END

#endif
