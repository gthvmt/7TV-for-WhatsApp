import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import '../models/whatsapp.dart' as wa;

class StickerPack extends StatefulWidget {
  final wa.StickerPack stickerPack;
  const StickerPack(this.stickerPack, {super.key});

  @override
  State<StickerPack> createState() => _StickerPackState();
  static const gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 150.0,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 1.0,
  );
}

Future<void> _addToWhatsApp(wa.StickerPack stickerPack) {
  return stickerPack.addToWhatsApp();
}

class _StickerPackState extends State<StickerPack> {
  @override
  void initState() {
    super.initState();
    debugPrint('Stickers in stickerpack "${widget.stickerPack.name}" (${widget.stickerPack.identifier}):');
    for (var sticker in widget.stickerPack.stickers) {
      debugPrint(jsonEncode(sticker.toJson()));
    }
  }

  Future<bool> _delete() async {
    var delete = await showDialog<bool?>(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text('Delete ${widget.stickerPack.name}?'),
                content: const Text(
                    'Deleting this sticker pack will remove all the stickers associated with it. Do you want to proceed?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('Delete', style: TextStyle(color: Theme.of(ctx).colorScheme.error)))
                ]));
    if (!(delete ?? false)) {
      return false;
    }
    var result = await widget.stickerPack.delete();
    if (mounted) {
      Navigator.pop(context, StickerPackState(isDeleted: true));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isValidPack = widget.stickerPack.stickers.length >= 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stickerPack.name),
        actions: [IconButton(onPressed: _delete, icon: const Icon(Icons.delete))],
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: StickerPack.gridDelegate,
            delegate: SliverChildListDelegate([
              for (final sticker in widget.stickerPack.stickers) Image.file(File(sticker.imagePath)),
              // Stack(
              //   children: [
              //   ],
              // )
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: !isValidPack ? const Color.fromARGB(255, 120, 120, 120) : null,
          foregroundColor: !isValidPack ? const Color.fromARGB(255, 70, 70, 70) : null,
          onPressed: !isValidPack ? null : () => _addToWhatsApp(widget.stickerPack),
          label: Row(
            children: const [Icon(Icons.add), SizedBox(width: 2), Text('Add to WhatsApp')],
          )),
    );
  }
}

class StickerPackState {
  final bool isDeleted;

  StickerPackState({required this.isDeleted});
}
