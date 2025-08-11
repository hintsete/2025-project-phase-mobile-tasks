import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';

class InitiateChat implements Usecase<Chat,InitiateChatParams> {
  final ChatRepository repository;
  const InitiateChat(this.repository);

  @override
  Future<Either<Failure, Chat>> call(InitiateChatParams params) async {
    return await repository.getOrCreateChat(params.receiver);
   
  }

 
}
class InitiateChatParams extends Equatable{

  final User receiver;
  const InitiateChatParams(this.receiver);
  
  @override
  // TODO: implement props
  List<Object?> get props => [receiver];
}