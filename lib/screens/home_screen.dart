import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        context.read<NotesBloc>().add(FetchNotes());
      },
      builder: (context, authState) {
        return Scaffold(
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, notesState) {
              return _buildBody(context, authState, notesState);
            },
          ),
        );
      },
    );
  }

  Stack _buildBody(
    BuildContext context,
    AuthState authState,
    NotesState notesState,
  ) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
                onPressed: () => authState is Authenticated
                    ? context.read<AuthBloc>().add(Logout())
                    : print('go to login'),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.brightness_4),
                  onPressed: () => print('change theme'),
                ),
              ],
            ),
            notesState is NotesLoaded
                ? NotesGrid(
                    notes: notesState.notes,
                    onTap: (note) => print(note),
                  )
                : const SliverPadding(padding: EdgeInsets.zero),
          ],
        ),
        notesState is NotesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
        notesState is NotesError
            ? Center(
                child: Text(
                  'Something went wrong!\nPlease check your connection.',
                  textAlign: TextAlign.center,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
