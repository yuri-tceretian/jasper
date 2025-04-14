#!/usr/bin/env pwsh

# copy css, fonts
New-Item -Path "./src/Renderer/asset/css" -ItemType Directory -Force
New-Item -Path "./src/Renderer/asset/fonts" -ItemType Directory -Force
Copy-Item -Path "./node_modules/@mdi/font/css/materialdesignicons.css" -Destination "./src/Renderer/asset/css/" -Force
Copy-Item -Path "./node_modules/@mdi/font/css/materialdesignicons.css.map" -Destination "./src/Renderer/asset/css/" -Force
Copy-Item -Path "./node_modules/@mdi/font/fonts/*" -Destination "./src/Renderer/asset/fonts/" -Force

# make IconNameType.ts
$names = Select-String -Path "./node_modules/@mdi/font/css/materialdesignicons.css" -Pattern '\.mdi-[^:]+::before' | 
    ForEach-Object { 
        $_.Matches.Value.Split(':')[0] -replace '\.mdi-', '' 
    } |
    ForEach-Object {
        "'$_' |"
    }

# Replace the last pipe with empty string
$names[-1] = $names[-1].TrimEnd(' |')

$content = "export type IconNameType =
$($names -join "`n")
"

Set-Content -Path "./src/Renderer/Library/Type/IconNameType.ts" -Value $content
