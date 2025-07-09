#!/bin/bash

# Disable F11 for Show Desktop (Mission Control)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 36 "<dict><key>enabled</key><false/></dict>"
