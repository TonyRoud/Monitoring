<#

Simple FTP File Monitor Script

#>

$ftpFolder = "\Test"
$crit = (Get-Date).AddHours(-1)
$warn = (Get-Date).AddMinutes(-30)
$warningCount = 0
$criticalCount = 0
$statusTxt = ""
$fileCount = 0
$errorDetail = $null

if (!(Test-Path -Path $ftpFolder)) {

    $criticalCount += 1
    $status = 2
    $statusTxt = "CRIT"
    $errorDetail = "FTP Folder `"$ftpFolder`" not found. Please check FTP folder."

    Write-Output "$status FTPFileCheck - $statusTxt - $errorDetail"
}

else {

    $ftpContents = Get-ChildItem -Path $ftpFolder -Recurse
    $fileCount = $ftpContents.count

    if ($fileCount -eq 0) {
        $status = 0
    }
    else {
        Foreach ($file in $ftpContents){
            if ($file.CreationTime -lt $crit){ $criticalCount += 1 }
            elseif ($file.CreationTime -lt $warn){ $warningCount += 1 }
        }
    }

    if ($criticalCount -gt 0) {
        $status = 2
        $statusTxt = "CRIT"
        $errorDetail = "$criticalCount files found over 60 mins old. Check FTP service urgently!"
    }
    elseif ($warningCount -gt 0) {
        $status = 1
        $statusTxt = "WARN"
        $errorDetail = "$warningCount files found over 30 mins old. Check FTP service."
    }
    else {
        $status = 0
        $statusTxt = "OK"
        $errorDetail = "No files found over age."
    }

    Write-Output "$status FTPFileCheck - $statusTxt - $fileCount Files found in FTP Directory `"$ftpFolder`". $errorDetail"
}






