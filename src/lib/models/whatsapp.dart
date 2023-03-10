// import 'dart:io';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seventv_for_whatsapp/models/ffi.dart';
import 'package:seventv_for_whatsapp/models/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulid/ulid.dart';
import 'package:universal_io/io.dart' as io;
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:image/image.dart';
import 'seventv.dart';

class WhatsApp {
  static Future<io.Directory> getStickerDirectory() async {
    final applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
    final packDirectory = io.Directory('${applicationDocumentsDirectory.path}/stickers');
    return packDirectory.create(recursive: true);
  }

  static Future<Iterable<StickerPack>> loadStoredStickerPacks() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final stickerPackIds = sharedPreferences.getStringList(SharedPreferencesKeys.stickerPacks) ?? [];
    return stickerPackIds
        .map((id) => sharedPreferences.getString(id))
        .where((json) => json != null)
        .map((json) => StickerPack.fromJson(jsonDecode(json!)));
  }
}

class StickerPack {
  final Ulid identifier;
  String name;
  String publisher;
  String trayImageFile;
  String imageDataVersion;
  bool avoidCache;
  Uri? publisherWebsite;
  Uri? privacyPolicyWebsite;
  Uri? licenseAgreementWebsite;
  bool? isAnimated;
  List<Sticker> stickers = [];
  bool isInstalled = false;

  StickerPack(this.identifier, this.name, this.publisher, this.trayImageFile, this.imageDataVersion, this.avoidCache,
      this.publisherWebsite, this.privacyPolicyWebsite, this.licenseAgreementWebsite, this.stickers) {
    //set isAnimated if stickers contains animated stickers
  }

  void addSticker(Sticker sticker) => stickers.add(sticker);

  Future<void> addToWhatsApp() async {
    final stickerHandler = WhatsappStickersHandler();
    stickerHandler.addStickerPack(
        identifier.toString(),
        name,
        publisher,
        WhatsappStickerImageHandler.fromAsset(trayImageFile).path,
        publisherWebsite?.toString(),
        privacyPolicyWebsite?.toString(),
        licenseAgreementWebsite?.toString(),
        isAnimated,
        {for (var sticker in stickers) WhatsappStickerImageHandler.fromFile(sticker.imagePath).path: sticker.emojis});
    isInstalled = true;
    await save();
  }

  StickerPack.withDefaults(this.name, this.publisher)
      : identifier = Ulid(),
        trayImageFile = 'assets/defaultTrayImage.png', //TODO: generate;
        imageDataVersion = '0',
        avoidCache = false,
        publisherWebsite = null,
        privacyPolicyWebsite = null,
        licenseAgreementWebsite = null;

  Future<bool> save() async {
    final id = identifier.toString();
    final sharedPreferences = await SharedPreferences.getInstance();
    final stickerPacks = sharedPreferences.getStringList(SharedPreferencesKeys.stickerPacks) ?? [];
    if (!stickerPacks.contains(id)) {
      stickerPacks.add(identifier.toString());
      debugPrint('new stickerpack $id added to shared preferences');
    }

    if (!await sharedPreferences.setString(id, jsonEncode(this))) {
      return false;
    }

    debugPrint('saved stickerpack $id');
    return await sharedPreferences.setStringList(SharedPreferencesKeys.stickerPacks, stickerPacks);
  }

  Future<bool> delete() async {
    //delete stickers from disk
    Future.wait(stickers.map((e) => e.delete()));

    final id = identifier.toString();
    final sharedPreferences = await SharedPreferences.getInstance();
    final stickerPacks = sharedPreferences.getStringList(SharedPreferencesKeys.stickerPacks) ?? [];
    if (stickerPacks.remove(identifier.toString())) {
      debugPrint('stickerpack $id removed from shared preferences');
    }

    if (!await sharedPreferences.remove(id)) {
      return false;
    }

    debugPrint('deleted stickerpack $id');
    return await sharedPreferences.setStringList(SharedPreferencesKeys.stickerPacks, stickerPacks);
  }

  StickerPack.fromJson(Map<String, dynamic> json)
      : identifier = Ulid.parse(json['identifier']),
        name = json['name'],
        publisher = json['publisher'],
        trayImageFile = json['trayImageFile'],
        imageDataVersion = json['imageDataVersion'],
        avoidCache = json['avoidCache'],
        publisherWebsite = json['publisherWebsite'],
        privacyPolicyWebsite = json['privacyPolicyWebsite'],
        licenseAgreementWebsite = json['licenseAgreementWebsite'],
        isAnimated = json['isAnimated'],
        isInstalled = json['isInstalled'],
        stickers = List<Sticker>.from(json['stickers'].map((sticker) => Sticker.fromJson(sticker)));

