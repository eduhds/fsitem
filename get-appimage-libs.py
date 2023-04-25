import os

app_dir_libs_path = 'AppDir/usr'

stream = os.popen('ldd AppDir/usr/bin/fsitem')
output = stream.readlines()

# Copy libs to AppDir
for i in output:
    libs = i.replace('\t', '').replace('\n', '').split('=>')

    for j in libs:
        lib_path = j.strip()
        
        if lib_path.startswith('/'):
            os.system('cp --parents ' + lib_path.split(' ')[0].strip() + ' ' + app_dir_libs_path)
