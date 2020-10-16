#/bin/sh

# Bash script to load mib module into running agent.
# Script requires one parameter, path to to shared library (see example)
# by the god himself @Specter
# BEWARE: SCRIPT IS REALLY DUMMY, SO ERRORS CAN OCCUR!
# See this reference firste before using: http://www.net-snmp.org/wiki/index.php/TUT:Writing_a_Dynamically_Loadable_Object

# HOW TO RUN	
# Make sure your snmp daemon is running in one window of terminal using command: 
# snmpd -f -L -DnstAgentPluginObject,dlmod
# Now in other window of terminal, set correct permissions to script: chmod u+x agent.sh
# Run with sudo: sudo ./agent.sh /home/user/Downloads/nstAgentPluginObject.so

# NOTES
# You can use this script to automate process of adding module to agent for better testing of your module after changes in MIB file
# If you want to add module again, restart snmpd daemon and run script again
# You can restart daemon using:
# ctrl+c in terminal
# And then start it again:
# snmpd -f -L -DnstAgentPluginObject,dlmod

# Open terminal and specify path to your shared library file (.so) file
PATH_OF_SO=$1
IFS='/'

# Split path using / delimeter
read -a path_array <<< "$PATH_OF_SO"

# getting name of so file..
LEN=${#path_array[*]}
LAST_ELEMENT=$(($LEN - 1))

# getting name of so file without suffix .so..
read -a path_array <<< "$PATH_OF_SO"
NAME_OF_FILE=${path_array[$LAST_ELEMENT]}
IFS='.'
read -a file_array <<< "$NAME_OF_FILE"


#executing agent commands...
echo "------------------------------------"
echo "Create new row in dlmod table..."
snmpset localhost UCD-DLMOD-MIB::dlmodStatus.1 i create
echo "------------------------------------"
echo "Look that row was created..."
snmptable localhost UCD-DLMOD-MIB::dlmodTable 
echo "------------------------------------"
echo "Setting properties with name of object and path to .so file..."
snmpset localhost UCD-DLMOD-MIB::dlmodName.1 s "${file_array[0]}" UCD-DLMOD-MIB::dlmodPath.1 s "$PATH_OF_SO" 
snmptable localhost UCD-DLMOD-MIB::dlmodTable 
echo "------------------------------------"
echo "Loading shared object to agent..."
snmpset localhost UCD-DLMOD-MIB::dlmodStatus.1 i load 
snmptable localhost UCD-DLMOD-MIB::dlmodTable 
echo "------------------------------------"

echo "DONE! Now try to access your object as you specified in your mib file using snmpget"
echo "For example: snmpget localhost NAME-OF-YOUR-MIB::loginObject.0"


