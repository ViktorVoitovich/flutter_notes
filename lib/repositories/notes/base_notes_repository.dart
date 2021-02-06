import '../../models/models.dart';
import '../repositories.dart';

abstract class BaseNotesRepository extends BaseRepository {
  Future<Note> addNote({Note note});
  Future<Note> updateNote({Note note});
  Future<Note> deleteNote({Note note});
  Stream<List<Note>> streamNotes({String userId});
}
