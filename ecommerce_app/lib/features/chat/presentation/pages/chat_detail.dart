import 'package:ecommerce_app/features/chat/presentation/widgets/message_bubble.dart';
import 'package:ecommerce_app/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/presentation/bloc/message/message_bloc.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request messages via socket when page opens
    context.read<MessageBloc>().add(MessageSocketConnectionRequested(widget.chat));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessagesMessageLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MessageLoadFailure) {
                  return const Center(child: Text("Failed to load messages"));
                }

                final messages = state.messages;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true, // latest at bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isMe = msg.sender.id == "CURRENT_USER_ID"; // Replace with logged-in user id
                    return MessageBubble(
                      content: msg.content,
                      type: msg.type,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          MessageInputBar(
            controller: _controller,
            onSend: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<MessageBloc>().add(
                  MessageSent(widget.chat, _controller.text.trim(), "text"),
                );
                _controller.clear();
              }
            },
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage('assets/images/avatar.png')), // Replace
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Annel Ellison", style: TextStyle(color: Colors.black)),
              Text("Online", style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.black)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.videocam, color: Colors.black)),
      ],
    );
  }
}