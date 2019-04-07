$ErrorActionPreference = "Stop"

function Update-DeploymentProperties(){
    Param(
        [Parameter(Mandatory=$true)]
        [string]$pathToSonarQube,
        [Parameter(Mandatory=$true)]
        [string]$sqlServerUrl,
        [Parameter(Mandatory=$true)]
        [string]$database,
        [Parameter(Mandatory=$true)]
        [string]$SqlLogin,
        [Parameter(Mandatory=$true)]
        [SecureString]$sqlPassword
    )
        
    $propertiesFile = [PropertiesFile]::new($pathToSonarQube)
    $propertiesFile.UpdateParameters($sqlServerUrl, $database, $SqlLogin, $sqlPassword)
    $propertiesFile.WriteFile();
}