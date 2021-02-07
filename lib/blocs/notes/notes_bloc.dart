import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final AuthRepository _authRepository;
  final NotesRepository _notesRepository;

  StreamSubscription _notesSubscription;

  NotesBloc({
    @required AuthRepository authRepository,
    @required NotesRepository notesRepository,
  })  : _authRepository = authRepository,
        _notesRepository = notesRepository,
        super(NotesInitial());

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    if (event is FetchNotes) {
      yield* _mapFetchNotesToState();
    } else if (event is UpdateNotes) {
      yield* _mapUpdateNotesToState(event);
    }
  }

  Stream<NotesState> _mapFetchNotesToState() async* {
    yield NotesLoading();
    try {
      final User currentUser = await _authRepository.getCurrentUser();

      _notesSubscription?.cancel();

      _notesSubscription = _notesRepository
          .streamNotes(userId: currentUser.id)
          .listen((notes) => add(UpdateNotes(notes: notes)));
    } catch (err) {
      print(err);
      yield NotesError();
    }
  }

  Stream<NotesState> _mapUpdateNotesToState(UpdateNotes event) async* {
    yield NotesLoaded(notes: event.notes);
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();

    return super.close();
  }
}
