// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.12.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../webp/encode.dart';
import '../webp/shared.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<Frame>> intoFrames({required List<int> bytes, dynamic hint}) =>
    RustLib.instance.api.intoFrames(bytes: bytes, hint: hint);

Future<List<Frame>> upscaleFramesWithPadding(
        {required List<Frame> frames,
        required int width,
        required int height,
        dynamic hint}) =>
    RustLib.instance.api.upscaleFramesWithPadding(
        frames: frames, width: width, height: height, hint: hint);

Future<Uint8List> encode(
        {required List<Frame> frames,
        required EncodingConfig config,
        dynamic hint}) =>
    RustLib.instance.api.encode(frames: frames, config: config, hint: hint);

Future<double> calcTranslucency({required List<Frame> frames, dynamic hint}) =>
    RustLib.instance.api.calcTranslucency(frames: frames, hint: hint);
