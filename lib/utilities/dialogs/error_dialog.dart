import 'package:flutter/cupertino.dart';
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
      'Ok': null,
    },
  );
}
