class PropertiesFile {

    [string]$Content
    [string]$PropFile

    PropertiesFile([string]$pathToSonarQube) {
        $this.LoadContent($pathToSonarQube)
    }

    hidden [void]LoadContent([string]$pathToSonarQube) {
        $this.PropFile = (Get-ChildItem 'sonar.properties' -Recurse -Path $pathToSonarQube).FullName

        if (!(Test-Path $this.PropFile -PathType Leaf)) {
            throw "File sonar.properties cannot be found."
        }

        $this.Content = Get-Content -Path $this.PropFile -Raw
    }

     [void] UpdateUserName([string] $SqlLogin) {
        $this.Content = $this.Content -ireplace '#sonar.jdbc.username=', "sonar.jdbc.username=$SqlLogin"
    }

     [string] UpdatePassword([SecureString] $SqlPassword) {
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SqlPassword)
        $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        $this.Content = $this.Content -ireplace '#sonar.jdbc.password=', "sonar.jdbc.password=$UnsecurePassword"

        return $UnsecurePassword
    }

    [void] UpdateConnectionString([string] $sqlServerUrl, [string]$database) {
        $ConnectionString = "jdbc:sqlserver://$sqlServerUrl" + ":1433;database=$database;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30"

        $this.Content = $this.Content -ireplace '#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar;integratedSecurity=true', "#xxx"
        $this.Content = $this.Content -ireplace '#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar', "sonar.jdbc.url=$ConnectionString"
    }

    [void] WriteFile() {
        Set-Content -Path $this.PropFile -Value $this.Content
    }
}