import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser  extends Usecase<AuthenticatedUser,NoParams>{

  final AuthRepository repository;
  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AuthenticatedUser>> call(NoParams params) async{
    //
    return await repository.getCurrentUser();
  }

}