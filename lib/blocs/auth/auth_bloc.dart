import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(Unauthenticated());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is Login) {
      yield* _mapLogindToState();
    } else if (event is Logout) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      User currentUser = await _authRepository.getCurrentUser();

      if (currentUser == null) {
        currentUser = await _authRepository.loginAnonymously();
      }

      if (_authRepository.isAnonymous()) {
        yield Anonymous(currentUser);
      } else {
        yield Authenticated(currentUser);
      }
    } catch (err) {
      print(err);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLogindToState() async* {
    try {
      User currentUser = await _authRepository.getCurrentUser();
      yield Authenticated(currentUser);
    } catch (err) {
      print(err);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLogoutToState() async* {
    try {
      await _authRepository.logout();
      yield* _mapAppStartedToState();
    } catch (err) {
      print(err);
      yield Unauthenticated();
    }
  }
}
