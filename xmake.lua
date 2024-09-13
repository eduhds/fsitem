target("termbox2")
    set_kind("object")
    add_files("src/libs/*.c")

target('switch-config')
    add_rules("mode.debug", "mode.release")
    set_kind('binary')
    set_languages('c11')
    add_deps("termbox2")
    add_files("src/*.m")

    if is_plat('linux') then
        local objcFlags = os.getenv('GNUSTEP_FLAGS')
        local gnustepLinks = { 'objc', 'gnustep-base' }

        if objcFlags then
            print(objcFlags)
        else
            print("--- Error: GNUSTEP_FLAGS variable must be defined ---")
        end

        add_mflags(objcFlags, {force = true})
        add_links(gnustepLinks)
    end

    if is_plat('macosx') then
        add_mflags('-fno-objc-arc')
        add_frameworks('Foundation')
    end

    if is_mode("debug") then
        add_defines("DEBUG")
    end

