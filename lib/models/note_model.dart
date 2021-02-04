import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../entitie/entities.dart';

class Note extends Equatable {
  final String id;
  final String userId;
  final String content;
  final Color color;
  final DateTime timestamp;

  const Note({
    this.id,
    @required this.userId,
    @required this.content,
    @required this.color,
    @required this.timestamp,
  });

  factory Note.fromEntity(NoteEntity entity) {
    return Note(
      id: entity.id,
      userId: entity.userId,
      content: entity.content,
      color: HexColor(entity.color),
      timestamp: entity.timestamp.toDate(),
    );
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      userId: userId,
      content: content,
      color: '#${color.value.toRadixString(16)}',
      timestamp: Timestamp.fromDate(timestamp),
    );
  }

  Note copy({
    String id,
    String userId,
    String content,
    Color color,
    DateTime timestamp,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      color: color ?? this.color,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object> get props => [id, userId, content, color, timestamp];

  @override
  String toString() => '''Note {
      id: $id,
      userId: $userId,
      content: $content,
      color: $color,
      timestamp: $timestamp,
    }''';
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColotFromHex(hexColor));

  static int _getColotFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }
}
