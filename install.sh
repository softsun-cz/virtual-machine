#!/bin/bash

VM_SCRIPT_VERSION=0.01

apt-get update
apt-get -y upgrade
apt-get -y install mc ssh git net-tools nginx php-fpm php-imagick php-gd vnstat xfsprogs php-libvirt-php
alias ls="ls --color=always"
rm -rf /var/www/html
openssl req -x509 -newkey rsa:2048 -nodes -days $(expr '(' $(date -d 2999/01/01 +%s) - $(date +%s) + 86399 ')' / 86400) -subj "/" -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.crt
sed -i -e 's/display_errors = Off/display_errors = On/g' /etc/php/7.0/fpm/php.ini
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet/GRUB_CMDLINE_LINUX_DEFAULT="quiet consoleblank=0/g' /etc/default/grub
update-grub
echo -ne '' > /etc/motd
rm /etc/update-motd.d/10-uname
cd /usr/src/
git clone https://github.com/softsun-cz/vm-webui.git
mv vm-webui/src/* /var/www/
rm -rf vm-webui

cat << EOF > /etc/nginx/sites-enabled/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        return 301 https://\$host\$request_uri;
}

server {
        listen 443 ssl http2 default_server;
        listen [::]:443 ssl http2 default_server;
        server_name _;
        ssl_certificate /etc/nginx/nginx.crt;
        ssl_certificate_key /etc/nginx/nginx.key;
        root /var/www;
        index index.html index.htm index.php;
        location / {
                try_files \$uri \$uri/ =404;
        }
        location ~ \.php\$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        }
}
EOF

cat << EOF > /etc/issue
[1;34m   __          __  _
  / _\\\\  ___   / _|| |_  [1;33m___  _   _  ____   [1;31m/\\\\   /\\\\ /\\\\/\\\\
[1;34m  \\\\ \\\\  / _ \\\\ | |_ | __|[1;33m/ __|| | | ||  _ \\\\  [1;31m\\\\ \\\\ / //    \\\\
[1;34m  _\\\\ \\\\| (_) ||  _|| |_ [1;33m\\\\__ \\\\| |_| || | | |  [1;31m\\\\ V // /\\\\/\\\\ \\\\
[1;34m  \\\\__/ \\\\___/ |_|   \\\\__|[1;33m|___/ \\\\____||_| |_|   [1;31m\\\\_/ \\\\/    \\\\/
                                                [1;39mver. 0.01[0m

[1;39m       OS: [0m\v
[1;39m   Kernel: [0m\s \r \m
[1;39m     Date: [0m\d \t
[1;39m Hostname: [0m\n
[1;39m  Console: [0m\l

EOF
reboot
