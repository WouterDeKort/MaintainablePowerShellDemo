# Writing maintainable PowerShell

The goal of this code sample is to research the usage of PowerShell classes, unit tests and a build system.

The following is the original script that I've refactored.

~~~~ PowerShell
Param(
    [string]$ConnectionString,
    [string]$SqlLogin,
    [string]$SqlPassword
)

$propFile = Get-ChildItem 'sonar.properties' -Recurse
$configContents = Get-Content -Path $propFile.FullName -Raw

$configContents = $configContents -ireplace '#sonar.jdbc.username=', "sonar.jdbc.username=$SqlLogin"
$configContents = $configContents -ireplace '#sonar.jdbc.password=', "sonar.jdbc.password=$SqlPassword"
$configContents = $configContents -ireplace '#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar;integratedSecurity=true', "#xxx"
$configContents = $configContents -ireplace '#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar', "sonar.jdbc.url=$ConnectionString"

Set-Content -Path $propFile.FullName -Value $configContents
~~~~

More details are available in this blog post: <http://wouterdekort.com/TODO.>