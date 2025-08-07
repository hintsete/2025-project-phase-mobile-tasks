import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:ecommerce_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'signup_usecase_test.mocks.dart';



@GenerateMocks([AuthRepository])

void main(){
  late MockAuthRepository repository;
  late SignupUsecase usecase;
  setUp((){
    repository=MockAuthRepository();
    usecase=SignupUsecase(repository);


  });
  const tName='name';
  const tEmail='email';
  const tPassword='password';
  const tAccessToken='token';

  const tUser=AuthenticatedUser(id: 1, name: tName, email: tEmail, accessToken: tAccessToken);

  test('should return AuthenticatedUser when signup is successful', ()async{
    //arrange
    when(repository.signup(name:tName,email:tEmail,password:tPassword)).thenAnswer((_)async=> const Right(tUser));

    //act
    final result=await usecase(SignupParams(tName, tEmail, tPassword));
    //assert
    expect(result, const Right(tUser));
    verify(repository.signup(name:tName,email:tEmail,password:tPassword));
    verifyNoMoreInteractions(repository);
    
  });




}