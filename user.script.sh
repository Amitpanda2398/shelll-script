#!/bin/bash

# File containing the list of users
USER_LIST_FILE="$1"
COMMON_PASSWORD="$2"

# Check if the file exists
if [[ ! -f "$USER_LIST_FILE" ]]; then
    echo "Error: File '$USER_LIST_FILE' not found!"
    exit 1
fi

# Check if password is provided
if [[ -z "$COMMON_PASSWORD" ]]; then
    echo "Error: No common password provided!"
    exit 1
fi

# Loop through each line (user) in the file
while IFS= read -r username; do
    # Trim leading and trailing whitespace
    username=$(echo "$username" | xargs)

    # Skip empty lines or comments
    if [[ -z "$username" || "$username" == \#* ]]; then
        continue
    fi

    # Validate username
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "Error: Invalid username '$username', skipping..."
        continue
    fi

    # Create the user if it doesn't already exist
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists, skipping..."
    else
        echo "Creating user '$username'..."
        useradd -m -d /home/"$username" -s /bin/bash "$username" || {
            echo "Failed to create user '$username', skipping..."
            continue
        }
        
        # Set the password for the user
        echo "$username:$COMMON_PASSWORD" | chpasswd || {
            echo "Failed to set password for user '$username', skipping..."
            continue
        }
        echo "User '$username' created with the common password."
        
        # Add user to sudoers securely
        echo "%$username  ALL=(ALL) ALL" >> /etc/sudoers.d/"$username"
                
        # Copy .kube directory if it exists
        if [[ -d /root/.kube ]]; then
            cp -r /root/.kube /home/"$username"/ || {
                echo "Failed to copy .kube directory for user '$username'."
                continue
            }
            chmod 700 /home/"$username"/.kube
            chown -R "$username":"$username" /home/"$username"/.kube
	    echo ".kube directory for user $username copied..."
    	else
	    echo "Either /root/.kube or /home/$username does not exist, skipping copy for user '$username'."
        fi
    fi
done < "$USER_LIST_FILE"

echo "All users have been processed."

