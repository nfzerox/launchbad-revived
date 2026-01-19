# launchbad-revived

## Usage
1. [Turn off System Integrity Protection](https://developer.apple.com/documentation/security/disabling-and-enabling-system-integrity-protection) by running `csrutil disable` in recoveryOS
2. Download [launchbad-revived](https://codeload.github.com/nfzerox/launchbad-revived/zip/refs/heads/main) and unzip it
3. Open Terminal and run `~/Downloads/launchbad-revived-main/launchpad`

This has been tested on macOS 26.3, macOS 26.2, macOS 26.1, and macOS 26.0. This script will replace your current Dock with an older Dock pre-extracted from macOS 26.0 beta 4, and installs Launchpad pre-extracted from macOS 26.0 beta 3. During installation, this script prints signing information from these pre-extracted apps so you can confirm they are authentic. To uninstall, run `~/Downloads/launchbad-revived-main/launchpad` again.

## Screenshot
<img width="1920" alt="Launchpad" src="https://github.com/user-attachments/assets/2e8cee9f-997b-420d-8268-aa5b8997dc50" />

## Bonus: Disable Liquid Glass
To disable Liquid Glass on macOS Tahoe, open Terminal and run the following command. You won’t see your password as you type. Changes take effect after restart.

```
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo defaults write /Library/Preferences/FeatureFlags/Domain/SwiftUI.plist Solarium -dict Enabled -bool false
defaults write -g NSAlertGlassSolariumEnabled -bool false
```

<img width="1920" alt="macOS Tahoe with Liquid Glass disabled" src="https://github.com/user-attachments/assets/3137eb8b-b219-416b-9c1c-6fc026e1912b"/>

This has been tested on macOS 26.3, macOS 26.2, macOS 26.1, and macOS 26.0. When Liquid Glass is disabled on macOS Tahoe, column view clips folder content in Finder.

You can disable Liquid Glass without turning off System Integrity Protection or reinstalling Launchpad, but unless you turn off System Integrity Protection and reinstall Launchpad, system UI such as Dock, Control Center and Notification Center appear without any background material, which can be hard to read.

To re-enable Liquid Glass on macOS Tahoe, open Terminal and run the following command. You won’t see your password as you type. Changes take effect after restart.

```
sudo defaults delete /Library/Preferences/FeatureFlags/Domain/SwiftUI.plist
defaults delete -g NSAlertGlassSolariumEnabled
```

## Advanced
You can also download and extract Dock.app from macOS 26.0 beta 4 ([ipsw](https://updates.cdn-apple.com/2025SummerSeed/fullrestores/082-89871/D95E6C0D-147C-4F0D-878B-A4534D9B4763/UniversalMac_26.0_25A5316i_Restore.ipsw), [decryption key](https://theapplewiki.com/wiki/Keys:CheerSeed_25A5316i_(Mac15,12))) and Launchpad.app from macOS 26.0 beta 3 ([ipsw](https://updates.cdn-apple.com/2025SummerSeed/fullrestores/082-72248/F32F08F8-FC66-4D24-847B-F03C6CF7C410/UniversalMac_26.0_25A5306g_Restore.ipsw), [decryption key](https://theapplewiki.com/wiki/Keys:CheerSeed_25A5306g_(iMac21,2))) yourself.

`aea decrypt -i ~/Downloads/UniversalMac_26.0_25A5316i_Restore/044-44752-107.dmg.aea -o ~/Downloads/UniversalMac_26.0_25A5316i_Restore/044-44752-107.dmg -key-value 'base64:6AgFrh6bxZ4tKfIKnDwvT1aXLbgRivDiLDmw/AF9vfU='`

`aea decrypt -i ~/Downloads/UniversalMac_26.0_25A5306g_Restore/044-44752-094.dmg.aea -o ~/Downloads/UniversalMac_26.0_25A5306g_Restore/044-44752-094.dmg -key-value 'base64:SwvusTPGzVJX9bJa6t5EWTpmLHFnAfC8Zft3VUpPKGY='`

You can compare the shasum of your own extraction with what's in the repo, which matches. You can also use your own .app bundles by placing them in ./assets.
