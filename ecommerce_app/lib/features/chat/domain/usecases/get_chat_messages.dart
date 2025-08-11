import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';

class GetChatMessages {
  final ChatRepository repository;
  
  const GetChatMessages(this.repository);

  Future<Stream<Either<Failure,Message>>> call( GetMessageParams params) async{
    return  await repository.getChatMessages(params.id);
  }



}
class GetMessageParams extends Equatable{
  final String id;

  const GetMessageParams(this.id);
  
  @override

  List<Object?> get props => [id];
}