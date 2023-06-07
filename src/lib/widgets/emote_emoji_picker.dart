import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:seventv_for_whatsapp/models/seventv.dart';

class EmoteEmojiAction {
  final String text;
  final void Function(BuildContext context, Emote emote, List<String> emojis)
      execute;

  EmoteEmojiAction(this.text, this.execute);
}

class EmoteEmojiPicker extends StatefulWidget {
  final Emote emote;
  final List<EmoteEmojiAction> actions;

  const EmoteEmojiPicker(this.emote, this.actions, {super.key});

  @override
  State<EmoteEmojiPicker> createState() => _EmoteEmojiPickerState();
}

class _EmoteEmojiPickerState extends State<EmoteEmojiPicker> {
  List<String> selectedEmojis = <String>[];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: ElevationOverlay.applySurfaceTint(
                      Theme.of(context).dialogBackgroundColor,
                      Theme.of(context).colorScheme.surfaceTint,
                      6.0),
                  borderRadius: const BorderRadius.all(Radius.circular(28))),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Image.network(
                      widget.emote.getMaxSizeUrl().toString(),
                    ),
                  ),
                  Center(
                      child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: selectedEmojis.isEmpty
                        ? Text(
                            'Choose up to 3 different emojis that aim to represent the emote',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : Text(
                            selectedEmojis.join(),
                            style: const TextStyle(fontSize: 30),
                          ),
                  )),
                  if (selectedEmojis.isNotEmpty) ...[
                    for (final action in widget.actions)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              action.execute(
                                  context, widget.emote, selectedEmojis);
                            },
                            child: Text(action.text)),
                      )
                  ]
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 300,
              child: EmojiPicker(
                onEmojiSelected: (_, emoji) => setState(() {
                  if (selectedEmojis.length < 3 &&
                      !selectedEmojis.contains(emoji.emoji)) {
                    selectedEmojis.add(emoji.emoji);
                  }
                }),
                onBackspacePressed: () {
                  if (selectedEmojis.isNotEmpty) {
                    setState(() => selectedEmojis.removeLast());
                  }
                },
                config: Config(
                  bgColor: Theme.of(context).colorScheme.background,
                  skinToneDialogBgColor: Theme.of(context).colorScheme.background,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).disabledColor,
                  iconColorSelected: Theme.of(context).colorScheme.primary,
                  backspaceColor: Theme.of(context).colorScheme.primary,
                  // Set other colors and properties as needed
                ),
              ),
            )
          ],
        ),
      );
}
