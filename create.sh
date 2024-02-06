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

# Create Apache configuration file `/etc/httpd/sites-available/$domain_name.conf` if it doesn't exist
config_file="./$domain_name.conf"

if [ -e "$config_file" ]; then
    color_echo "red" "Error: Configuration file already exists. Aborting."
    exit 1 ;
fi

# Check if PHP is required
color_echo "yellow" "Do you need PHP support for this domain? (y/n):"
read php_confirmation

if [ "$php_confirmation" == "y" ]; then
    color_echo "yellow" "Enter the PHP version (e.g.,72 / 74 / 80 / 82):"
    read php_version
fi

        echo "<VirtualHost *:80>" > "$config_file"
        echo "    ServerAdmin admin@$domain_name" > "$config_file"
        echo "    ServerName $domain_name" >> "$config_file"
        echo "    ServerAlias www.$domain_name" >> "$config_file"
        echo "" >> "$config_file"
        echo "    DocumentRoot $folder_location/public_html" >> "$config_file"
        echo "    DirectoryIndex index.htm index.html index.shtml index.php index.phtml" >> "$config_file"
        echo "" >> "$config_file"
        echo "    <Directory \"$folder_location/public_html\">" >> "$config_file"
        echo "        Options Indexes FollowSymLinks" >> "$config_file"
        echo "        AllowOverride All" >> "$config_file"
        echo "        Require all granted" >> "$config_file"
        echo "    </Directory>" >> "$config_file"
        if [ "$php_confirmation" == "y" ]; then
            echo "    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:90$php_version$folder_location/public_html/\$1" >> "$config_file"
        fi
        echo "" >> "$config_file"
        echo "    ErrorLog $folder_location/logs/error.log" >> "$config_file"
        echo "    CustomLog $folder_location/logs/access.log combined" >> "$config_file"
        echo "" >> "$config_file"
        echo "    Redirect permanent / https://$domain_name/" >> "$config_file"
        echo "</VirtualHost>" >> "$config_file"


    # Display success message
    color_echo "green" "Apache configuration file created successfully at: $config_file"
fi
