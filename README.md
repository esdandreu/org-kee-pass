# org-kee-pass
Organization KeePass structure for tree like credentials permission access.

Sync Credentials with your computer
Add the Credentials folder to your ProntoPro drive
Navigate to the Credentials Root folder
Select the Credentials folder
Press SHIFT+Z or the associated “Add” keyboard shortcut. You can find the shortcuts list next to the settings. (If the left SHIFT does not work, try with the right SHIFT of your keyboard)


Add the Credentials folder to your drive

Download Backup and Sync and install it
Sign in with your ProntoPro credentials


Select the configuration
The one you want for your laptop backup

Choose at least to sync the Credentials folder from your Drive
[Optional] Change settings
(You can change this settings from the preferences section of Backup and Sync)

[Optional] Boot Performance (Windows)
(I would also recommend to remove Backup and Sync from the Windows start, because it can make your laptop slow at boot, you can execute Backup and Sync from the windows search bar whenever you want to update the files)
Press Ctrl+Alt+Supr and select Task Manager
Expand the Task Manager and select Startup
Disable googledrivesync.exe
Execute Backup and Sync when you want to update the Credentials folder
Access the credentials database
You have the Credentials folder now in the File System of your computer

Windows shortcuts:
[First time] Create database and/or shortcut
Open an existent database
Use the script “Create shortcut (Windows).bat” by double clicking it. It is located in the Credentials folder that should be synced in your computer.
Select the database you want to open by choosing the appropriate item in the command line terminal.
Create a new database
Use the script “Initialize new database (Windows).bat” by double clicking it. It is located in the Credentials folder that should be synced in your computer.
Follow the steps as they appear in the command line terminal. Make sure to create the shortcut at the end of the process.
Double click the shortcut
Or search it in the Windows search bar

Use the master password
Your colleagues can share it with you and you should memorize it or write it down.

It will open the corresponding database and all the parents databases.


Windows manual:
Execute KeePass.exe
in the KeePass-Windows folder

Open the database you want


Use the master password
Your colleagues can share it with you and you should memorize it or write it down.


MAC users: (Please add screenshots)
Double click
the database file you want to open (Database files have the .kbdx suffix)


Input the password
Each database file has its own password. When you double click on the database, it will ask you to input the password.
Your colleagues can share it with you and you should memorize it or write it down


[Alternative] Install the package
located in the KeePass-Mac.zip, one can find the instructions here
Linux users: (Please add procedure)
See the linux documentation here

Tips and tricks
Quickly copy password/user
If you double click the username or the password it will be automatically copied to your clipboard for around 10 seconds, so you can paste it where you need it. The combination “Ctrl+Alt+K” will put KeePass in the foreground if it is minimized. This allows very fast credentials input.

Search credentials
If you are unsure of where the credential is located you can just use the search box (remember to press “enter” on your keyboard to perform the search) or the find command with “Ctrl+F” (Allows searching in multiple databases).


Import from GSheets
KeePass allows you to import entries from a csv. Therefore Downloading a Google Spreadsheet as a csv and importing it in KeePass is quite straightforward.
Once the csv file is in your computer, find the “Import” option in KeePass and mark “General CSV Importer”. You will have to fill your csv in “Files to be imported”.
 
The “Structure” tab of the following menu will allow you to customize the import in order to match the layout you had on your spreadsheet:

Mark as expired
KeePass has a built-in expiration system when you can actually mark some credentials as expired. As we are making a collaborative use of the credentials databases, deleting an entry might lead to a lead of information for one of your colleagues. Instead of deleting mark the entry as expired:

(Windows) Copy between databases
When rearranging your databases, it is common the situation when you want to copy or move an entry (or several entries) from one database to another in order to restrict the access or share it with more employees. One can copy one or several entries by selecting them and pressing “Ctrl+Shift+C” and paste them in another database using “Ctrl+Shift+V”. This does not work for groups (folders), only for entries.

You can find a detailed solution here.
(Windows) AutoOpen
The shared KeePass installation has the AutoOpen plugin that allows to open multiple databases with just one password. This enables us to build a tree like architecture for credentials access.
Usage:
First of all, create a new group in your database and name it "AutoOpen" (without the quotes).
Each non-expired entry in this group corresponds to a database that should be opened automatically when the current database is opened. The fields of each entry specify the following:
Title: Ignored by the plugin; can be used for comments.
User name: Must contain the path to the key file, if one should be used. The path can be either absolute or relative to the directory containing KeePass.exe. Usually empty for ProntoPro architecture. 
Password: The master password for the database to open. If no password is required, leave this field empty.
URL: Path to the database file to open. The path can be either absolute or relative to the directory containing KeePass.exe.
Notes: Ignored by the plugin; can be used for comments.
Disabling entries. If you want to disable an entry in the "AutoOpen" group (such that KeeAutoExec does not automatically open it), you can mark the entry as expired. Alternatively, you can add a custom entry string "Enabled" with the value "False" (without the quotes).