// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.5.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;

import 'dart:ffi' as ffi;

part 'webp_bridge_generated.freezed.dart';

abstract class Rust {
  Future<List<Frame>> intoFrames({required Uint8List bytes, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kIntoFramesConstMeta;

  Future<List<Frame>> upscaleFramesWithPadding(
      {required List<Frame> frames,
      required int width,
      required int height,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kUpscaleFramesWithPaddingConstMeta;

  Future<Uint8List> encode(
      {required List<Frame> frames,
      required EncodingConfig config,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kEncodeConstMeta;

  Future<double> calcTranslucency({required List<Frame> frames, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCalcTranslucencyConstMeta;
}

enum AlphaFilter {
  Fast,
  Best,
}

class EncodingConfig {
  final int method;
  final bool losless;
  final double quality;
  final int targetSize;
  final double targetPsnr;
  final int segments;
  final int noiseShaping;
  final Filter? filter;
  final bool alphaCompression;
  final AlphaFilter? alphaFiltering;
  final int alphaQuality;
  final int pass;
  final bool showCompressed;
  final Preprocessing? preprocessing;
  final int partitions;
  final int partitionLimit;
  final bool useSharpYuv;

  const EncodingConfig({
    required this.method,
    required this.losless,
    required this.quality,
    required this.targetSize,
    required this.targetPsnr,
    required this.segments,
    required this.noiseShaping,
    this.filter,
    required this.alphaCompression,
    this.alphaFiltering,
    required this.alphaQuality,
    required this.pass,
    required this.showCompressed,
    this.preprocessing,
    required this.partitions,
    required this.partitionLimit,
    required this.useSharpYuv,
  });
}

@freezed
sealed class Filter with _$Filter {
  const factory Filter.simple(
    FilterConfig field0,
  ) = Filter_Simple;
  const factory Filter.strong(
    FilterConfig field0,
  ) = Filter_Strong;
}

class FilterConfig {
  final int? strength;
  final int sharpness;

  const FilterConfig({
    this.strength,
    required this.sharpness,
  });
}

class Frame {
  final Uint8List data;
  final int width;
  final int height;
  final int timestamp;

  const Frame({
    required this.data,
    required this.width,
    required this.height,
    required this.timestamp,
  });
}

enum Preprocessing {
  SegmentSmooth,
}

class RustImpl implements Rust {
  final RustPlatform _platform;
  factory RustImpl(ExternalLibrary dylib) => RustImpl.raw(RustPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory RustImpl.wasm(FutureOr<WasmModule> module) =>
      RustImpl(module as ExternalLibrary);
  RustImpl.raw(this._platform);
  Future<List<Frame>> intoFrames({required Uint8List bytes, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(bytes);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_into_frames(port_, arg0),
      parseSuccessData: _wire2api_list_frame,
      parseErrorData: null,
      constMeta: kIntoFramesConstMeta,
      argValues: [bytes],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kIntoFramesConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "into_frames",
        argNames: ["bytes"],
      );

  Future<List<Frame>> upscaleFramesWithPadding(
      {required List<Frame> frames,
      required int width,
      required int height,
      dynamic hint}) {
    var arg0 = _platform.api2wire_list_frame(frames);
    var arg1 = api2wire_u32(width);
    var arg2 = api2wire_u32(height);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_upscale_frames_with_padding(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_list_frame,
      parseErrorData: null,
      constMeta: kUpscaleFramesWithPaddingConstMeta,
      argValues: [frames, width, height],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kUpscaleFramesWithPaddingConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "upscale_frames_with_padding",
        argNames: ["frames", "width", "height"],
      );

  Future<Uint8List> encode(
      {required List<Frame> frames,
      required EncodingConfig config,
      dynamic hint}) {
    var arg0 = _platform.api2wire_list_frame(frames);
    var arg1 = _platform.api2wire_box_autoadd_encoding_config(config);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_encode(port_, arg0, arg1),
      parseSuccessData: _wire2api_uint_8_list,
      parseErrorData: null,
      constMeta: kEncodeConstMeta,
      argValues: [frames, config],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kEncodeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "encode",
        argNames: ["frames", "config"],
      );

  Future<double> calcTranslucency({required List<Frame> frames, dynamic hint}) {
    var arg0 = _platform.api2wire_list_frame(frames);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_calc_translucency(port_, arg0),
      parseSuccessData: _wire2api_f32,
      parseErrorData: null,
      constMeta: kCalcTranslucencyConstMeta,
      argValues: [frames],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCalcTranslucencyConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "calc_translucency",
        argNames: ["frames"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  double _wire2api_f32(dynamic raw) {
    return raw as double;
  }

  Frame _wire2api_frame(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return Frame(
      data: _wire2api_uint_8_list(arr[0]),
      width: _wire2api_u32(arr[1]),
      height: _wire2api_u32(arr[2]),
      timestamp: _wire2api_i32(arr[3]),
    );
  }

  int _wire2api_i32(dynamic raw) {
    return raw as int;
  }

  List<Frame> _wire2api_list_frame(dynamic raw) {
    return (raw as List<dynamic>).map(_wire2api_frame).toList();
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }
}

// Section: api2wire

@protected
int api2wire_alpha_filter(AlphaFilter raw) {
  return api2wire_i32(raw.index);
}

@protected
bool api2wire_bool(bool raw) {
  return raw;
}

@protected
double api2wire_f32(double raw) {
  return raw;
}

@protected
int api2wire_i32(int raw) {
  return raw;
}

@protected
int api2wire_preprocessing(Preprocessing raw) {
  return api2wire_i32(raw.index);
}

@protected
int api2wire_u32(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class RustPlatform extends FlutterRustBridgeBase<RustWire> {
  RustPlatform(ffi.DynamicLibrary dylib) : super(RustWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<ffi.Int32> api2wire_box_autoadd_alpha_filter(AlphaFilter raw) {
    return inner.new_box_autoadd_alpha_filter_0(api2wire_alpha_filter(raw));
  }

  @protected
  ffi.Pointer<wire_EncodingConfig> api2wire_box_autoadd_encoding_config(
      EncodingConfig raw) {
    final ptr = inner.new_box_autoadd_encoding_config_0();
    _api_fill_to_wire_encoding_config(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_Filter> api2wire_box_autoadd_filter(Filter raw) {
    final ptr = inner.new_box_autoadd_filter_0();
    _api_fill_to_wire_filter(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_FilterConfig> api2wire_box_autoadd_filter_config(
      FilterConfig raw) {
    final ptr = inner.new_box_autoadd_filter_config_0();
    _api_fill_to_wire_filter_config(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<ffi.Int32> api2wire_box_autoadd_preprocessing(Preprocessing raw) {
    return inner.new_box_autoadd_preprocessing_0(api2wire_preprocessing(raw));
  }

  @protected
  ffi.Pointer<ffi.Uint8> api2wire_box_autoadd_u8(int raw) {
    return inner.new_box_autoadd_u8_0(api2wire_u8(raw));
  }

  @protected
  ffi.Pointer<wire_list_frame> api2wire_list_frame(List<Frame> raw) {
    final ans = inner.new_list_frame_0(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      _api_fill_to_wire_frame(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<ffi.Int32> api2wire_opt_box_autoadd_alpha_filter(
      AlphaFilter? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_alpha_filter(raw);
  }

  @protected
  ffi.Pointer<wire_Filter> api2wire_opt_box_autoadd_filter(Filter? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_filter(raw);
  }

  @protected
  ffi.Pointer<ffi.Int32> api2wire_opt_box_autoadd_preprocessing(
      Preprocessing? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_preprocessing(raw);
  }

  @protected
  ffi.Pointer<ffi.Uint8> api2wire_opt_box_autoadd_u8(int? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_u8(raw);
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_encoding_config(
      EncodingConfig apiObj, ffi.Pointer<wire_EncodingConfig> wireObj) {
    _api_fill_to_wire_encoding_config(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_box_autoadd_filter(
      Filter apiObj, ffi.Pointer<wire_Filter> wireObj) {
    _api_fill_to_wire_filter(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_box_autoadd_filter_config(
      FilterConfig apiObj, ffi.Pointer<wire_FilterConfig> wireObj) {
    _api_fill_to_wire_filter_config(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_encoding_config(
      EncodingConfig apiObj, wire_EncodingConfig wireObj) {
    wireObj.method = api2wire_u8(apiObj.method);
    wireObj.losless = api2wire_bool(apiObj.losless);
    wireObj.quality = api2wire_f32(apiObj.quality);
    wireObj.target_size = api2wire_i32(apiObj.targetSize);
    wireObj.target_psnr = api2wire_f32(apiObj.targetPsnr);
    wireObj.segments = api2wire_u8(apiObj.segments);
    wireObj.noise_shaping = api2wire_u8(apiObj.noiseShaping);
    wireObj.filter = api2wire_opt_box_autoadd_filter(apiObj.filter);
    wireObj.alpha_compression = api2wire_bool(apiObj.alphaCompression);
    wireObj.alpha_filtering =
        api2wire_opt_box_autoadd_alpha_filter(apiObj.alphaFiltering);
    wireObj.alpha_quality = api2wire_u8(apiObj.alphaQuality);
    wireObj.pass = api2wire_u8(apiObj.pass);
    wireObj.show_compressed = api2wire_bool(apiObj.showCompressed);
    wireObj.preprocessing =
        api2wire_opt_box_autoadd_preprocessing(apiObj.preprocessing);
    wireObj.partitions = api2wire_u8(apiObj.partitions);
    wireObj.partition_limit = api2wire_u8(apiObj.partitionLimit);
    wireObj.use_sharp_yuv = api2wire_bool(apiObj.useSharpYuv);
  }

  void _api_fill_to_wire_filter(Filter apiObj, wire_Filter wireObj) {
    if (apiObj is Filter_Simple) {
      var pre_field0 = api2wire_box_autoadd_filter_config(apiObj.field0);
      wireObj.tag = 0;
      wireObj.kind = inner.inflate_Filter_Simple();
      wireObj.kind.ref.Simple.ref.field0 = pre_field0;
      return;
    }
    if (apiObj is Filter_Strong) {
      var pre_field0 = api2wire_box_autoadd_filter_config(apiObj.field0);
      wireObj.tag = 1;
      wireObj.kind = inner.inflate_Filter_Strong();
      wireObj.kind.ref.Strong.ref.field0 = pre_field0;
      return;
    }
  }

  void _api_fill_to_wire_filter_config(
      FilterConfig apiObj, wire_FilterConfig wireObj) {
    wireObj.strength = api2wire_opt_box_autoadd_u8(apiObj.strength);
    wireObj.sharpness = api2wire_u8(apiObj.sharpness);
  }

  void _api_fill_to_wire_frame(Frame apiObj, wire_Frame wireObj) {
    wireObj.data = api2wire_uint_8_list(apiObj.data);
    wireObj.width = api2wire_u32(apiObj.width);
    wireObj.height = api2wire_u32(apiObj.height);
    wireObj.timestamp = api2wire_i32(apiObj.timestamp);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class RustWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustWire(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RustWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_into_frames(
    int port_,
    ffi.Pointer<wire_uint_8_list> bytes,
  ) {
    return _wire_into_frames(
      port_,
      bytes,
    );
  }

  late final _wire_into_framesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_into_frames');
  late final _wire_into_frames = _wire_into_framesPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_upscale_frames_with_padding(
    int port_,
    ffi.Pointer<wire_list_frame> frames,
    int width,
    int height,
  ) {
    return _wire_upscale_frames_with_padding(
      port_,
      frames,
      width,
      height,
    );
  }

  late final _wire_upscale_frames_with_paddingPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_list_frame>, ffi.Uint32,
              ffi.Uint32)>>('wire_upscale_frames_with_padding');
  late final _wire_upscale_frames_with_padding =
      _wire_upscale_frames_with_paddingPtr.asFunction<
          void Function(int, ffi.Pointer<wire_list_frame>, int, int)>();

  void wire_encode(
    int port_,
    ffi.Pointer<wire_list_frame> frames,
    ffi.Pointer<wire_EncodingConfig> config,
  ) {
    return _wire_encode(
      port_,
      frames,
      config,
    );
  }

  late final _wire_encodePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_list_frame>,
              ffi.Pointer<wire_EncodingConfig>)>>('wire_encode');
  late final _wire_encode = _wire_encodePtr.asFunction<
      void Function(int, ffi.Pointer<wire_list_frame>,
          ffi.Pointer<wire_EncodingConfig>)>();

  void wire_calc_translucency(
    int port_,
    ffi.Pointer<wire_list_frame> frames,
  ) {
    return _wire_calc_translucency(
      port_,
      frames,
    );
  }

  late final _wire_calc_translucencyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_list_frame>)>>('wire_calc_translucency');
  late final _wire_calc_translucency = _wire_calc_translucencyPtr
      .asFunction<void Function(int, ffi.Pointer<wire_list_frame>)>();

  ffi.Pointer<ffi.Int32> new_box_autoadd_alpha_filter_0(
    int value,
  ) {
    return _new_box_autoadd_alpha_filter_0(
      value,
    );
  }

  late final _new_box_autoadd_alpha_filter_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Int32> Function(ffi.Int32)>>(
          'new_box_autoadd_alpha_filter_0');
  late final _new_box_autoadd_alpha_filter_0 =
      _new_box_autoadd_alpha_filter_0Ptr
          .asFunction<ffi.Pointer<ffi.Int32> Function(int)>();

  ffi.Pointer<wire_EncodingConfig> new_box_autoadd_encoding_config_0() {
    return _new_box_autoadd_encoding_config_0();
  }

  late final _new_box_autoadd_encoding_config_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_EncodingConfig> Function()>>(
          'new_box_autoadd_encoding_config_0');
  late final _new_box_autoadd_encoding_config_0 =
      _new_box_autoadd_encoding_config_0Ptr
          .asFunction<ffi.Pointer<wire_EncodingConfig> Function()>();

  ffi.Pointer<wire_Filter> new_box_autoadd_filter_0() {
    return _new_box_autoadd_filter_0();
  }

  late final _new_box_autoadd_filter_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_Filter> Function()>>(
          'new_box_autoadd_filter_0');
  late final _new_box_autoadd_filter_0 = _new_box_autoadd_filter_0Ptr
      .asFunction<ffi.Pointer<wire_Filter> Function()>();

  ffi.Pointer<wire_FilterConfig> new_box_autoadd_filter_config_0() {
    return _new_box_autoadd_filter_config_0();
  }

  late final _new_box_autoadd_filter_config_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_FilterConfig> Function()>>(
          'new_box_autoadd_filter_config_0');
  late final _new_box_autoadd_filter_config_0 =
      _new_box_autoadd_filter_config_0Ptr
          .asFunction<ffi.Pointer<wire_FilterConfig> Function()>();

  ffi.Pointer<ffi.Int32> new_box_autoadd_preprocessing_0(
    int value,
  ) {
    return _new_box_autoadd_preprocessing_0(
      value,
    );
  }

  late final _new_box_autoadd_preprocessing_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Int32> Function(ffi.Int32)>>(
          'new_box_autoadd_preprocessing_0');
  late final _new_box_autoadd_preprocessing_0 =
      _new_box_autoadd_preprocessing_0Ptr
          .asFunction<ffi.Pointer<ffi.Int32> Function(int)>();

  ffi.Pointer<ffi.Uint8> new_box_autoadd_u8_0(
    int value,
  ) {
    return _new_box_autoadd_u8_0(
      value,
    );
  }

  late final _new_box_autoadd_u8_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Uint8)>>(
          'new_box_autoadd_u8_0');
  late final _new_box_autoadd_u8_0 = _new_box_autoadd_u8_0Ptr
      .asFunction<ffi.Pointer<ffi.Uint8> Function(int)>();

  ffi.Pointer<wire_list_frame> new_list_frame_0(
    int len,
  ) {
    return _new_list_frame_0(
      len,
    );
  }

  late final _new_list_frame_0Ptr = _lookup<
          ffi.NativeFunction<ffi.Pointer<wire_list_frame> Function(ffi.Int32)>>(
      'new_list_frame_0');
  late final _new_list_frame_0 = _new_list_frame_0Ptr
      .asFunction<ffi.Pointer<wire_list_frame> Function(int)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
          ffi
          .NativeFunction<ffi.Pointer<wire_uint_8_list> Function(ffi.Int32)>>(
      'new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  ffi.Pointer<FilterKind> inflate_Filter_Simple() {
    return _inflate_Filter_Simple();
  }

  late final _inflate_Filter_SimplePtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<FilterKind> Function()>>(
          'inflate_Filter_Simple');
  late final _inflate_Filter_Simple = _inflate_Filter_SimplePtr
      .asFunction<ffi.Pointer<FilterKind> Function()>();

  ffi.Pointer<FilterKind> inflate_Filter_Strong() {
    return _inflate_Filter_Strong();
  }

  late final _inflate_Filter_StrongPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<FilterKind> Function()>>(
          'inflate_Filter_Strong');
  late final _inflate_Filter_Strong = _inflate_Filter_StrongPtr
      .asFunction<ffi.Pointer<FilterKind> Function()>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_Frame extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> data;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Int32()
  external int timestamp;
}

final class wire_list_frame extends ffi.Struct {
  external ffi.Pointer<wire_Frame> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_FilterConfig extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> strength;

  @ffi.Uint8()
  external int sharpness;
}

final class wire_Filter_Simple extends ffi.Struct {
  external ffi.Pointer<wire_FilterConfig> field0;
}

final class wire_Filter_Strong extends ffi.Struct {
  external ffi.Pointer<wire_FilterConfig> field0;
}

final class FilterKind extends ffi.Union {
  external ffi.Pointer<wire_Filter_Simple> Simple;

  external ffi.Pointer<wire_Filter_Strong> Strong;
}

final class wire_Filter extends ffi.Struct {
  @ffi.Int32()
  external int tag;

  external ffi.Pointer<FilterKind> kind;
}

final class wire_EncodingConfig extends ffi.Struct {
  @ffi.Uint8()
  external int method;

  @ffi.Bool()
  external bool losless;

  @ffi.Float()
  external double quality;

  @ffi.Int32()
  external int target_size;

  @ffi.Float()
  external double target_psnr;

  @ffi.Uint8()
  external int segments;

  @ffi.Uint8()
  external int noise_shaping;

  external ffi.Pointer<wire_Filter> filter;

  @ffi.Bool()
  external bool alpha_compression;

  external ffi.Pointer<ffi.Int32> alpha_filtering;

  @ffi.Uint8()
  external int alpha_quality;

  @ffi.Uint8()
  external int pass;

  @ffi.Bool()
  external bool show_compressed;

  external ffi.Pointer<ffi.Int32> preprocessing;

  @ffi.Uint8()
  external int partitions;

  @ffi.Uint8()
  external int partition_limit;

  @ffi.Bool()
  external bool use_sharp_yuv;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
