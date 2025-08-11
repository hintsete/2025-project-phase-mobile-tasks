import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';

import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';

class GetMyChats {
  final ChatRepository repository;

  const GetMyChats(this.repository);

  Future<Either<Failure, List<Chat>>> call(NoParams params) async{
    return await repository.getUserChats();
  }
}