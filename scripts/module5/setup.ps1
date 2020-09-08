$ORG_UUID = Read-Host -Prompt "Enter your ORG UUID: "
$API_KEY = Read-Host -Prompt "Enter your API Key: "
$AUTH_HEADER = Read-Host -Prompt "Enter your AUTH Header: "
$APP_ID = Read-Host -Prompt "Enter your APP ID: "
Write-Host "Your details are: $ORG_UUID, $API_KEY, $AUTH_HEADER, and $APP_ID"

$files = Get-ChildItem templates\*.template
foreach ($file in $files)
{
  Write-Host "Your file is $file"
  $basename = [System.IO.Path]::GetFileNameWithoutExtension("$file")
  Copy-Item $file -Destination "$basename.0"
  (Get-Content "$basename.0").Replace("{org_uuid}",$ORG_UUID) | Set-Content "$basename.1"
  (Get-Content "$basename.1").Replace("{authorization_key}",$AUTH_HEADER) | Set-Content "$basename.2"
  (Get-Content "$basename.2").Replace("{api_key}",$API_KEY) | Set-Content "$basename.3"
  (Get-Content "$basename.3").Replace("{app_id}",$APP_ID) | Set-Content "$basename.bat"
  Remove-Item "*.0","*.1","*.2","*.3"
}
