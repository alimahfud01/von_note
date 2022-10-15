import 'package:flutter/material.dart';
import 'package:von_note/services/crud/notes_services.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final NoteCallback onDeleteNote;
  final List<DatabaseNote> notes;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.onDeleteNote,
    required this.notes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              notes[index].text,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete)),
          );
        });
  }
}
