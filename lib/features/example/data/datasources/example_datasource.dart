import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/example_model.dart';

abstract class ExampleDatasource {
  Future<List<ExampleModel>> getExamples();
  Future<ExampleModel> getExampleById(String id);
  Future<ExampleModel> createExample(String name);
  Future<void> deleteExample(String id);
}

class ExampleRemoteDatasource implements ExampleDatasource {
  final SupabaseClient client;

  ExampleRemoteDatasource(this.client);

  @override
  Future<List<ExampleModel>> getExamples() async {
    final response = await client.from('examples').select();
    return response.map((json) => ExampleModel.fromJson(json)).toList();
  }

  @override
  Future<ExampleModel> getExampleById(String id) async {
    final response =
        await client.from('examples').select().eq('id', id).single();
    return ExampleModel.fromJson(response);
  }

  @override
  Future<ExampleModel> createExample(String name) async {
    final response =
        await client.from('examples').insert({'name': name}).select().single();
    return ExampleModel.fromJson(response);
  }

  @override
  Future<void> deleteExample(String id) async {
    await client.from('examples').delete().eq('id', id);
  }
}
