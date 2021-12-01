{
    depfiles_gcc = "build/.objs/lora-xmake/cross/none/release/vendor/bsp/Library/GD32E10x_standard_peripheral/Source/gd32e10x_gpio.c.o:  vendor/bsp/Library/GD32E10x_standard_peripheral/Source/gd32e10x_gpio.c  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_gpio.h  vendor/bsp/Library/CMSIS/GD/GD32E10x/Include/gd32e10x.h  vendor/bsp/Library/CMSIS/core_cm4.h  vendor/bsp/Library/CMSIS/core_cmInstr.h  vendor/bsp/Library/CMSIS/core_cmFunc.h  vendor/bsp/Library/CMSIS/core_cm4_simd.h  vendor/bsp/Library/CMSIS/GD/GD32E10x/Include/system_gd32e10x.h  vendor/bsp/drivers/gd32e10x_libopt.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_rcu.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_adc.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_crc.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_ctc.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_dac.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_dbg.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_dma.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_exti.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_fmc.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_fwdgt.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_i2c.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_pmu.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_bkp.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_rtc.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_spi.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_timer.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_usart.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_wwdgt.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_misc.h  vendor/bsp/Library/GD32E10x_standard_peripheral/Include/gd32e10x_exmc.h\
",
    values = {
        "/home/lidong/.xmake/packages/g/gnu-rm/10.2020-q4/2d4596dff08a4f1594fc6460d44da443/bin/arm-none-eabi-gcc",
        {
            "-Ivendor/bsp/drivers",
            "-Ivendor/bsp/Library/CMSIS",
            "-Ivendor/bsp/Library/CMSIS/GD/GD32E10x/Include",
            "-Ivendor/bsp/Library/GD32E10x_standard_peripheral/Include",
            "-DGD32E103V_EVAL",
            "-DRT_USING_COMPONENTS_INIT",
            "-DRT_USING_CONSOLE",
            "-DBSP_USING_UART0",
            "-DBSP_USING_UART1",
            "-std=gnu99",
            "-mcpu=cortex-m4",
            "-mfpu=fpv4-sp-d16",
            "-mfloat-abi=softfp",
            "-mthumb",
            "-ffunction-sections",
            "-fdata-sections",
            "-Wall",
            "-Wextra",
            "-Wno-unused-parameter",
            "-fomit-frame-pointer",
            "-ffast-math",
            "-ftree-vectorize"
        }
    },
    files = {
        "vendor/bsp/Library/GD32E10x_standard_peripheral/Source/gd32e10x_gpio.c"
    }
}