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
