#!/bin/bash

# Disable F11 for Show Desktop (Mission Control)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 36 "<dict><key>enabled</key><false/></dict>"

# Disable auto open upon download (does not only affect Safari downloads!)
defaults write com.apple.Safari AutoOpenSafeDownloads -int 0

# 3 finger drag
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0

# This contributes to an issue with World of Warcraft tabbing out to desktop occasionally in full screen mode.
# Suggested by Gemini after I asked it how to disable the blue caps lock thingy that pops up
# https://stackoverflow.com/questions/77248249/disable-macos-sonoma-text-insertion-point-cursor-caps-lock-indicator
sudo defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist redesigned_text_cursor -dict-add Enabled -bool NO
