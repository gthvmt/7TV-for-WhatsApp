import 'package:flutter/material.dart';
import 'package:seventv_for_whatsapp/models/whatsapp.dart';

class CreateStickerPackDialog extends StatefulWidget {
  final String? defaultName;
  final String defaultPublisher;

  const CreateStickerPackDialog({super.key, this.defaultName, this.defaultPublisher = '7TV for WhatsApp'});

  @override
  State<CreateStickerPackDialog> createState() => _CreateStickerPackDialogState();

  Future<StickerPack?> show(BuildContext context) => showDialog<StickerPack>(context: context, builder: (_) => this);
}

class _CreateStickerPackDialogState extends State<CreateStickerPackDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController publisherController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.defaultName);
    publisherController = TextEditingController(text: widget.defaultPublisher);

    updateState() => setState(() {});

    nameController.addListener(updateState);
    publisherController.addListener(updateState);
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = _formKey.currentState?.validate() ?? false;
    return Dialog(
      child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: nameController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
                      validator: (name) => name?.isEmpty ?? true
                          ? "Can't be empty"
                          : name!.length > 128
                              ? "Too long"
                              : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: publisherController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Publisher'),
                      validator: (publisher) => publisher?.isEmpty ?? true
                          ? "Can't be empty"
                          : publisher!.length > 128
                              ? "Too long"
                              : null,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: canCreate
                              ? () async {
                                  var stickerPack =
                                      StickerPack.withDefaults(nameController.text, publisherController.text);
                                  await stickerPack.save();
                                  debugPrint('created sticker pack');
                                  if (context.mounted) {
                                    Navigator.pop(context, stickerPack);
                                  }
                                }
                              : null,
                          child: const Text('Create Sticker Pack')),
                    )
                  ],
                ),
              ))),
    );
  }
}
