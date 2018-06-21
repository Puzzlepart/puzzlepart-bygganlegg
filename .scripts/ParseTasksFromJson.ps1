$tasks = Get-Content 'C:\Users\Thomas Granheim\Documents\GitHub\prosjektportalen-bygganlegg\scripts\interessenter.data.json' | Out-String | ConvertFrom-Json 

$index = 1;

$out = "./log.xml"

New-Item -Path $Out  -ItemType file -Force

foreach ($rowA in $tasks.Data.Rows) {
    try {
        Add-Content -Path $Out -Value "<pnp:DataRow>
            <pnp:DataValue FieldName='Title'>$($rowA.Fields[0].Value)</pnp:DataValue>
            <pnp:DataValue FieldName='GtStakeholderGroup'>$($rowA.Fields[1].Value)</pnp:DataValue>
        </pnp:DataRow>"
        $rowAID = $index;
        $index++;
        if ($rowA.Rows -ne $null) {
            foreach ($rowB in $rowA.Rows) {
                Add-Content -Path $Out -Value "<pnp:DataRow>
                <pnp:DataValue FieldName='Title'>$($rowB.Fields[0].Value)</pnp:DataValue>
                <pnp:DataValue FieldName='GtProjectPhase'>$($rowB.Fields[1].Value)</pnp:DataValue>
                <pnp:DataValue FieldName='ParentID'>$($rowAID)</pnp:DataValue>
            </pnp:DataRow>"
                $rowBID = $index;
                $index++;
                if ($rowB.Rows -ne $null) {
                    Write-Host $rowB.Fields[0].Value
                    foreach ($rowC in $rowB.Rows) {
                        Add-Content -Path $Out -Value "<pnp:DataRow>
                            <pnp:DataValue FieldName='Title'>$($rowC.Fields[0].Value)</pnp:DataValue>
                            <pnp:DataValue FieldName='GtProjectPhase'>$($rowC.Fields[1].Value)</pnp:DataValue>
                            <pnp:DataValue FieldName='ParentID'>$($rowBID)</pnp:DataValue>
                        </pnp:DataRow>"
                        $index++;
                    }
                }
            }
        }
    }
    catch {
        Write-Host  "[$(Get-Date)]  $($_.Exception.Message) $($rowB.Fields[0].Value)" -ForegroundColor Yellow
    }
}

    
Write-Host $index