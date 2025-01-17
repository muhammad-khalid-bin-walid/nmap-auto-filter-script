#!/bin/bash

# Function to print colored text
print_color() {
    local color=$1
    local text=$2
    case $color in
        "green") echo -e "\e[32m$text\e[0m" ;;
        "red") echo -e "\e[31m$text\e[0m" ;;
        *) echo "$text" ;;
    esac
}

# Function to ask for URLs
get_url() {
    read -p "Enter the URL: " url
    echo $url
}

# Specify the target
read -p "Enter the target IP or hostname: " target

# Perform the scan
scan_results=$(nmap -p 1-1024 $target)

# Define secure and insecure ports
secure_ports=(22 443 993 995)  # Add more secure ports as needed
insecure_ports=(21 23 80 110)  # Add more insecure ports as needed

# Print the results
echo "Scan results for $target:"
echo "$scan_results" | grep -E "^[0-9]+/tcp" | while read -r line; do
    port=$(echo $line | awk '{print $1}' | cut -d'/' -f1)
    if [[ " ${secure_ports[@]} " =~ " $port " ]]; then
        print_color "green" "Port $port: Secure"
    elif [[ " ${insecure_ports[@]} " =~ " $port " ]]; then
        print_color "red" "Port $port: Insecure"
    else
        echo "Port $port: Unknown"
    fi
done

# Example usage of get_url function
url=$(get_url)
echo "The URL you entered is: $url"
