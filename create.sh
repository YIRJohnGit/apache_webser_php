#!/bin/bash

# Function to display colored messages
color_echo() 
{
    case "$1" in
        red)    echo -e "\e[91m$2\e[0m";;
        green)  echo -e "\e[92m$2\e[0m";;
        yellow) echo -e "\e[93m$2\e[0m";;
        *)     echo "$2";;
    esac
}

# Input variables
color_echo "yellow" "Enter the domain name (e.g., api.mydomain.com):"
read domain_name

color_echo "yellow" "Enter the folder location (e.g., /home/apimydomaincom):"
read folder_location

color_echo "yellow" "Enter the PHP version (e.g., 82):"
read php_version

# Create Apache configuration file `/etc/httpd/sites-available/$domain_name.conf`
config_file="$domain_name.conf"
cat <<EOL > "$config_file"
<VirtualHost *:80>
    ServerAdmin admin@$domain_name
    ServerName $domain_name
    ServerAlias www.$domain_name

    DocumentRoot $folder_location/public_html
    DirectoryIndex index.htm index.html index.shtml index.php index.phtml

    <Directory "$folder_location/public_html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:90$php_version$folder_location/public_html/\$1

    ErrorLog $folder_location/logs/error.log
    CustomLog $folder_location/logs/access.log combined

    Redirect permanent / https://$domain_name/
</VirtualHost>
EOL

# Display success message
color_echo "green" "Apache configuration file created successfully at: $config_file"
