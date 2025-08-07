import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignupUsecase extends Usecase<AuthenticatedUser,SignupParams>{
  final AuthRepository repository;
  
   SignupUsecase(this.repository);


  @override
  Future<Either<Failure, AuthenticatedUser>> call(SignupParams params) async{

    if (params.password.length <6){
      return Left(AuthFailure.passwordTooShort());
    }
    
    // throw UnimplementedError();
    return await repository.signup(name: params.name, email: params.email, password: params.password);
  }}

  class SignupParams extends Equatable{
    final String name;
    final String email;
    final String password;
    const SignupParams(this.name,this.email,this.password);
    
      @override
      
      List<Object?> get props => [name,email,password];
  }