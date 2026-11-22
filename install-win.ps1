# Fast Edit - instalacao pelo PowerShell (sem o aviso do SmartScreen) - feito por @odalluz
$ErrorActionPreference = 'Stop'
$url = 'https://github.com/thauanfelippepro-ux/fast-edit/raw/main/download/Fast-Edit-Plugin.zip'
$ext = Join-Path $env:APPDATA 'Adobe\CEP\extensions'
$dest = Join-Path $ext 'com.fastedit.suite'
if (Get-Process -Name 'Adobe Premiere Pro' -ErrorAction SilentlyContinue) { Write-Host 'Feche o Adobe Premiere Pro e rode o comando de novo.'; return }
Write-Host 'Fast Edit: baixando...'
$tmp = Join-Path $env:TEMP ('fastedit_' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $url -OutFile (Join-Path $tmp 'fe.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tmp 'fe.zip') -DestinationPath $tmp -Force
New-Item -ItemType Directory -Path $ext -Force | Out-Null
Get-ChildItem $ext -Directory | Where-Object { $_.Name -ne 'com.fastedit.suite' } | ForEach-Object {
  $m = Join-Path $_.FullName 'CSXS\manifest.xml'
  if ((Test-Path $m) -and (Select-String -Path $m -Pattern 'Fast ?Edit' -Quiet)) { Remove-Item $_.FullName -Recurse -Force }
}
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Copy-Item (Join-Path $tmp 'com.fastedit.suite') $dest -Recurse
6..16 | ForEach-Object { New-Item -Path "HKCU:\Software\Adobe\CSXS.$_" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Adobe\CSXS.$_" -Name PlayerDebugMode -Value '1' }
Remove-Item $tmp -Recurse -Force
Write-Host 'Pronto! Abra o Premiere e va em Janela > Extensoes > Fast Edit.'
