$testServer = "10.0.0.1"
$tunnelName = "wg-VPN"
$wgService = (get-service | where-object {$_.name -match "WireGuardTunnel" -and $_.name -match $tunnelName} | select-object -first 1)
#put a delay in just to let the network settle
start-sleep 1
#testing if wireguard service exists and our test server is NOT reachable
if($wgService -and !(test-connection $testServer -quiet)) {
    #restart the service and flush dns in this circumstance
    $wgService.stop()
    ipconfig /flushdns
    start-sleep 1
    $wgService.start()
}