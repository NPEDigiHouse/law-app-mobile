// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/glossary_model.dart';

class GlossarySearchHistoryModel extends Equatable {
  final int? id;
  final GlossaryModel? glosarium;
  final DateTime? createdAt;

  const GlossarySearchHistoryModel({
    this.id,
    this.glosarium,
    this.createdAt,
  });

  GlossarySearchHistoryModel copyWith({
    int? id,
    GlossaryModel? glosarium,
    DateTime? createdAt,
  }) {
    return GlossarySearchHistoryModel(
      id: id ?? this.id,
      glosarium: glosarium ?? this.glosarium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory GlossarySearchHistoryModel.fromMap(Map<String, dynamic> map) {
    return GlossarySearchHistoryModel(
      id: map['id'] as int?,
      glosarium: GlossaryModel.fromMap(
        map['glosarium'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? ''),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, glosarium, createdAt];
}
