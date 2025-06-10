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

# Limitations
`Shortcuts/Features that "Show desktop" (move windows to edges so the desktop is visible) break the dock for a while when used with this.`


`Long pressing icons dont show their windows.`


`Mission control (the feature that lists every window) doesn't work.`

`Clicking launchpad icon again doesn't exit the launchpad`





