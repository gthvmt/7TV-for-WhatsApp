import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seventv_for_whatsapp/models/settings.dart';
import 'package:seventv_for_whatsapp/models/seventv.dart';
import 'package:seventv_for_whatsapp/screens/stickerpacks.dart';
import 'package:seventv_for_whatsapp/services/notification_service.dart';
import 'package:seventv_for_whatsapp/widgets/create_stickerpack_dialog.dart';
import 'package:seventv_for_whatsapp/widgets/emote_emoji_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../models/whatsapp.dart';
import 'stickerpack.dart' as views;

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  static const _addToExistingPackLabel = 'Add to existing sticker pack';
  static const _createNewPackLabel = 'Create new sticker pack';
  static const _chunkSize = 30;
  final _api = SevenTv();
  final List<Emote> _loadedEmotes = <Emote>[];
  final _searchController = TextEditingController();
  final _notificationService = NotificationService();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _scrollController = ScrollController();
  bool _isSearchMode = false;
  bool _isLoading = false;
  StreamIterator<Stream<Emote>>? _emoteStream;
  bool _moreAvailable = true;

  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 150.0,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _notificationService.initialize();
    _scrollController.addListener(() async {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        await getEmotes();
      }
    });
    loadTrending();
  }

  Future loadTrending() async {
    setState(() {
      _isLoading = true;
      _moreAvailable = true;
      _loadedEmotes.clear();
    });
    _emoteStream = StreamIterator(_api.getTrending(_chunkSize));
    await getEmotes();
  }

  Future search(searchText) async {
    setState(() {
      _isLoading = true;
      _moreAvailable = true;
      _loadedEmotes.clear();
    });
    _emoteStream = StreamIterator(_api.search(searchText, _chunkSize));
    await getEmotes();
  }

  Future getEmotes() async {
    if (!_moreAvailable) {
      return;
    }
    var stream = _emoteStream;
    if (stream != null) {
      debugPrint('loading more emotes');
      try {
        int fetchedEmoteCount = 0;
        final streamIsExhausted = !(await stream.moveNext());
        if (_isLoading) {
          setState(() => _isLoading = false);
        }
        if (!streamIsExhausted) {
          await for (final emote in stream.current) {
            fetchedEmoteCount++;
            setState(() => _loadedEmotes.add(emote));
          }
        }
        if (fetchedEmoteCount < _chunkSize || streamIsExhausted) {
          debugPrint('stream is exhausted');
          setState(() => _moreAvailable = false);
        }
      } catch (_) {}
    }
  }

  void _toggleSearchMode() => _isSearchMode = !_isSearchMode;

  TextField _createSearchField() => TextField(
        autofocus: true,
        controller: _searchController,
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration.collapsed(
          hintText: 'Search emote(s)',
          hintStyle: TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
        onSubmitted: search,
      );

  void _emoteTapped(Emote emote) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(content: Image.network(emote.getMaxSizeUrl().toString()), actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close')),
            OutlinedButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.of(dialogContext).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) => EmoteEmojiPicker(emote, [
                          EmoteEmojiAction(_addToExistingPackLabel, _createStickerAndAddToPack),
                          EmoteEmojiAction(_createNewPackLabel, (ctx, emote, emojis) async {
                            var stickerPack = await _emoteToStickerPack(emote, emojis);
                            if (stickerPack == null) {
                              return;
                            }
                            debugPrint(
                                'sticker saved at ${(await WhatsApp.getStickerDirectory()).path}');
                          }),
                        ])));
              },
            ),
          ]);
        });
  }

  Future<void> _createStickerAndAddToPack(BuildContext _, Emote emote, List<String> emojis) async {
    //TODO: minor performance improvement if we download the full webp in the background here after returning whether
    //it is animated or not and then pass it when creating the Sticker
    final emoteIsAnimated = await emote.host!.checkIfAnimated(emote.getMaxSizeFile());
    debugPrint('emote is animated: $emoteIsAnimated');
    if (!mounted) {
      return;
    }
    final selectedPack = await Navigator.push<StickerPack>(
        context,
        MaterialPageRoute(
            builder: (ctx) => StickerPacks(
                  (pack) {
                    Navigator.pop(ctx, pack);
                    return null;
                  },
                  filter: (pack) => (pack.isAnimated ?? emoteIsAnimated) != emoteIsAnimated,
                )));
    if (selectedPack != null) {
      debugPrint('selected stickerpack ${selectedPack.name}');
      final sticker = await _emoteToSticker(emote, emojis);
      selectedPack.addSticker(sticker);
      selectedPack.isAnimated = emoteIsAnimated;
      selectedPack.save();
      debugPrint('added sticker "${sticker.identifier}" to stickerpack "${selectedPack.name}"');
    }
  }

  Future<StickerPack?> _emoteToStickerPack(Emote emote, List<String> emojis) async {
    final settings = await SettingsManager.load();
    if (context.mounted) {
      final stickerPack = await showDialog<StickerPack>(
          context: context,
          builder: (dialogContext) {
            return CreateStickerPackDialog(
                defaultName: emote.name, defaultPublisher: settings.defaultPublisher);
          });
      if (stickerPack != null) {
        var sticker = await _emoteToSticker(emote, emojis);
        stickerPack.addSticker(sticker);
        stickerPack.isAnimated = sticker.isAnimated;
        await stickerPack.save();
        debugPrint('added sticker to pack - isAnimated: ${sticker.isAnimated}');
      }
    }
    return null;
  }

  Future<Sticker> _emoteToSticker(Emote emote, List<String> emojis) async {
    await _notificationService.startProcessing(emote.id, emote.name);
    try {
      //TODO: button to go to stickerpack
      final sticker = await Sticker.fromEmote(emote, emojis);
      _messengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text('Done processing \'${emote.name}\'')));
      return sticker;
    } finally {
      await _notificationService.endProcessing(emote.id);
    }
  }

  Future<void> goToStickerPacks() async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return StickerPacks(
        (pack) async {
          var state = await Navigator.push<views.StickerPackState?>(
              context, MaterialPageRoute(builder: (ctx) => views.StickerPack(pack)));
          var isDeleted = state?.isDeleted ?? false;
          debugPrint('isDeleted: $isDeleted');
          return StickerPackSelectedCallbackResult(reloadRequired: state?.isDeleted ?? false);
        },
      );
    }));
  }

  Future<void> goToTrending() async {
    setState(() => _toggleSearchMode());
    await loadTrending();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        key: _messengerKey,
        child: Scaffold(
          appBar: AppBar(
            //TODO: implement willpopscope to go back to trending from search
            title: _isSearchMode ? _createSearchField() : const Text('7TV for WhatsApp'),
            actions: !_isSearchMode
                ? [
                    IconButton(
                        onPressed: () => setState(() => _toggleSearchMode()),
                        icon: const Icon(Icons.search))
                  ]
                : _searchController.text.isNotEmpty
                    ? [
                        IconButton(
                            onPressed: () => setState(() => _searchController.text = ''),
                            icon: const Icon(Icons.clear))
                      ]
                    : null,
            leading: _isSearchMode
                ? IconButton(onPressed: goToTrending, icon: const Icon(Icons.arrow_back))
                : IconButton(onPressed: goToStickerPacks, icon: const Icon(Icons.apps)),
          ),
          body: _isLoading
              ? const Skeleton(gridDelegate: _gridDelegate, searchCunkSize: _chunkSize)
              : _loadedEmotes.isEmpty
                  ? const Center(
                      child: Text(
                      'No emotes found',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ))
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverGrid(
                          gridDelegate: _gridDelegate,
                          delegate: SliverChildListDelegate([
                            for (final emote in _loadedEmotes)
                              GestureDetector(
                                onTap: () => _emoteTapped(emote),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: _buildEmoteImage(emote),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        emote.name,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ]),
                        ),
                        if (_moreAvailable)
                          SliverList(
                              delegate: SliverChildListDelegate([
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          ]))
                      ],
                    ),
        ),
      );

  Widget _buildEmoteImage(Emote emote) {
    final url = emote.getMaxSizeUrl();
    if (url == null) {
      // TODO: should probably not list these broken emotes alltogether
      return const Placeholder();
    }
    return Image.network(url.toString());
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    required SliverGridDelegateWithMaxCrossAxisExtent gridDelegate,
    required int searchCunkSize,
  })  : _gridDelegate = gridDelegate,
        _searchCunkSize = searchCunkSize;

  final SliverGridDelegateWithMaxCrossAxisExtent _gridDelegate;
  final int _searchCunkSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey[350]!,
        child: CustomScrollView(
          slivers: [
            SliverGrid(
                gridDelegate: _gridDelegate,
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                        margin: const EdgeInsets.all(3),
                        decoration: ShapeDecoration(
                            color: Colors.black,
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))),
                    childCount: _searchCunkSize))
          ],
          physics: const NeverScrollableScrollPhysics(),
        ));
  }
}
