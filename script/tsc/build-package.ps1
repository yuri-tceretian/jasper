#!/usr/bin/env pwsh

# cleanup
Remove-Item -Path ./out/package -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path ./out/package -ItemType Directory -Force

# css, html and other files to include in output
Copy-Item -Path ./src -Destination ./out/package/ -Recurse
Get-ChildItem -Path ./out/package/src -Include *.ts,*.tsx -Recurse | Remove-Item -Force

# compile
Write-Host "tsc..."
npx tsc --outDir ./out/package/src/ --sourceMap false

# npm
Copy-Item -Path ./package.json,./package-lock.json -Destination ./out/package/
Copy-Item -Path ./script -Destination ./out/package/ -Recurse
Push-Location ./out/package/
npm i --production
Pop-Location

# styled-components requires @types/react-native, install separately
# todo: styled-components@5.2.x might fix this
Push-Location ./out/package/
npm i @types/react-native
Pop-Location

# change 'main: out/src/index.js' to 'main: src/index.js' for electron entry path
(Get-Content -Path ./out/package/package.json) -replace 'out/src/index.js', 'src/index.js' | Set-Content -Path ./out/package/package.json 