package("bsp-base")

    set_description("base bsp")
    set_license("Apache-2.0")
    set_urls("https://github.com/ldseraph/bsp-base.git")
    add_versions("v0.0.1", "6e409266c221aee025da966848b337e7a5b1e2bc")

    on_load(function (package)
        package:set("installdir", path.join(os.projectdir(),"build",".objs","bsp"))
    end)

    on_install(function (package)
        os.cp("*", package:installdir())
    end)
