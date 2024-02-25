// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/features/glossary/data/models/glossary_model.dart';

abstract class GlossaryDataSource {
  /// Get glossaries
  Future<List<GlossaryModel>> getGlossaries({
    String query = '',
    int offset = 0,
    int limit = 0,
  });
}

class GlossaryDataSourceImpl implements GlossaryDataSource {
  final http.Client client;

  GlossaryDataSourceImpl({required this.client});

  @override
  Future<List<GlossaryModel>> getGlossaries({
    String query = '',
    int offset = 0,
    int limit = 0,
  }) {
    // TODO: implement getGlossaries
    throw UnimplementedError();
  }
}
