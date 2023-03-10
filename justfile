# Cross platform shebang:
shebang := if os() == 'windows' {
  'powershell.exe'
} else {
  '/usr/bin/env bash'
}

set windows-shell := ["powershell", "-c"]

default: build

clean:
  #!{{shebang}}
  cd src
  flutter clean
  cd rust; cargo clean

build:
  #!{{shebang}}
  cd src
  flutter pub get
  flutter_rust_bridge_codegen --rust-input ./rust/src/api.rs --dart-output ./lib/models/webp_bridge_generated.dart
  cd rust; cargo ndk --platform 24 -t armeabi-v7a -t arm64-v8a -o ../android/app/src/main/jniLibs build --release
  flutter build apk

debug:
  #!{{shebang}}
  cd src
  flutter watch

rebuild: clean build
