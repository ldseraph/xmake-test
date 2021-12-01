{
    depfiles_gcc = "build/.objs/lora-xmake/cross/none/release/src/aaaa.c.o: src/aaaa.c\
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
        "src/aaaa.c"
    }
}