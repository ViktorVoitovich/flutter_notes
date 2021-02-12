import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';
import 'blocs/simple_bloc_observer.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AppStarted()),
        ),
        BlocProvider<NotesBloc>(
          create: (_) => NotesBloc(
            authRepository: AuthRepository(),
            notesRepository: NotesRepository(),
          ),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc()..add(LoadTheme()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Firebase Notes',
            theme: state.themeData,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
