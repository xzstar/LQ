#!/bin/bash

chmod 777 /private
chmod 777 /private/var

chown mobile:mobile /private/var/mobile
chmod 755 /private/var/mobile

chown mobile:mobile /private/var/mobile/Library
chmod 755 /private/var/mobile/Library

chown mobile:mobile /private/var/mobile/Library/SpringBoard
chmod 755 /private/var/mobile/Library/SpringBoard

chown mobile:mobile /private/var/mobile/Library/Preferences
chmod 755 /private/var/mobile/Library/Preferences

chown -R mobile:mobile /private/var/mobile/Library/Teiron
chmod -R 755 /private/var/mobile/Library/Teiron

chown mobile:mobile /private/var/mobile/Library/HomeBackground.jpg
chmod 755 /private/var/mobile/Library/HomeBackground.jpg

chown mobile:mobile /private/var/mobile/Library/LockBackground.jpg
chmod 755 /private/var/mobile/Library/LockBackground.jpg

chown mobile:mobile /private/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap
chmod 755 /private/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap

chown mobile:mobile /private/var/mobile/Library/SpringBoard/LockBackground.cpbitmap
chmod 755 /private/var/mobile/Library/SpringBoard/LockBackground.cpbitmap

chown mobile:mobile /private/var/mobile/Library/Preferences/com.apple.springboard.plist
chmod 755 /private/var/mobile/Library/Preferences/com.apple.springboard.plist

chown root:wheel /Applications/PPHelper.app/SetSMSRing
chmod 755 /Applications/PPHelper.app/SetSMSRing
chmod u+s /Applications/PPHelper.app/SetSMSRing
chmod g+s /Applications/PPHelper.app/SetSMSRing

chown root:wheel /Applications/PPHelper.app/PXL
chmod 755 /Applications/PPHelper.app/PXL
chmod u+s /Applications/PPHelper.app/PXL
chmod g+s /Applications/PPHelper.app/PXL

chown root:wheel /Applications/PPHelper.app/PPHelper
chmod 755 /Applications/PPHelper.app/PPHelper

rm -f /Applications/PPHelper.app/SoftwareDetailsViewController.nib
rm -f /Applications/PPHelper.app/SoftwareDetailsViewController-ipad.nib
rm -f /Applications/PPHelper.app/WallpaperShowViewController-ipad.nib
rm -f /Applications/PPHelper.app/WallpaperShowViewController.nib
rm -f /Applications/PPHelper.app/Default-ipad.jpg
rm -f /Applications/PPHelper.app/Default.jpg
rm -f /Applications/PPHelper.app/Default@2x.jpg
rm -f /Applications/PPHelper.app/PP_Soft06.png
rm -f /Applications/PPHelper.app/PP_Soft06@2x.png
rm -f /Applications/PPHelper.app/config.plist




