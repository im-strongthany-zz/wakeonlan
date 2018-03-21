param(
[Parameter(Mandatory=$true, HelpMessage="Please enter MAC address without : or - seperator.")]
[string] $MacAddress,
[Parameter(Mandatory=$false, HelpMessage="Number of packets to send to the broadcast address.")]
[int] $Packets=2
)

try
{
    $Broadcast = ([System.Net.IPAddress]::Broadcast)

    ## Create UDP client instance
    $Client = New-Object Net.Sockets.UdpClient

    ## Create IP endpoints for each port
    $IPEndPoint1 = New-Object Net.IPEndPoint $Broadcast, 0
    $IPEndPoint2 = New-Object Net.IPEndPoint $Broadcast, 7
    $IPEndPoint3 = New-Object Net.IPEndPoint $Broadcast, 9

    ## Construct physical address instance for the MAC address of the machine (string to byte array)
    $MAC = [Net.NetworkInformation.PhysicalAddress]::Parse($MacAddress)

    ## Construct the Packet frame
    $Frame = [byte[]]@(255,255,255, 255,255,255);
    $Frame += ($MAC.GetAddressBytes()*16)

    ## Broadcast UDP packets to the IP endpoints of the machine
    for($i = 0; $i -lt $Packets; $i++) {
        $Client.Send($Frame, $Frame.Length, $IPEndPoint1) | Out-Null
        $Client.Send($Frame, $Frame.Length, $IPEndPoint2) | Out-Null
        $Client.Send($Frame, $Frame.Length, $IPEndPoint3) | Out-Null
        sleep 1;
    }
	
	Write-Host "packet sent. Wait about 1 min for the machine to boot!" -ForegroundColor Green
	Write-Host "Press Enter to exit." -ForegroundColor Green
    Read-Host ""
}
catch
{
    $Error | Write-Error;
}
