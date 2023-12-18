import 'package:flutter/material.dart';
import 'package:seventv_for_whatsapp/models/whatsapp.dart';
import 'package:seventv_for_whatsapp/widgets/create_stickerpack_dialog.dart';


class StickerPackSelectedCallbackResult {
  final bool reloadRequired;

  StickerPackSelectedCallbackResult({required this.reloadRequired});
}

class StickerPacks extends StatefulWidget {
  final Future<StickerPackSelectedCallbackResult>? Function(StickerPack) onStickerPackSelected;
  final bool Function(StickerPack)? filter;
  const StickerPacks(this.onStickerPackSelected, {super.key, this.filter});

  @override
  State<StickerPacks> createState() => StickerPacksState();
}

class StickerPacksState extends State<StickerPacks> {
  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 150.0,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 1.0,
  );

  final List<StickerPack> _loadedPacks = <StickerPack>[];

  Future<void> _loadPacks() async {
    _loadedPacks.clear();
    debugPrint('loading stickerpacks');
    for (var pack in await WhatsApp.loadStoredStickerPacks()) {
      setState(() => _loadedPacks.add(pack));
      debugPrint('loaded stickerpack ${pack.name} - isAnimated: ${pack.isAnimated}');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPacks();
  }

  Future<void> _createNew() async {
    // showDialog(context: context, builder: (ctx) => const CreateStickerPackDialog());
    final newStickerPack = await const CreateStickerPackDialog().show(context);
    if (newStickerPack != null) {
      setState(() => _loadedPacks.add(newStickerPack));
    }
  }

  @override
  //TODO: display text when no sticker packs exist yet
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sticker Packs'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverGrid(
              gridDelegate: _gridDelegate,
              delegate: SliverChildListDelegate([for (final pack in _loadedPacks) _buildPackContainer(pack)]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNew,
          child: const Icon(Icons.add),
        ),
      );

  Widget _buildPackContainer(StickerPack pack) {
    final isFiltered = widget.filter?.call(pack) ?? false;
    final child = Stack(
      children: [
        // Image.file(io.File(pack.trayImageFile)),

        Center(
          child: Image.asset(
            pack.trayImageFile,
            colorBlendMode: isFiltered ? BlendMode.modulate : null,
            color: isFiltered ? const Color.fromARGB(255, 100, 100, 100) : null,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            pack.name,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
    return isFiltered
        ? Opacity(
            opacity: .33,
            child: child,
          )
        : GestureDetector(
            onTap: () async =>
                (await widget.onStickerPackSelected(pack))?.reloadRequired == true ? await _loadPacks() : null,
            child: child);
  }
}
