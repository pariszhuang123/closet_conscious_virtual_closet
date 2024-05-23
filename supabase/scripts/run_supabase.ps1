param (
  [ValidateSet("dev", "prod")]
  [string]$environment,
  [string]$sqlFile
)

if (-not $environment -or -not $sqlFile) {
  Write-Host "Usage: .\run_supabase.ps1 -environment <environment> -sqlFile <sql_file>"
  exit 1
}

# Ensure the SQL file exists and has the correct extension
if (-not (Test-Path $sqlFile) -or -not $sqlFile -match "\.sql$") {
  Write-Host "SQL file is either not found or does not have a .sql extension!"
  exit 1
}

# Select the appropriate TOML configuration file based on the environment
switch ($environment) {
  "dev" {
    $configFileTOML = "supabase/config.closet_matching.toml"
    $configFileJSON = "config/app_config_dev.json"
  }
  "prod" {
    $configFileTOML = "supabase/config.toml"
    $configFileJSON = "config/app_config_prod.json"
  }
  default {
    Write-Host "Invalid environment specified!"
    exit 1
  }
}

if (-not (Test-Path $configFileTOML)) {
  Write-Host "Configuration file $configFileTOML not found!"
  exit 1
}

if (-not (Test-Path $configFileJSON)) {
  Write-Host "Configuration file $configFileJSON not found!"
  exit 1
}

try {
  # Parse TOML configuration
  Import-Module Tomlyn
  $configTOML = (Get-Content $configFileTOML -Raw | ConvertFrom-Toml)

  # Parse JSON configuration
  $configJSON = Get-Content $configFileJSON | ConvertFrom-Json

  if (-not $configJSON.SUPABASE_URL -or -not $configJSON.SUPABASE_ANON_KEY -or -not $configJSON.SUPABASE_SERVICE_ROLE_KEY) {
    Write-Host "Configuration file is missing required fields!"
    exit 1
  }

  # Scope environment variables to the script execution
  $env:SUPABASE_URL = $configJSON.SUPABASE_URL
  $env:SUPABASE_ANON_KEY = $configJSON.SUPABASE_ANON_KEY
  $env:SUPABASE_SERVICE_ROLE_KEY = $configJSON.SUPABASE_SERVICE_ROLE_KEY

  # Read the SQL file content
  $sqlContent = Get-Content $sqlFile -Raw

  # Run the Supabase CLI command with the SQL content
  $sqlContent | supabase db query

  # Unset environment variables after use
  Remove-Item Env:SUPABASE_URL
  Remove-Item Env:SUPABASE_ANON_KEY
  Remove-Item Env:SUPABASE_SERVICE_ROLE_KEY

} catch {
  Write-Host "An error occurred: $_"
  exit 1
}
