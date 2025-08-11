import 'package:ecommerce_app/core/presentation/routes/app_routes.dart';

import 'package:ecommerce_app/features/chat/presentation/bloc/chat/chat_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:go_router/go_router.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatsBloc>().add(ChatsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top status bar (Stories)
            _buildTopStatusBar(),

            // Chat list
            Expanded(
              child: BlocBuilder<ChatsBloc, ChatsState>(
                builder: (context, state) {
                  if (state is ChatsLoadInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                      ),
                    );
                  }
                  if (state is ChatsFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Error: ${state.message}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // If no chats, show dummy data for now
                  final List<Chat> chats = state.chats.isEmpty
                      ? _dummyChats()
                      : state.chats;

                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(left: 80),
                        height: 1,
                        color: Colors.grey[100],
                      ),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return _buildChatTile(chat, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStatusBar() {
    final List<Map<String, String>> statuses = [
      {
        "name": "My status",
        "avatar": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face"
      },
      {
        "name": "Adil",
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face"
      },
      {
        "name": "Marine",
        "avatar": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face"
      },
      {
        "name": "Dean",
        "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face"
      },
      {
        "name": "Max",
        "avatar": "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&h=150&fit=crop&crop=face"
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF357ABD),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isMyStatus = index == 0;
            
            return Padding(
              padding: EdgeInsets.only(
                right: index == statuses.length - 1 ? 0 : 24,
              ),
              child: GestureDetector(
                onTap: () {
                  // Handle status tap
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isMyStatus 
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                        gradient: isMyStatus 
                          ? null 
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(status["avatar"]!),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      status["name"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChatTile(Chat chat, int index) {
    final User otherUser = chat.user1;
    
    // Enhanced dummy data with realistic messages and avatars
    final List<Map<String, dynamic>> enhancedData = [
      {
        "name": "Alex Linderson",
        "message": "How are you today?",
        "time": "2 min ago",
        "avatar": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
        "unreadCount": 0,
      },
      {
        "name": "Team Align",
        "message": "Don't miss to attend the meeting.",
        "time": "2 min ago",
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "unreadCount": 3,
      },
      {
        "name": "John Abraham",
        "message": "Hey, Can you please review the...",
        "time": "2 min ago",
        "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
        "unreadCount": 0,
      },
      {
        "name": "Sabila Sayma",
        "message": "How are you today?",
        "time": "2 min ago",
        "avatar": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "unreadCount": 0,
      },
      {
        "name": "John Borino",
        "message": "Have a good day 🌸",
        "time": "2 min ago",
        "avatar": "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&h=150&fit=crop&crop=face",
        "unreadCount": 0,
      },
      {
        "name": "Angel Dayna",
        "message": "How are you today?",
        "time": "2 min ago",
        "avatar": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
        "unreadCount": 0,
      },
    ];

    final data = index < enhancedData.length 
        ? enhancedData[index] 
        : enhancedData[0];

    return InkWell(
       onTap: () {
    // context.goNamed(Routes.chatDetail, extra: chat);
    context.push(Routes.chatDetail, extra: chat);

  },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(data["avatar"]),
                ),
                if (index == 1) // Show online indicator for Team Align
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Chat content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data["message"],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Time and unread indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data["time"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (data["unreadCount"] > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      data["unreadCount"].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Chat> _dummyChats() {
    return [
      Chat(
        id: "1",
        user1: const User(
          id: "u1",
          name: "Alex Linderson",
          email: "alex@example.com",
        ),
        user2: const User(
          id: "u2",
          name: "Me",
          email: "me@example.com",
        ),
      ),
      Chat(
        id: "2",
        user1: const User(
          id: "u3",
          name: "Team Align",
          email: "team@example.com",
        ),
        user2: const User(
          id: "u2",
          name: "Me",
          email: "me@example.com",
        ),
      ),
      Chat(
        id: "3",
        user1: const User(
          id: "u4",
          name: "John Abraham",
          email: "john@example.com",
        ),
        user2: const User(
          id: "u2",
          name: "Me",
          email: "me@example.com",
        ),
      ),
      Chat(
        id: "4",
        user1: const User(
          id: "u5",
          name: "Sabila Sayma",
          email: "sabila@example.com",
        ),
        user2: const User(
          id: "u2",
          name: "Me",
          email: "me@example.com",
        ),
      ),
      Chat(
        id: "5",
        user1: const User(
          id: "u6",
          name: "John Borino",
          email: "johnb@example.com",
        ),
        user2: const User(
          id: "u2",
          name: "Me",
          email: "me@example.com",
        ),
      ),
      Chat(
        id: "6",
        user1: const User(
          id: "u7",
          name: "Angel Dayna",
          email: "angel@example.com",
        ),
        user2: const User(
          id: "u2",
          name: "Me",
          email: "me@example.com",
        ),
      ),
    ];
  }
}
