# Update
This terminal command also has the same effect, which is better as it doesn't require dylib injection so it works with SIP

``` 
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo defaults write /Library/Preferences/FeatureFlags/Domain/SpotlightUI.plist SpotlightPlus -dict Enabled -bool false
```

after running these reboot


thanks to @asentientbot



# Image
<img width="1512" alt="image" src="https://github.com/user-attachments/assets/79a33d39-59c9-4db2-8453-8f4acf447a7a" />

# Info 
Hooks a feature flag to bring back old launchpad

# Requirements
-arm64e-preview-abi=1 or amfi_get_out_of_my_way=1 boot args (which also means disabled SIP and reduced/permissive security)

having the file /Library/TweakInject/libEllekit.dylib 

https://github.com/doraorak/Dylinject

# Usage 
inject the dylib to dock

# Building
using www.theos.dev -> `make clean package`

# Limitations
clicking launchpad icon again doesn't exit launchpad.
FIX: Go into the applications folder and replace Apps.app with the original Launchpad.app

(terminal command doesn't seem to have this issue)


