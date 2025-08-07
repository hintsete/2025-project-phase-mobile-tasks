import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';

abstract class AuthRepository {
  Future<Either<Failure,AuthenticatedUser>> signup(
    {required String name, required String email, required String password}
  );
  Future<Either<Failure,AuthenticatedUser>> login(
    {required String email, required String password}
  );
  Future<Either<Failure,void>> logout();
  Future<Either<Failure,AuthenticatedUser>> getCurrentUser();
}