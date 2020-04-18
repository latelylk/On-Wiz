Set-Content -path 'C:\ProgramData\KingsIsle Entertainment\Wizard101\Bin\EmbeddedBrowserConfig.xml' '<Objects> <Class Name="class EmbeddedBrowserConfig"> <m_sFallbackPage></m_sFallbackPage> </Class> </Objects>'

cd "C:\ProgramData\KingsIsle Entertainment\Wizard101\Bin"

./WizardGraphicalClient.exe -L login.us.wizard101.com 12000
