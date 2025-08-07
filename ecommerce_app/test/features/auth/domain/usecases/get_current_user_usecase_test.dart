import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/get_current_user.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_current_user_usecase_test.mocks.dart';



@GenerateMocks([AuthRepository])

void main(){
  late MockAuthRepository repository;
  late GetCurrentUser usecase;
  setUp((){
    repository=MockAuthRepository();
    usecase=GetCurrentUser(repository);


  });
  const tName='name';
  const tEmail='email';
  // const tPassword='password';
  const tAccessToken='token';

  const tUser=AuthenticatedUser(id: 1, name: tName, email: tEmail, accessToken: tAccessToken);


  test('should return AuthenticatedUser from repository when cached', ()async{
    //arrange
    when(repository.getCurrentUser()).thenAnswer((_)async=> Right(tUser));
    //act
    final result=await usecase(NoParams());

    //assert
    expect(result, Right(tUser));
    verify(repository.getCurrentUser());
    verifyNoMoreInteractions(repository);

  });
}