# 7TV for WhatsApp

Bring your favorite third-party twitch emotes directly to WhatsApp!

## 📖 About
![Screenshot](https://gachi.gay/o30bt)
This app aims to make any 7TV emote usable in WhatsApp by turning it into a [WhatsApp sticker](https://github.com/WhatsApp/stickers/tree/main/Android). This is done by scaling the emote to 512 x 512 pixels while keeping its filesize below 500KB using compression and grouping it with a minimum of two other emotes into Sticker packs.\
The upscaling and compression should happen relatively fast, since it uses rust under the hood 🦀\
Also this is my first flutter/dart (and rust) project (*and* app in general) so please have some mercy with my spaghetti code 🙏

## 👨‍💻 Development
### Using a Dev-Container
The simplest and recommended approach is to use the provided [dev-container](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers):
1. Install docker on your host system
1. Clone this repository including the submodule:\
`git clone https://github.com/gthvmt/7TV-for-WhatsApp.git --recurse-submodules`
1. [Install the visual studio code "Dev Containers"-extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
1. (Re)open the cloned repository inside the devcontainer

#### Debugging
1. [Download the Android studio sdkmanager CLI](https://developer.android.com/tools/releases/platform-tools#downloads) **on your host** and add the bin directory to your PATH to get access to the android debug bridge (adb.exe)*
1. [Enable USB-Debugging on your Android device](https://developer.android.com/studio/debug/dev-options#Enable-debugging)
1. Make sure your Android device is connected to the same network as your PC
1. Get the IP-adress of your Android device
1. Connect your Android device to your PC using USB
1. Run
    ```
    adb tcpip 5555
    adb connect <IP of your Android Device>:5555
    ```
7. Run `adb connect <IP of your Android Device>:5555` inside of the Dev-Container
8. Run `flutter run` inside of the src directory (in the Dev-Container). If you get any errors try running `just build` first.

*I had some problems on windows where adb would not recognise my device a bunch of times, using https://github.com/koush/UniversalAdbDriver instead seemed to resolve this issue

If you do not have access to an android device, the dev-container comes with emulators pre-installed; so in theory it *should* be possible to debug the app using an emulator. I have never tested this though.

### Working directly on the host system
If you are not able to install docker on your host or your host does not have the sufficient hardware you can follow this approach instead:\
(this assumes that you are using visual studio code. Developing inside android studio should also work and be easier to set up but I have never done that)
1. [Install flutter](https://docs.flutter.dev/get-started/install)
1. [Install rust](https://rustup.rs/)
1. [Download/Install OpenJDK 11](https://www.openlogic.com/openjdk-downloads?field_java_parent_version_target_id=406&field_operating_system_target_id=All&field_architecture_target_id=All&field_java_package_target_id=396) and add the bin directory to your PATH
1. [Download the Android studio sdkmanager CLI](https://developer.android.com/tools/releases/platform-tools#downloads) and add the bin directory to your PATH
1. Add the ANDROID_HOME environment variable
1. Install the "platform-tools" using the sdkmanager
1. Optionally install android emulator(s) using the sdkmanager
1. [Install the Android NDK](https://developer.android.com/ndk/downloads) and add the environment variables ANDROID_NDK and ANDROID_NDK_HOME
1. Install just (optional), cargo-ndk and flutter_rust_bridge_codegen using cargo:\
`cargo install just cargo-ndk flutter_rust_bridge_codegen`
1. Configure rust:
    ```
    rustup component add rustfmt
    rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android
    ``` 

I may have missed a step here but it should be an OK guideline if you want/need to contribute to this project while working directly on your host. Feel free to check out the [devcontainer file](https://github.com/gthvmt/7TV-for-WhatsApp/blob/readme/.devcontainer/Containerfile) or submit a PR to fix or expand this list.

#### Debugging
1. [Enable USB-Debugging on your Android device](https://developer.android.com/studio/debug/dev-options#Enable-debugging)
1. Connect your Android device to your PC using USB
1. Run `flutter run` inside of the src directory

## 🍺 Buy me a beer!
<sup><sup>Actually, I dont even like beer...</sup></sup>\
I initially had the thought of monitizing this app by (for example) putting the ability to set a custom sticker pack provider name behind a paywall. Ultimately I decided against it because I am too lazy to implement it (and paywalls kinda suck). If you would still like to throw some money at me, you can do so here:\
https://ko-fi.com/gthvmt