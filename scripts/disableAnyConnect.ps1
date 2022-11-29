wsl -d ubuntu bash -c "sudo rm -f /etc/wsl.conf"

wsl --terminate ubuntu

wsl -d ubuntu bash -c "curl https://www.google.com"