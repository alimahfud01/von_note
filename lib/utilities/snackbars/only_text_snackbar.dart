import 'package:flutter/material.dart';

onlyTextSnackbar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));
}
