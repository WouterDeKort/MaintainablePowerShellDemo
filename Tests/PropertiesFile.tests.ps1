using module SonarQubeDeploy

class MockPropertiesFile : PropertiesFile {

    $fakeContent = @"
#sonar.jdbc.username=
#sonar.jdbc.password=
#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar;integratedSecurity=true
#sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar
"@

    MockPropertiesFile([string]$fakepath ) : base($fakepath) {
    }

    [void]LoadContent([string]$pathToSonarQube){
        $this.Content = $this.fakeContent
    }
}

InModuleScope SonarQubeDeploy {
    Describe 'PropertiesFile' {
        Context "When processing the sonar.properties file" {
            it 'Loads the hard coded content' {

                $propertiesFile = [MockPropertiesFile]::new("fakepath")
                $propertiesFile.Content | should be $propertiesFile.fakeContent
            }

            it 'Replaces the Username correctly' {
                $userName = 'MySecureUser'

                $propertiesFile = [MockPropertiesFile]::new("fakepath")
                $propertiesFile.UpdateUserName($userName)

                $propertiesFile.Content | Should -Match $userName
            }

            it 'Replaces the SQL Password correctly' {
                $propertiesFile = [MockPropertiesFile]::new("fakepath")
                $plainText = "Plain text"
                $encryptedPassword = $plainText | ConvertTo-SecureString  -AsPlainText -Force
                
                $propertiesFile.UpdatePassword($encryptedPassword)

                $propertiesFile.Content | Should -Match $plainText
            }

            it 'Replaces the Connection string correctly' {
                $propertiesFile = [MockPropertiesFile]::new("fakepath")
                $propertiesFile.UpdateConnectionString("sqlServer.azure", "SonarQubeDb")

                $propertiesFile.Content | Should -Match "SonarQubeDb"
                $propertiesFile.Content | Should -Match "sqlServer.azure"
            }
        }
    }
}