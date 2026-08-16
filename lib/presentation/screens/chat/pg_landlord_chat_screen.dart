import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/chat_message_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class PGLandlordChatScreen extends StatefulWidget {
  final PGModel pg;
  final AppState appState;

  const PGLandlordChatScreen({
    super.key,
    required this.pg,
    required this.appState,
  });

  @override
  State<PGLandlordChatScreen> createState() => _PGLandlordChatScreenState();
}

class _PGLandlordChatScreenState extends State<PGLandlordChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const List<String> _quickInquiries = [
    'Schedule a visit tomorrow 4 PM',
    'Are 2-sharing AC rooms vacant?',
    'Is Jain food prepared separately?',
    'Is two-wheeler parking available?',
    'What is the security deposit policy?',
  ];

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _msgController.text.trim();
    if (text.isEmpty) return;

    _msgController.clear();
    widget.appState.sendChatMessage(widget.pg.id, text, widget.pg.name);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final messages = widget.appState.getChatForPG(widget.pg.id, widget.pg.name);

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, color: AppColors.marigold, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.pg.name} Manager',
                    style: AppTypography.titleSmall(color: isDark ? Colors.white : AppColors.ink),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Landlord · Online',
                        style: AppTypography.bodySmall(color: isDark ? Colors.white60 : AppColors.inkSoft).copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_rounded, color: AppColors.teal),
            tooltip: 'Call Manager',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling Property Manager at ${widget.pg.contactNumber}'),
                  backgroundColor: AppColors.teal,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick inquiry prompt chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: _quickInquiries.map((inq) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(
                        inq,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: context.appSurface,
                      side: BorderSide(color: context.appBorder),
                      onPressed: () => _sendMessage(inq),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.sender == MessageSender.user;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.teal
                          : (isDark ? const Color(0xFF1E293B) : AppColors.paper),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      border: isUser ? null : Border.all(color: context.appBorder),
                      boxShadow: const [AppColors.softShadow],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: isUser
                                ? Colors.white
                                : (isDark ? Colors.white : AppColors.ink),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(msg.timestamp),
                          style: TextStyle(
                            fontSize: 9,
                            color: isUser
                                ? Colors.white70
                                : (isDark ? Colors.white38 : AppColors.inkSoft),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom message input bar
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              16,
              MediaQuery.of(context).padding.bottom + 10,
            ),
            decoration: BoxDecoration(
              color: context.appSurface,
              border: Border(top: BorderSide(color: context.appBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: context.appBorder),
                    ),
                    child: TextField(
                      controller: _msgController,
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppColors.ink),
                      decoration: const InputDecoration(
                        hintText: 'Type an inquiry message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
