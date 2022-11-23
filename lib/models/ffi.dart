// Re-export the bridge so it is only necessary to import this file.
export 'webp_bridge_generated.dart';
import 'dart:io' as io;
import 'dart:ffi';

import 'package:seventv_for_whatsapp/models/webp_bridge_generated.dart';

const _base = 'rust';

// On MacOS, the dynamic library is not bundled with the binary,
// but rather directly **linked** against the binary.
final _dylib = io.Platform.isWindows ? '$_base.dll' : 'lib$_base.so';

final api =
    RustImpl(io.Platform.isIOS || io.Platform.isMacOS ? DynamicLibrary.executable() : DynamicLibrary.open(_dylib));
