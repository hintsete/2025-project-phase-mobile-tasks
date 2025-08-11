// import 'package:ecommerce_app/features/chat/presentation/bloc/message/message_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
// import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
// // import 'package:ecommerce_app/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
// // import 'package:intl/intl.dart';

// class ChatScreen extends StatefulWidget {
//   final Chat chat;

//   const ChatScreen({super.key, required this.chat});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToBottom();
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.chat.name ?? 'Chat'),
//             Text(
//               '${widget.chat.memberCount} members, ${widget.chat.onlineCount} online',
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Colors.white70,
//                   ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               // Handle more options
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: BlocBuilder<MessageBloc, MessageState>(
//               builder: (context, state) {
//                 if (state is MessageLoadSuccess) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _scrollToBottom();
//                   });

//                   return ListView.builder(
//                     controller: _scrollController,
//                     reverse: true,
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     itemCount: state.messages.length,
//                     itemBuilder: (context, index) {
//                       final message = state.messages.reversed.toList()[index];
//                       return _buildMessageBubble(message);
//                     },
//                   );
//                 } else if (state is MessageFailure) {
//                   return Center(child: Text(state.message));
//                 }
//                 return const Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Message message) {
//     final isMe = message.sender.id == 'current_user_id'; // Replace with actual current user ID
//     final time = DateFormat('hh:mm a').format(message.createdAt);

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         decoration: BoxDecoration(
//           color: isMe
//               ? Theme.of(context).primaryColor
//               : Theme.of(context).colorScheme.secondaryContainer,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(12),
//             topRight: const Radius.circular(12),
//             bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
//             bottomRight: isMe ? Radius.zero : const Radius.circular(12),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             if (!isMe)
//               Text(
//                 message.sender.name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSecondaryContainer,
//                 ),
//               ),
//             Text(
//               message.content,
//               style: TextStyle(
//                 color: isMe
//                     ? Colors.white
//                     : Theme.of(context).colorScheme.onSecondaryContainer,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               time,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: isMe
//                     ? Colors.white70
//                     : Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Write your message',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 16,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           CircleAvatar(
//             backgroundColor: Theme.of(context).primaryColor,
//             child: IconButton(
//               icon: const Icon(Icons.send, color: Colors.white),
//               onPressed: () {
//                 if (_messageController.text.trim().isNotEmpty) {
//                   context.read<MessageBloc>().add(
//                         MessageSent(
//                           widget.chat,
//                           _messageController.text,
//                           'text',
//                         ),
//                       );
//                   _messageController.clear();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }