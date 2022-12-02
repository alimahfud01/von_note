import 'package:flutter/material.dart';
import 'package:von_note/services/auth/bloc/auth_bloc.dart';
import 'package:von_note/services/auth/bloc/auth_event.dart';
import 'package:von_note/services/cloud/cloud_note.dart';
import 'package:von_note/services/cloud/firebase_cloud_storage.dart';
import 'package:von_note/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Von Note"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  createUpdateNoteView,
                );
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final logout = await showLogoutDialog(context);
                  if (logout) {
                    if (!mounted) return;
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Waiting for all notes..."),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                if (allNotes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/empty_vector.svg',
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Your note is empty')
                      ],
                    ),
                  );
                } else {
                  return NotesListView(
                    onTap: (note) {
                      Navigator.of(context)
                          .pushNamed(createUpdateNoteView, arguments: note);
                    },
                    onDeleteNote: (note) async {
                      await _noteService.deleteNote(
                          documentId: note.documentId);
                    },
                    notes: allNotes,
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
