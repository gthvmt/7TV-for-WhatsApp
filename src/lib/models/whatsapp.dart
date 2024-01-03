// import 'dart:io';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seventv_for_whatsapp/src/rust/api/api.dart';
import 'package:seventv_for_whatsapp/models/shared_preferences_keys.dart';
import 'package:seventv_for_whatsapp/src/rust/webp/encode.dart';
import 'package:seventv_for_whatsapp/src/rust/webp/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulid/ulid.dart';
import 'package:universal_io/io.dart' as io;
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:image/image.dart';
import 'seventv.dart';

class WhatsApp {
  static Future<io.Directory> getStickerDirectory() async {
    final applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final packDirectory =
        io.Directory('${applicationDocumentsDirectory.path}/stickers');
    return packDirectory.create(recursive: true);
  }

  static Future<Iterable<StickerPack>> loadStoredStickerPacks() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final stickerPackIds =
        sharedPreferences.getStringList(SharedPreferencesKeys.stickerPacks) ??
            [];
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

  StickerPack(
      this.identifier,
      this.name,
      this.publisher,
      this.trayImageFile,
      this.imageDataVersion,
      this.avoidCache,
      this.publisherWebsite,
      this.privacyPolicyWebsite,
      this.licenseAgreementWebsite,
      this.stickers) {
    //set isAnimated if stickers contains animated stickers
  }

  void addSticker(Sticker sticker) => stickers.add(sticker);

  Future<void> addToWhatsApp() async {
    final stickerHandler = WhatsappStickersHandler();
    try {
      await stickerHandler.addStickerPack(
          identifier.toString(),
          name,
          publisher,
          WhatsappStickerImageHandler.fromAsset(trayImageFile).path,
          publisherWebsite?.toString(),
          privacyPolicyWebsite?.toString(),
          licenseAgreementWebsite?.toString(),
          isAnimated, {
        for (var sticker in stickers)
          WhatsappStickerImageHandler.fromFile(sticker.imagePath).path:
              sticker.emojis
      });
      isInstalled = true;
      await save();
    } on WhatsappStickersException catch (e) {
      // TODO: show this (and all other exceptions that can occur) to the user
      // so they can open an issue on github with the exception details
      debugPrint("oopsie: ${e.cause}");
    }
  }

  StickerPack.withDefaults(this.name, this.publisher)
      : identifier = Ulid(),
        trayImageFile = 'assets/defaultTrayImage.png', //TODO: generate
        imageDataVersion = '0',
        avoidCache = false,
        publisherWebsite = null,
        privacyPolicyWebsite = null,
        licenseAgreementWebsite = null;

  Future<bool> save() async {
    final id = identifier.toString();
    final sharedPreferences = await SharedPreferences.getInstance();
    final stickerPacks =
        sharedPreferences.getStringList(SharedPreferencesKeys.stickerPacks) ??
            [];
    final existingPack = sharedPreferences.getString(id);
    if (!stickerPacks.contains(id) && existingPack == null) {
      stickerPacks.add(identifier.toString());
      debugPrint('new stickerpack $id added to shared preferences');
    } else {
      // merge stickers with existing (might happen if two stickers are added at the same time)
      final existingStickers =
          StickerPack.fromJson(jsonDecode(existingPack!)).stickers;
      stickers.addAll(existingStickers.where((existing) => !stickers
          .any((current) => current.identifier == existing.identifier)));
    }

    if (!await sharedPreferences.setString(id, jsonEncode(this))) {
      return false;
    }

    debugPrint('saved stickerpack $id');
    return await sharedPreferences.setStringList(
        SharedPreferencesKeys.stickerPacks, stickerPacks);
  }

