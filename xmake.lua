local objcFlags = '-MMD -MP -DGNUSTEP -DGNUSTEP_BASE_LIBRARY=1 -DGNU_GUI_LIBRARY=1 -DGNU_RUNTIME=1 -DGNUSTEP_BASE_LIBRARY=1 -fno-strict-aliasing -fexceptions -fobjc-exceptions -D_NATIVE_OBJC_EXCEPTIONS -pthread -fPIC -Wall -DGSWARN -DGSDIAGNOSE -Wno-import -g -O2 -fconstant-string-class=NSConstantString -I. -I/home/vscode/GNUstep/Library/Headers -I/usr/local/include/GNUstep -I/usr/include/GNUstep'
local gnustepLinks = { 'objc', 'gnustep-base' }

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
        add_mflags(objcFlags)
        add_links(gnustepLinks)
    end

    if is_plat('macosx') then
        add_mflags('-fno-objc-arc')
        add_frameworks('Foundation')
    end

    if is_mode("debug") then
        add_defines("DEBUG")
    end

