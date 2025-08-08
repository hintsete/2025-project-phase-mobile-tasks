import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/network/http.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ecommerce_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/auth/data/model/authenticated_user_model.dart';
import 'package:ecommerce_app/features/auth/data/model/login_model.dart';
import 'package:ecommerce_app/features/auth/data/model/signup_model.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthLocalDataSource local;
  final AuthRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final HttpClient client;

  AuthRepositoryImpl({
    required this.client,
    required this.local,
    required this.remote,
    required this.networkInfo,
  });
  


  @override
  Future<Either<Failure, AuthenticatedUser>> getCurrentUser()async {
    try{
      final user= await local.getUser();
      client.authToken=user.accessToken;
      return right(user);
    }on CacheException{
      return Left(AuthFailure.tokenExpired());
    }
  }

  @override
  Future<Either<Failure, AuthenticatedUser>> login({required String email, required String password})async {
    if(await networkInfo.isConnected){
      try{
        final accessToken=await remote.login(LoginModel(email:email,password:password));
        client.authToken=accessToken.token;
        final user=await remote.getCurrentUser();
        final authenticatedUser=AuthenticatedUserModel(
          id: user.id, 
          name: user.name, 
          email: user.email, 
          accessToken: accessToken.token
        );
        await local.cacheUser(authenticatedUser);
        return Right(authenticatedUser);


      }on ServerException{
        return const Left(ServerFailure('Unable to login'));
      }
    }else{
    return const Left(NetworkFailure());
  }
    
  }

  @override
  Future<Either<Failure, void>> logout() async{
    try{
      await local.clear();
      client.authToken='';
      return const Right(unit);
    }on CacheException{
      return const Left(CacheFailure('Unable to logout'));
    }
    
  }

  @override
  Future<Either<Failure, AuthenticatedUser>> signup({
    required String name, 
    required String email, 
    required String password})async {
    if(await networkInfo.isConnected){
      try{
        await remote.signup(SignupModel(name: name, email: email, password: password));
        // final user=await login(email: email,password: password);
        final loginResult = await remote.login(LoginModel(
          email: email,
          password: password,
        ));
        // 3. Get full user details
      final userModel = await remote.getCurrentUser();

      // 4. Create authenticated user
      final authenticatedUser = AuthenticatedUserModel(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        accessToken: loginResult.token,
      );

      // 5. Cache the user
      await local.cacheUser(authenticatedUser);
      client.authToken = loginResult.token;

      return Right(authenticatedUser);
    } on ServerException {
      return const Left(ServerFailure('Unable to signup'));
    } on AuthenticationException catch (e) {
      return Left(AuthFailure(e.message));
    }
  } else {
    return const Left(NetworkFailure());
  }
    //     client.authToken=user.fold((l)=>'', (r)=> r.accessToken);
    //     return user;

    //   }on ServerException{
    //     return const Left(ServerFailure('Unable to signup'));
    //   }
    // }else{
    //   return const Left(NetworkFailure());
    // }
    
  }}