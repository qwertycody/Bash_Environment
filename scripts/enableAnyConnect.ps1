
foreach($serverAddress in $output.ServerAddresses)
{
    echo $serverAddress
}

wsl -d ubuntu bash -c "cat /etc/resolv.conf &&\
                       sudo cp /etc/resolv.conf /etc/resolv.conf.bak &&\
                       sudo rm -f /etc/wsl.conf &&\
                       echo '[network]' | sudo tee /etc/wsl.conf &&\
                       echo 'generateResolvConf = false' | sudo tee -a /etc/wsl.conf"

wsl --terminate ubuntu

wsl -d ubuntu bash -c "sudo cp --remove-destination /etc/resolv.conf.bak /etc/resolv.conf &&\
                       sudo sed -i '/nameserver/s/^/#/' /etc/resolv.conf"


$ciscoAnyconnectAdapter = Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"}
$output = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -Match $ciscoAnyconnectAdapter.InterfaceAlias}

foreach($serverAddress in $output.ServerAddresses)
{
    wsl -d ubuntu bash -c "echo 'nameserver $serverAddress' | sudo tee -a /etc/resolv.conf"
}

wsl -d ubuntu bash -c "curl https://www.google.com"