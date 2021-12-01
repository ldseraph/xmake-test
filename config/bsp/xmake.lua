task("menuconfig")
  set_category("plugin")
  on_run("main")
  set_menu {
    usage = "xmake memuconfig [options]",
    description = "bsp config!",
    options = {}
  }
task_end()

rule("bsp")
  on_config(function (target)

    target:add("cxflags", "-mcpu=cortex-m4", "-mfpu=fpv4-sp-d16")
    target:add("cxflags", "-mfloat-abi=softfp", "-mthumb")
    target:add("cxflags", "-ffunction-sections", "-fdata-sections")
    target:add("cxflags", "-Wall -Wextra -Wno-unused-parameter","-fomit-frame-pointer -ffast-math -ftree-vectorize")
    
    target:add("cflags", "-std=gnu99")
    target:add("cxxflags", "-std=c++11")

    local cxflags = target:get("cxflags")

    target:add("asflags", cxflags,"-x assembler-with-cpp -Wa,-mimplicit-it=thumb")

    target:add("ldflags", "-Wl,--gc-sections", "-u Reset_Handler","-T vendor/bsp/linker/gd32_flash.ld",{force = true})
    target:add("ldflags", "-Wl,-cref,-Map="..target:targetfile()..".map",{force = true})
  end)
  after_link(function (target)
    local toolchains = target:toolchains()
    for _, toolchain in ipairs(toolchains) do
        local cross = toolchain:bindir().."/"..toolchain:cross()
        local objcopy = cross .. "objcopy"
        local size = cross .. "size"
        os.runv(objcopy, {"-O", "binary",target:targetfile(),target:targetfile()..".bin"})
        os.execv(size, {target:targetfile()})
      break
    end
  end)
rule_end()
