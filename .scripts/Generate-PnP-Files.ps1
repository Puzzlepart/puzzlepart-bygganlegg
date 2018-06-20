$TemplatesPath = "./templates"
$TemplatesOutputPath = "./dist/templates"

mkdir $TemplatesOutputPath -Force

Get-ChildItem -Directory $TemplatesPath  | ForEach-Object {
    $template = $_
    Get-ChildItem -Directory "$($TemplatesPath)/$($template)"  | ForEach-Object {
        Write-Host $_
        $Name = $_
        
        $Folder = "$($TemplatesPath)/$($template)/$($Name)"
        $Out = "$($TemplatesOutputPath)\$($template)-$($Name).pnp"
        Convert-PnPFolderToProvisioningTemplate -Folder $Folder -Out $Out -Force
    }
}