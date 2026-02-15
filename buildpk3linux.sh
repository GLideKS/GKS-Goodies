# GKS Goodies - PK3 Build Script (for Linux))
# If anything is ever added or removed from the mod,
# please check this script to make sure the mod builds correctly!
# Special thanks to the SRB2 MRCE project for their build_MRCE.bat script for being a great help!

# IMPORTANT NOTE: Please make sure to save this script with LF line endings! Otherwise, it will not work properly under Linux!

# Please update the version numbers below in case they get changed for RSR updates

COMMIT=$(git rev-parse --short HEAD)
MAIN_NAME=L_GKSGoodies
MAIN_VERSION=1-alpha-$COMMIT

# Create the "build" directory if it doesn't exist
# This directory is ignored by the git repo, so don't worry about making changes here
rm -rf "./build"
mkdir build

# Main PK3
7za u -mx5 -tzip -x@./exclude-main.txt ./build/$MAIN_NAME-v$MAIN_VERSION.pk3 ./src/*
# - 7za rn ./build/$MAIN_NAME-v$MAIN_VERSION.pk3 @./rename-main.txt