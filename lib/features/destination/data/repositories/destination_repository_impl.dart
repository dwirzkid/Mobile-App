import 'dart:async';
import 'dart:io';

import 'package:course_travel/core/error/execeptins.dart';
import 'package:course_travel/core/error/failures.dart';
import 'package:course_travel/core/platform/network_info.dart';
import 'package:course_travel/features/destination/data/datasource/destination_local_data_source.dart';
import 'package:course_travel/features/destination/data/datasource/destination_remote_data_source.dart';
import 'package:course_travel/features/destination/domain/entities/destination_entity.dart';
import 'package:course_travel/features/destination/domain/repositories/destination_repository.dart';
import 'package:dartz/dartz.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final NetworkInfo networkInfo;
  final DestinationLocalDataSource localDataSource;
  final DestinationRemoteDataSource remoteDataSource;

  DestinationRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<DestinationEntity>>> all() async{
    bool online = await networkInfo.isConnected();
    if(online) {
      try {
        final result = await remoteDataSource.all();
      await localDataSource.cacheAll(result);
      return Right(result.map((e) => e.toEntity).toList());
      } on TimeoutException{
        return const Left(TimeoutFailure('Timeout no response'));
      }on NotFoundException{
        return const Left(NotFoundFailure('Data not found'));
      } on ServerException {
        return const Left(ServerFailure('Server error'));
      }
    } else{     
      try {
        final result = await localDataSource.getAll();      
      return Right(result.map((e) => e.toEntity).toList());
      } on CachedException{
      return const Left(CachedFailure('Data is not present'));
    }      
    } 
  }

  @override
  Future<Either<Failure, List<DestinationEntity>>> search(String query) async{
    try {
        final result = await remoteDataSource.search(query);      
      return Right(result.map((e) => e.toEntity).toList());
      } on TimeoutException{
        return const Left(TimeoutFailure('Timeout no response'));
      }on NotFoundException{
        return const Left(NotFoundFailure('Data not found'));
      } on ServerException {
        return const Left(ServerFailure('Server error'));
      } on SocketException{
        return const Left(ConnectionFailure('Failed connect to the network'));
      }
  }

  @override
  Future<Either<Failure, List<DestinationEntity>>> top() async{
    try {
        final result = await remoteDataSource.top();      
      return Right(result.map((e) => e.toEntity).toList());
      } on TimeoutException{
        return const Left(TimeoutFailure('Timeout no response'));
      }on NotFoundException{
        return const Left(NotFoundFailure('Data not found'));
      } on ServerException {
        return const Left(ServerFailure('Server error'));
      } on SocketException{
        return const Left(ConnectionFailure('Failed connect to the network'));
      }
  }
}