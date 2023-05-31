#!/bin/bash
cd src
flutter pub get
flutter_rust_bridge_codegen --rust-input ./rust/src/api.rs --dart-output ./lib/models/webp_bridge_generated.dart
cd rust; cargo ndk --platform 24 -t armeabi-v7a -t arm64-v8a -o ../android/app/src/main/jniLibs build --release
flutter build apk --release