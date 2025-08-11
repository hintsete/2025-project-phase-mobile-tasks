// import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
// import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_messages.dart';
// import 'package:ecommerce_app/features/chat/domain/usecases/send_message.dart';
// import 'package:ecommerce_app/features/chat/presentation/bloc/chat/chat_bloc.dart';
// import 'package:ecommerce_app/features/chat/presentation/bloc/message/message_bloc.dart';
// import 'package:ecommerce_app/injection_container.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';

// class ChatsListScreen extends StatelessWidget {
//   const ChatsListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chats'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // Implement search functionality
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Status Header Section
//           _buildStatusHeader(),
//           // Chat List Section
//           Expanded(
//             child: BlocBuilder<ChatsBloc, ChatsState>(
//               builder: (context, state) {
//                 if (state is ChatsLoadSuccess) {
//                   return _buildChatList(state.chats, context);
//                 } else if (state is ChatsFailure) {
//                   return Center(child: Text(state.message));
//                 }
//                 return const Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusHeader() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Column(
//             children: [
//               const CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: CircleAvatar(
//                         radius: 8,
//                         backgroundColor: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text('My status'),
//               const Divider(),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'All',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChatList(List<Chat> chats, BuildContext context) {
//     return ListView.builder(
//       itemCount: chats.length,
//       itemBuilder: (context, index) {
//         final chat = chats[index];
//         final otherUser = _getOtherUser(chat);
//         final lastMessage = chat.lastMessage ?? 'No messages yet';
//         // final time = chat.lastMessageTime != null 
//         //     ? DateFormat('h:mm a').format(chat.lastMessageTime!)
//         //     : '';

//         return ListTile(
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(otherUser.avatarUrl ?? 'https://via.placeholder.com/150'),
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: otherUser.isOnline ? Colors.green : Colors.grey,
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Theme.of(context).scaffoldBackgroundColor,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           title: Text(otherUser.name),
//           subtitle: Text(
//             lastMessage,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           // trailing: Text(
//           //   // time,
//           //   // style: const TextStyle(color: Colors.grey, fontSize: 12),
//           // ),
//           onTap: () {
//             _navigateToChatScreen(context, chat);
//           },
//         );
//       },
//     );
//   }

//   User _getOtherUser(Chat chat) {
//     // Assuming you have current user stored somewhere
//     final currentUserId = 'current_user_id'; // Replace with actual current user ID
//     return chat.user1.id == currentUserId ? chat.user2 : chat.user1;
//   }

//   void _navigateToChatScreen(BuildContext context, Chat chat) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           create: (context) => MessageBloc(
//             getChatMessages: sl<GetChatMessages>(),
//             sendMessage: sl<SendMessage>(),
//           )..add(MessageSocketConnectionRequested(chat)),
//           child: ChatScreen(chat: chat),
//         ),
//       ),
//     );
//   }
// }