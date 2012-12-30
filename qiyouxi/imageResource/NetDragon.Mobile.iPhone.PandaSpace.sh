#!/bin/bash

/bin/launchctl unload -w /System/Library/LaunchDaemons/NetDragon.Mobile.iPhone.PandaDaemon.plist
#/bin/launchctl unload -w /System/Library/LaunchDaemons/NetDragon.Mobile.iPhone.DownAgent.plist
#killall -KILL TQServer
#killall -KILL DownAgent

rm -f /System/Library/LaunchDaemons/NetDragon.Mobile.iPhone.PandaDaemon.plist
rm -f /System/Library/LaunchDaemons/NetDragon.Mobile.iPhone.DownAgent.plist
rm -f /usr/bin/TQServer
rm -f /usr/bin/DownAgent
rm -R -f /private/var/root/Library/NetDragon/
rm -R -f /private/var/root/Media/ndDaemon/

rm -R -f /private/var/mobile/Media/PandaSpace/
rm -R -f /private/var/mobile/Media/PandaSpaceTmp/
rm -f /private/var/mobile/Media/PandaSpaceUpdate

rm -R -f /private/var/mobile/Library/PandaSpace/


