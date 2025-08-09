import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase.dart';

import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/logout_usecase.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_usecase_test.mocks.dart';



@GenerateMocks([AuthRepository])

void main(){
  late MockAuthRepository repository;
  late LogoutUsecase usecase;
  setUp((){
    repository=MockAuthRepository();
    usecase=LogoutUsecase(repository);


  });

  test('should logout the user successfully', ()async{
    //arrange
    when(repository.logout()).thenAnswer((_)async=> Right(null));
    //act
    final result=await usecase(NoParams());

    //assert
    expect(result, Right(unit));
    verify(repository.logout());
    verifyNoMoreInteractions(repository);

  });
}