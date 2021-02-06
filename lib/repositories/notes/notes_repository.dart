import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../config/paths.dart';
import '../../entitie/entities.dart';
import '../../models/note_model.dart';
import '../repositories.dart';

class NoteRepository extends BaseNotesRepository {
  final FirebaseFirestore _firestore;
  final Duration _timeoutDuration = Duration(seconds: 10);

  NoteRepository({FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  void dispose() {}

  @override
  Future<Note> addNote({@required Note note}) async {
    await _firestore
        .collection(Paths.notes)
        .add(note.toEntity().toDocument())
        .timeout(_timeoutDuration);

    return note;
  }

  @override
  Future<Note> updateNote({@required Note note}) async {
    await _firestore
        .collection(Paths.notes)
        .doc(note.id)
        .update(note.toEntity().toDocument())
        .timeout(_timeoutDuration);

    return note;
  }

  @override
  Future<Note> deleteNote({@required Note note}) async {
    await _firestore
        .collection(Paths.notes)
        .doc(note.id)
        .delete()
        .timeout(_timeoutDuration);

    return note;
  }

  @override
  Stream<List<Note>> streamNotes({@required String userId}) {
    return _firestore
        .collection(Paths.notes)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromEntity(NoteEntity.fromSnapshot(doc)))
            .toList()
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp)));
  }
}
