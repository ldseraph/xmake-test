import("core.base.task")
import("core.project.config")
import("private.action.require.impl.package")
import("core.platform.platform")
import("core.base.option")
import("core.cache.localcache")

-- main
function main()
  config.load()
  platform.load(config.plat())

  os.cd(path.join(os.projectdir(),"build",".objs","bsp"))

  option.save()

  for _, instance in ipairs(package.load_packages("bsp-gd32e10x")) do
    option.set("verbose", true)
    local configs = {"--menuconfig"}
    import("package.tools.scons").build(instance, configs)
    option.set("verbose", false)
  end

  os.cd(path.join(os.projectdir()))
  localcache.set("config", "recheck", true)
  localcache.save()
end
