import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seventv_for_whatsapp/screens/browser.dart';
import 'package:seventv_for_whatsapp/src/rust/frb_generated.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
var _errorDialogIsVisible = false;

Future<void> main() async {
  await RustLib.init();
  
  FlutterError.onError = (details) {
    FlutterError.presentError(details);

    final error = details.exception.toString().toLowerCase();

    // filter known errors (which should eventually be fixed...)
    if (
        // Some emote images, for example this one https://7tv.app/emotes/64789a4f0c7cd505faf2e7f6
        // fail to load because of some error involving a frame.
        // Probably only fixable by writing a custom ImageProvider(?)
        error.contains('could not getpixels for frame ') ||
            // Sometimes loading an image from the 7TV API just fails. Usually resolved by retrying.
            // There is a NetworkImageWithRetry in the flutter_image package
            // (https://github.com/flutter/packages/blob/main/packages/flutter_image/lib/network.dart)
            // but it does not support animatied images which makes it kinda useless for us.
            // might be a good starting point for our custom ImageProvider which should address the
            // above error as well.
            error.contains('connection closed while receiving data, uri =') ||
            error.contains('connection reset by peer, uri =')
            ) {
      return;
    }

    showErrorDialog(details.exceptionAsString(), details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    showErrorDialog(error.toString(), stack);
    return true;
  };

  runApp(const MyApp());
}

Future<void> showErrorDialog(String errorDescription, StackTrace? stackTrace) async {
  if (_errorDialogIsVisible || _navigatorKey.currentState?.overlay == null) {
    return;
  }
  _errorDialogIsVisible = true;
  const issueTitleMaxLength = 125;

  var issueTitle = errorDescription.length <= issueTitleMaxLength
      ? errorDescription
      : "${errorDescription.substring(0, issueTitleMaxLength - 3)}...";
  final issueBody = '### Exception:\n```\n$errorDescription\n```'
      '${stackTrace?.toString().isEmpty ?? true ? '' : '\n\n### Stacktrace:\n```\n$stackTrace\n```'}\n### Steps to reproduce:\n';
  final newIssueUri = Uri.parse('https://github.com/gthvmt/7TV-for-WhatsApp/issues/new'
      '?title=${Uri.encodeComponent(issueTitle)}'
      '&body=${Uri.encodeComponent(issueBody)}');

  await showDialog(
      context: _navigatorKey.currentState!.overlay!.context,
      builder: (context) => AlertDialog(
            title: const Text('Oops!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Looks like you\'ve run into an error:'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  constraints:
                      BoxConstraints(maxHeight: max(MediaQuery.of(context).size.height * .4, 50)),
                  width: double.infinity,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                        child: Text(
                            errorDescription +
                                (stackTrace?.toString().isEmpty ?? true
                                    ? ''
                                    : '\n\nStacktrace:\n$stackTrace'),
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Theme.of(context).colorScheme.error))),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Feel free to open up a github issue.'
                    '(Please make sure there aren\'t any similar issues open already 😅)')
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async => await launchUrl(newIssueUri),
                  child: const Text('Open an issue')),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
            ],
          ));
  _errorDialogIsVisible = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    var theme = ThemeData.from(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color(0x00f49236), brightness: Brightness.dark),
        useMaterial3: true);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: '7TV for WhatsApp',
      theme: theme,
      home: const Browser(),
    );
  }
}