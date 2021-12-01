package("bsp-gd32e10x")

    set_homepage("https://github.com/ldseraph/bsp-gd32e10x")
    set_description("gd32e10x bsp")
    set_license("Apache-2.0")

    set_urls("https://github.com/ldseraph/bsp-gd32e10x.git")
    add_versions("v0.0.1", "b71f496f642cfd576c3212ba4325e1307edfe017")

    add_deps("rt-thread")
    add_deps("bsp-base", {private = true})
    add_deps("scons")

    add_configs("cxflag",  {description = "set cxflags.",  default = "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mthumb -ffunction-sections -fdata-sections -Wall -Wextra -Wno-unused-parameter -fomit-frame-pointer -ffast-math -ftree-vectorize"})
    add_configs("cflag",   {description = "set cflags.",   default = "-std=gnu99"})
    add_configs("cxxflag", {description = "set cppflags.", default = "-std=c++11"})
    add_configs("asflag",  {description = "set asflags.",  default = "-x assembler-with-cpp -Wa,-mimplicit-it=thumb"})
    -- -Wl,--gc-sections
    add_configs("ldflag",  {description = "set ldflags.",  default = "-u Reset_Handler -T build/.objs/bsp/linker/gd32_flash.ld"})

    on_load(function (package)
        
        local configfile = path.join(os.curdir(),"build",".objs","bsp",".config")
        if os.exists(configfile) then
            local c = io.readfile(configfile)
            package:config_set("config", c)
        end

        import("core.project.config")
        config.set("bsp",package:name())
        
        local toolchains = package:toolchains()
        local toolchainsName = ""
        for _, toolchain in ipairs(toolchains) do
            if toolchain:name() == "gnu-rm" then
                toolchainsName = "gcc"
            else
                toolchainsName = toolchain:name() 
            end
            break;
        end
        config.set("toolchainsName",toolchainsName)

        local cxflags = {}
        local asflags = {}
        local mode = get_config("mode")
        if mode == "debug" then
            local c = get_config("cxflags")
            if c then c = c:split(' ', {plain = true}) end
            cxflags  = table.unique(table.join(package:config("cxflag"):split(' ', {plain = true}), c, "-D"..toolchainsName,"-Og","-gdwarf-2","-g"))
            local s = get_config("asflags")
            if s then s = s:split(' ', {plain = true}) end
            asflags  = table.unique(table.join("-c", cxflags, package:config("asflag"):split(' ', {plain = true}), s,"-gdwarf-2"))
        else
            local c = get_config("cxflags")
            if c then c = c:split(' ', {plain = true}) end
            cxflags  = table.unique(table.join(package:config("cxflag"):split(' ', {plain = true}), c, "-D"..toolchainsName,"-O2","-Os"))
            local s = get_config("asflags")
            if s then s = s:split(' ', {plain = true}) end
            asflags  = table.unique(table.join("-c", cxflags, package:config("asflag"):split(' ', {plain = true}), s))
        end

        local c = get_config("cflags")
        if c then c = c:split(' ', {plain = true}) end
        local cflags   = table.unique(table.join(package:config("cflag"):split(' ', {plain = true}), c))
        local c = get_config("cxxflags")
        if c then c = c:split(' ', {plain = true}) end
        local cxxflags = table.unique(table.join(package:config("cxxflag"):split(' ', {plain = true}), c))
        local c = get_config("ldflags")
        if c then c = c:split(' ', {plain = true}) end
        local ldflags  = table.unique(table.join(package:config("ldflag"):split(' ', {plain = true}), c))
        
        config.set("cxflags",  " "..table.concat(cxflags, ' '))
        config.set("cflags",   " "..table.concat(cflags, ' '))
        config.set("cxxflags", " "..table.concat(cxxflags, ' '))
        config.set("asflags",  " "..table.concat(asflags, ' '))
        config.set("ldflags",  " "..table.concat(ldflags, ' '))

        config.save()
    end)

    on_install(function (package)
        local curdir = os.curdir()
        local toolchainsName = get_config("toolchainsName")
        
        local configfile = path.join(os.projectdir(),"build",".objs","bsp",".config")
        if not os.exists(configfile) then
            import("core.base.option")
            os.cp("*",  path.join(os.projectdir(),"build",".objs","bsp"))
            os.cd(path.join(os.projectdir(),"build",".objs","bsp"))
            os.rm(".git")

            local rt = package:dep("rt-thread")
            local toolchains = package:toolchains()
            local rtt_root = path.join(rt:cachedir(), "source", "rt-thread")

            io.replace("rtconfig.py", "$(PLATFORM)",  toolchainsName, {plain = true})
            io.replace("rtconfig.py", "$(CXFLAGS)",  get_config("cxflags"), {plain = true})
            io.replace("rtconfig.py", "$(CFLAGS)",   get_config("cflags"), {plain = true})
            io.replace("rtconfig.py", "$(CXXFLAGS)", get_config("cxxflags"), {plain = true})
            io.replace("rtconfig.py", "$(ASFLAGS)",  get_config("asflags"), {plain = true})
            io.replace("rtconfig.py", "$(LDFLAGS)",  get_config("ldflags"), {plain = true})

            for _, toolchain in ipairs(toolchains) do
                io.replace("rtconfig.py", "$(EXEC_PATH)", toolchain:bindir(), {plain = true})
                break;
            end

            io.replace("SConstruct", "$(RTT_ROOT)", rtt_root, {plain = true})
            io.replace("Kconfig", "$(RTT_ROOT)", rtt_root, {plain = true})
            
            option.save()
            local verbose = option.get("verbose")
            option.set("verbose", true)
            local configs = {"--menuconfig"}
            import("package.tools.scons").build(package, configs)
            local config = io.readfile(configfile)
            package:config_set("config", config)
        end

        os.cd(path.join(os.projectdir(),"build",".objs","bsp"))

        local configs = {"--showgroup"}
        import("package.tools.scons").build(package, configs)

        local grups = io.readfile(".group")
        groups = grups:split('\n')
        
        for idx, val in ipairs(groups) do
            v = val:split(' ')
            for idx, basepath in ipairs(v) do
                if idx == 1 then
                    configs = {"--verbose","--buildlib="..basepath}
                    import("package.tools.scons").build(package, configs)
                else
                    os.cp(basepath.."/**.h", package:installdir("include/"), {rootdir = basepath})
                end
            end
        end
        os.mkdir(path.join(os:projectdir(),"config"))
        os.cp(path.join(os.scriptdir(),"plugins","bsp"), path.join(os:projectdir(),"config"))
        
        os.cp("*.a", curdir)
        os.cd(curdir)
        import("package.tools.xmake").install(package, {includedirs = package:installdir("include/")})
    end)

    on_test(function (package)

    end)
