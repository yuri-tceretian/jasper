# Set the debug environment variable
$env:DEBUG = "electron-packager,electron-windows-installer:main"

# Cleanup
Remove-Item -Recurse -Force ./out/build

# Build JS and install npm packages
./script/tsc/build-package.ps1

# Build app with electron-packager
$VERSION = node -e 'console.log(require("./package.json").version)'
./node_modules/.bin/electron-packager ./out/package Jasper `
  --asar=true `
  --overwrite `
  --icon=./misc/logo/icon_256x256.ico `
  --platform=win32 `
  --arch=x64 `
  --out=./out/build `
  --app-version=$VERSION `
  --build-version=$VERSION `
  --app-copyright=RyoMaruyama

# Prepare Windows build directory
Remove-Item -Recurse -Force ./out/win
New-Item -ItemType Directory -Path ./out/win
Move-Item ./out/build/Jasper-win32-x64 ./out/win/Jasper

# Create the installer
node ./script/win/make-installer.js