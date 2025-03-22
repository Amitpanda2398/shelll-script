# shelll-script
shell script to create n number of users 

🚀 Automating User Account Creation in Linux! 🐧

As an IT professional, setting up user accounts efficiently is a critical task. Recently, I created a simple yet powerful Bash script to automate user creation from a file. Here's how it works:

Key Features of the Script:
1️⃣ Reads usernames from an input file (e.g. user.txt).
2️⃣ Validates usernames, skipping invalid ones or comments.
3️⃣ Creates users if they don't already exist.
4️⃣ Sets a common password securely (in this example: admin@123).
5️⃣ Configures sudo access for the users securely.
Why Use This?
Saves time during bulk account setup.
Reduces human error with built-in validations.
Easy to adapt for specific organizational needs.

How to Use It:
1️⃣ Prepare your input file (user.txt) with a list of usernames.
2️⃣ Run the script with:
bash
Copy code
./user_creation_script.sh user.txt admin@123
💡 Script in Action:
Handles edge cases (e.g., invalid usernames or existing accounts).
Adds secure sudoer configurations for each user.
