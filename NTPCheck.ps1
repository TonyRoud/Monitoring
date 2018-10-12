$ntpLocalCheck  = Get-WmiObject win32_operatingsystem
$ntpServerCheck = net time \\uk.pool.ntp.org

$time1 = $ntpLocalCheck.converttodatetime($ntpLocalCheck.localdatetime)
$time2 = $ntpservercheck[0].substring(45,19)

$timespan = [math]::Round((New-Timespan -Start $time1 -End $time2).TotalSeconds, 1)

if ($timespan -gt 30 -or $timespan -lt -30)
{
    $status = 2
}
elseif ($timespan -gt 15 -or $timespan -lt -15)
{
    $status = 1
}
else 
{
    $status = 0
    $timeDelay = 0
}

Write-Output "$status NTPCheck - Local system time is $timespan seconds out of sync with NTP server"