  Map<String, dynamic> toJson() => {
        'identifier': identifier.toString(),
        'name': name,
        'publisher': publisher,
        'trayImageFile': trayImageFile,
        'imageDataVersion': imageDataVersion,
        'avoidCache': avoidCache,
        'publisherWebsite': publisherWebsite,
        'privacyPolicyWebsite': privacyPolicyWebsite,
        'licenseAgreementWebsite': licenseAgreementWebsite,
        'isAnimated': isAnimated,
        'isInstalled': isInstalled,
        'stickers': stickers.map((sticker) => sticker.toJson()).toList()
      };
}

class Sticker {
  static const int maxStickerSizeAnimated = 500 * 1024;
  static const int maxStickerSizeStatic = 100 * 1024;

  final Ulid identifier;
  final String imagePath;
  final List<String> emojis;
  final bool isAnimated;

  Sticker(this.identifier, this.imagePath, this.emojis, this.isAnimated);

  static Future<Sticker> fromEmote(Emote emote, List<String> emojis) async {
    final identifier = Ulid();
    final httpClient = io.HttpClient();
    final request = await httpClient.getUrl(emote.getMaxSizeUrl());
    final response = await request.close();
    final imagePath = '${(await WhatsApp.getStickerDirectory()).path}/$identifier.webp';

    var bytes = Uint8List.fromList(await response.expand((b) => b).toList());
    final webp = WebPDecoder(bytes);
    if (webp.info == null) {
      throw Exception('Bytes are not a valid WebP file');
    }

    bool isAnimated = webp.info!.hasAnimation;

    //resize webp to 512x512
    bytes = await _resizeWebp(bytes, isAnimated);
    debugPrint('generated sticker webp is ${(bytes.length / 1024).toStringAsFixed(2)}KB');

    await io.File(imagePath).writeAsBytes(bytes);

    return Sticker(identifier, imagePath, emojis, isAnimated);
  }

  static Future<List<int>> _generateTrayIcon(List<int> webp) async {
    return List<int>.empty();
  }

  static Future<Uint8List> _resizeWebp(List<int> webp, bool isAnimated) async {
    final size = webp.length / 1024;
    final losless = size <= 100;
    final maxSize = isAnimated ? maxStickerSizeAnimated : maxStickerSizeStatic;
    debugPrint(
        'Generating sticker webp from ${(webp.length / 1024).toStringAsFixed(2)}KB webp (mode: ${losless ? 'losless' : 'lossy'})');
    final frames = await api.intoFrames(bytes: Uint8List.fromList(webp));

    var upscaled = Uint8List(0);
    var generatedSize = maxSize;
    var attempt = 0;
    var targetSize = maxSize.toDouble();
    final attempts = 10;
    //sometimes (rarely in my experience) the webp encoder goes slightly over the set targetSize,
    //this is why we use the increasing buffer (will be 0 for attempt 0)
    while (generatedSize > maxSize || attempt == 0) {
      var difference = generatedSize - targetSize;
      if (attempt > 0) {
        debugPrint(
            'Compressed webp has a size of ${(generatedSize / 1024).toStringAsFixed(2)}KB after attempt $attempt (difference of $difference bytes)');
      }
      if (attempt >= attempts) {
        throw 'Not able to compress chosen emote below ${(maxSize / 1024).toStringAsFixed(2)}KB after $attempts attempts';
      }
      targetSize = generatedSize - (difference) * 1.5;
      debugPrint('Set target webp size to ${(targetSize / 1024).toStringAsFixed(2)}KB');
      final encodingConfig = EncodingConfig(
          losless: losless,
          quality: 100,
          // targetSize: maxSize ~/ frames.length,
          targetSize: targetSize ~/ frames.length,
          targetPsnr: 0,
          segments: 1,
          noiseShaping: 50,
          alphaCompression: true,
          alphaQuality: 0,
          pass: 6,
          showCompressed: false,
          partitions: 0,
          partitionLimit: 0,
          useSharpYuv: false,
          alphaFiltering: AlphaFilter.Fast,
          filter: Filter.strong(FilterConfig(strength: 60, sharpness: 0)),
          method: 4);
      upscaled = await api.upscaleFramesWithPadding(frames: frames, width: 512, height: 512, config: encodingConfig);
      generatedSize = upscaled.length;
      attempt++;
    }
    return upscaled;
  }

  Future<void> delete() async {
    await io.File(imagePath).delete();
  }

  Sticker.fromJson(Map<String, dynamic> json)
      : identifier = Ulid.parse(json['identifier']),
        imagePath = json['imagePath'],
        emojis = List<String>.from(json['emojis']),
        isAnimated = json['isAnimated'];

  Map<String, dynamic> toJson() =>
      {'identifier': identifier.toString(), 'imagePath': imagePath, 'emojis': emojis, 'isAnimated': isAnimated};
}
