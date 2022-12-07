import 'package:flutter/material.dart';
import 'package:von_note/extensions/buildcontext/loc.dart';
import 'package:von_note/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
  String title,
) {
  return showGenericDialog(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
