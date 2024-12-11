# Extract wifi keys from host
One-liner to extract all recorded Wifi profiles (i.e. SSIDs) + the corresponding key in clear-text:
'''for /f "tokens=2 delims=:" %A in ('netsh wlan show profiles ^| findstr "All User Profile"') do @for /f "delims=" %B in ('echo %A') do @netsh wlan show profiles name=%B key=clear |findstr "SSID name|Key Content"'''
 
