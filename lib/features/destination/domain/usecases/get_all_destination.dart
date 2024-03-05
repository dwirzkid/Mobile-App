import 'package:course_travel/core/error/failures.dart';
import 'package:course_travel/features/destination/domain/entities/destination_entity.dart';
import 'package:course_travel/features/destination/domain/repositories/destination_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllDestinationUseCase {
  final DestinationRepository _repository;

  GetAllDestinationUseCase(this._repository);

  Future<Either<Failure, List<DestinationEntity>>> call() {
    return _repository.all();
  }
}

