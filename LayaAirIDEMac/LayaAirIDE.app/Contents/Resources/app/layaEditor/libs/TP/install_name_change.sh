# chanage install name of libraries which excutable used
# exzmine install name of excutable
otool -L TileAtlasPacker
echo '--------------------------------------------'

install_name_tool -change /usr/local/lib/libboost_filesystem.dylib @executable_path/libboost_filesystem.dylib TileAtlasPacker

echo "change install name of excutable"
echo "change libjpeg install name"
install_name_tool -change /usr/local/libjpeg-bin/lib/libjpeg.9.dylib @executable_path/libjpeg.9.dylib TileAtlasPacker
echo "change boost_system install name"
install_name_tool -change libboost_system.dylib @executable_path//libboost_system.dylib TileAtlasPacker
echo "change boost_filesystem install name"
install_name_tool -change libboost_filesystem.dylib @executable_path//libboost_filesystem.dylib TileAtlasPacker

echo '--------------------------------------------'
echo "install name :"
otool -L TileAtlasPacker