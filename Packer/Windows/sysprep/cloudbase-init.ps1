# install Cloudbase-Init
mkdir "c:\setup"
echo "Copy CloudbaseInitSetup_1_1_4_x64"
copy-item "F:\CloudbaseInitSetup_1_1_4_x64.msi" "c:\setup\CloudbaseInitSetup_1_1_4_x64.msi" -force

echo "Start process CloudbaseInitSetup_Stable_x64.msi"
# cd c:\setup
# msiexec /i CloudbaseInitSetup.msi /qn /l*v log.txt
start-process -FilePath 'c:\setup\CloudbaseInitSetup_1_1_4_x64.msi' -ArgumentList '/qn /l*v C:\setup\cloud-init.log' -Wait
