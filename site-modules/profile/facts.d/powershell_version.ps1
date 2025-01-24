$result = $PSVersionTable | ConvertTo-Json -Compress
Write-Host "{""powershell_version_table"":$result}"

