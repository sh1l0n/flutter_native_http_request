# 
#   Created by @sh1l0n
# 
#   Licensed by GPLv3
#   This file is part of sh1l0n projects
# 
#   Script for getting packages of all flutter subpackages
#

echo '[+] Going to clean packages'
cd libs
for d in *; do
    echo '[+] Cleaning packages for' $d
    cd $d
    flutter pub get
    cd ..
done
cd ..
echo '[+] Cleaning packages for main'
flutter pub get