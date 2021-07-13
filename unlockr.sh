#!/bin/sh

echo "Check we are running as root.."
u=$(whoami)
if [ "$u" != "root" ]; then
    echo "Script requires root to execute. Please rerun with 'sudo' or elevate shell with 'sudo su'"
fi

echo "Backing up original files to ~/backup/"
mkdir ~/backup
cp /var/sf/lib/perl/*.*/SF/SmartAgentManager.pm ~/backup/
cp /var/sf/lib/perl/*.*/SF/License/SmartLicense.pm ~/backup/

echo "Applying configuration changes.."
sed -i 's/$dbg_str = "getExportFeature start";/return 1;\n    $dbg_str = "getExportFeature start";/' /var/sf/lib/perl/*.*/SF/SmartAgentManager.pm
sed -i 's/sub getRegistrationStatus {/sub getRegistrationStatus {\n    return { status => getFakeStatus( $AUTH_STATE_AUTHORIZED, $REG_STATE_REGISTERED ) };/' /var/sf/lib/perl/*.*/SF/License/SmartLicense.pm

echo "Changes Applied. The host will now reboot."
echo "Verify smart license status in the admin console after reboot."
sleep 10
reboot
