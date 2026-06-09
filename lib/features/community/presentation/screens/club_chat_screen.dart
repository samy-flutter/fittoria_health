import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../cubit/club_chat_cubit.dart';
import '../cubit/club_chat_state.dart';
import '../../data/models/club_models.dart';

class ClubChatScreen extends StatelessWidget {
  final int clubId;
  final String clubName;

  const ClubChatScreen({
    super.key,
    required this.clubId,
    required this.clubName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClubChatCubit>()..initChat(clubId),
      child: _ClubChatView(clubName: clubName),
    );
  }
}

class _ClubChatView extends StatefulWidget {
  final String clubName;

  const _ClubChatView({required this.clubName});

  @override
  State<_ClubChatView> createState() => _ClubChatViewState();
}

class _ClubChatViewState extends State<_ClubChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        elevation: 1,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.fitOrange,
              child: Text(
                widget.clubName.isNotEmpty ? widget.clubName[0].toUpperCase() : 'C',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.clubName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ClubChatCubit, ClubChatState>(
              listener: (context, state) {
                if (state is ClubChatLoaded) {
                  // Delay slightly to let the listview render new items
                  Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                }
              },
              builder: (context, state) {
                if (state is ClubChatLoading || state is ClubChatInitial) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
                }
                if (state is ClubChatError) {
                  return Center(child: Text(state.message, style: GoogleFonts.inter(color: Colors.red)));
                }
                if (state is ClubChatLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet.\nBe the first to say hi!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      // Show sender name only if it's the first message from this sender in a cluster
                      bool showName = !message.isMine && 
                          (index == 0 || state.messages[index - 1].senderPatientId != message.senderPatientId);
                      
                      return _MessageBubble(message: message, showName: showName);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _ChatInputArea(
            controller: _messageController,
            onSend: () {
              if (_messageController.text.trim().isEmpty) return;
              context.read<ClubChatCubit>().sendMessage(_messageController.text);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ClubChatMessage message;
  final bool showName;

  const _MessageBubble({required this.message, required this.showName});

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: showName ? 16 : 4,
          bottom: 4,
          left: message.isMine ? 50 : 0,
          right: message.isMine ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (showName) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  message.senderName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMine 
                    ? AppColors.fitOrange 
                    : (isDark ? AppColors.darkBgSurface : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMine ? 20 : 4),
                  bottomRight: Radius.circular(message.isMine ? 4 : 20),
                ),
                border: message.isMine ? null : Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.body,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: message.isMine 
                          ? Colors.white 
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: message.isMine 
                          ? Colors.white.withValues(alpha: 0.7)
                          : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputArea({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        border: Border(
          top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.fitOrange),
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 12),
          BlocBuilder<ClubChatCubit, ClubChatState>(
            builder: (context, state) {
              final isSending = state is ClubChatLoaded && state.isSending;
              return GestureDetector(
                onTap: isSending ? null : onSend,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.fitOrange,
                    shape: BoxShape.circle,
                  ),
                  child: isSending
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(LucideIcons.send, color: Colors.white, size: 20),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
