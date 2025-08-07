import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase extends Usecase<void,NoParams>{
  final AuthRepository repository;
  LogoutUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params)async {
    return await repository.logout();
  }

  
}