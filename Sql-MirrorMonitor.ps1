# Load SMO extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null

$sqlhost = "SQL-1"

$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlhost

# Get mirrored databases
$databases = $srv.Databases | Where-Object {$_.IsMirroringEnabled -eq $true }

function Get-DatabaseMirroringStatus {

    $status = $database | Select-Object -Property Name, MirroringStatus

    if ($status.MirroringStatus -eq "Synchronized")
    {
        Write-Output "0 Check_SQL_Mirroring_$($status.Name) - OK - Database Name: $($status.Name) - Database status: $($status.MirroringStatus)"
    }
    Elseif ($status.MirroringStatus -eq "Suspended")
    {
        Write-Output "1 Check_SQL_Mirroring_$($status.Name) - WARN - Database Name: $($status.Name) - Database status: $($status.MirroringStatus)"
    }
    Else
    {
        Write-Output "2 Check_SQL_Mirroring_$($status.Name) - CRIT - Database Name: $($status.Name) - Database status: $($status.MirroringStatus)"
    }
}

foreach($database in $databases)
{
    Get-DatabaseMirroringStatus -Database $Database
}
