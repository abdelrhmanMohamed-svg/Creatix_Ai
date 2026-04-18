import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/repositories/example_repository.dart';
import '../datasources/example_datasource.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleDatasource datasource;

  ExampleRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ExampleEntity>>> getExamples() async {
    try {
      final models = await datasource.getExamples();
      return Right(models);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, ExampleEntity>> getExampleById(String id) async {
    try {
      final model = await datasource.getExampleById(id);
      return Right(model);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, ExampleEntity>> createExample(String name) async {
    try {
      final model = await datasource.createExample(name);
      return Right(model);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExample(String id) async {
    try {
      await datasource.deleteExample(id);
      return const Right(null);
    } catch (e) {
      return Left(FailureHelper.fromException(e));
    }
  }
}
