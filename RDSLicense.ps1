function main()
{
    Add-WindowsFeature -Name RDS-Licensing, RDS-RD-Server -IncludeManagementTolos

    $licenseServer='localhost'
    $companyInformation = @{}
    $companyInformation.FirstName="Sunil"
    $companyInformation.LastName="Sample"
    $companyInformation.Company="BSF"
    $companyInformation.CountryRegion="Canada"
    activate-licenseServer $licenseServer $companyInformation
}

function activate-licenseServer($licServer, $companyInfo)
{
    $licServerResult = @{}
    $licServerResult.LicenseServerActivated = $Null

    $wmiClass = ([wmiclass]"\\$($licServer)\root\cimv2:Win32_TSLicenseServer")

    $wmiTSLicenseObject = Get-WMIObject Win32_TSLicenseServer -computername $licServer
    $wmiTSLicenseObject.FirstName=$companyInfo.FirstName
    $wmiTSLicenseObject.LastName=$companyInfo.LastName
    $wmiTSLicenseObject.Company=$companyInfo.Company
    $wmiTSLicenseObject.CountryRegion=$companyInfo.CountryRegion
    $wmiTSLicenseObject.Put()

    echo "activating"
    $wmiClass.ActivateServerAutomatic()
    $licServerResult.LicenseServerActivated = $wmiClass.GetActivationStatus().ActivationStatus

    echo "activation status: $($licServerResult.LicenseServerActivated) (0 = activated, 1 = not activated)"

}
main