  Future<bool> delete() async {
    //delete stickers from disk
    Future.wait(stickers.map((e) => e.delete()));

    final id = identifier.toString();
    final sharedPreferences = await SharedPreferences.getInstance();
    final stickerPacks =
        sharedPreferences.getStringList(SharedPreferencesKeys.stickerPacks) ??
            [];
    if (stickerPacks.remove(identifier.toString())) {
      debugPrint('stickerpack $id removed from shared preferences');
    }

    if (!await sharedPreferences.remove(id)) {
      return false;
    }

    debugPrint('deleted stickerpack $id');
    return await sharedPreferences.setStringList(
        SharedPreferencesKeys.stickerPacks, stickerPacks);
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
        stickers = List<Sticker>.from(
            json['stickers'].map((sticker) => Sticker.fromJson(sticker)));

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
  static const int maxStickerDuration = 10000;

  final Ulid identifier;
  final String imagePath;
  final List<String> emojis;
  final bool isAnimated;

  Sticker(this.identifier, this.imagePath, this.emojis, this.isAnimated);

  static Future<Sticker> fromEmote(Emote emote, List<String> emojis) async {
    final identifier = Ulid();
    final httpClient = io.HttpClient();
    final url = emote.getMaxSizeUrl();
    if (url == null) {
      throw Exception('Unable to get image URL from emote');
    }
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    final imagePath =
        '${(await WhatsApp.getStickerDirectory()).path}/$identifier.webp';

    var bytes = Uint8List.fromList(await response.expand((b) => b).toList());
    final webp = WebPDecoder(bytes);
    if (webp.info == null) {
      throw Exception('Bytes are not a valid WebP file');
    }

    final webpInformation = webp.info!;
    bool isAnimated = webpInformation.hasAnimation;

    var frames = await intoFrames(bytes: Uint8List.fromList(bytes));

    if (frames.isEmpty) {
      throw Exception('WebP does not seem to have a single frame');
    }

    var duration = frames.last.timestamp;

    // I (think) that the last frame timestamp + 1 is the actual 'duration' so it has to be >= here
    // (I tried it with '=' when the last frame timestamp was 10000 and WhatsApp was not satisfied)
    if (duration >= maxStickerDuration) {
      // TODO: We could also either speed the animation up or remove frames from the beginning.
      // Eventually it would be cool to make this configurable
      debugPrint(
          'Emote animation duration exceeds the maximum allowed animation duration for '
          'stickers. Cutting some frames of the end.');

      frames.removeWhere((frame) => frame.timestamp >= maxStickerDuration);
      duration = frames.last.timestamp;
      debugPrint('New emote length is $duration');
    }

    //resize webp to 512x512
    bytes = await _resizeFrames(frames, bytes.length, isAnimated);
    debugPrint(
        'generated sticker webp is ${(bytes.length / 1024).toStringAsFixed(2)}KB large');

    await io.File(imagePath).writeAsBytes(bytes);

    return Sticker(identifier, imagePath, emojis, isAnimated);
  }

  static Future<List<int>> _generateTrayIcon(List<int> webp) async {
    return List<int>.empty();
  }

  static Future<Uint8List> _resizeFrames(
      List<Frame> frames, int size, bool isAnimated) async {
    final losless = size / 1024 <= 100;
    const minSize = 1;
    final maxSize = isAnimated ? maxStickerSizeAnimated : maxStickerSizeStatic;
    debugPrint(
        'Generating sticker webp from ${(size / 1024).toStringAsFixed(2)}KB webp (mode: ${losless ? 'losless' : 'lossy'})');

    var upscaled = Uint8List(0);
    var generatedSize = maxSize;
    var attempt = 0;
    var targetSize = maxSize.toDouble();
    const attempts = 10;

    while (generatedSize > maxSize || attempt == 0) {
      var difference = generatedSize - targetSize;
      if (attempt > 0) {
        debugPrint(
            'Compressed webp has a size of ${(generatedSize / 1024).toStringAsFixed(2)}KB after attempt $attempt (difference of $difference bytes)');
      }
      if (attempt >= attempts || targetSize == minSize) {
        throw 'Not able to compress chosen emote below ${(maxSize / 1024).toStringAsFixed(2)}KB after $attempts attempts';
      }
      //sometimes (rarely in my experience) the webp encoder goes slightly over the set targetSize,
      //this is why we decrease this value for every failed attempt
      targetSize = max(minSize.toDouble(), generatedSize - difference * 1.6);
      debugPrint(
          'Set target webp size to ${(targetSize / 1024).toStringAsFixed(2)}KB');
      final encodingConfig = EncodingConfig(
          losless: losless,
          quality: 100,
          targetSize: max(1, targetSize ~/ frames.length),
          targetPsnr: 0,
          segments: 1,
          noiseShaping: 50,
          alphaCompression: true,
          alphaQuality: 0,
          pass: 10,
          showCompressed: false,
          partitions: 0,
          partitionLimit: 0,
          useSharpYuv: false,
          alphaFiltering: AlphaFilter.fast,
          filter: const Filter.strong(FilterConfig(strength: 60, sharpness: 0)),
          method: 6);
      frames = await upscaleFramesWithPadding(
          frames: frames, width: 512, height: 512);
      upscaled = await encode(frames: frames, config: encodingConfig);
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

  Map<String, dynamic> toJson() => {
        'identifier': identifier.toString(),
        'imagePath': imagePath,
        'emojis': emojis,
        'isAnimated': isAnimated
      };
}
