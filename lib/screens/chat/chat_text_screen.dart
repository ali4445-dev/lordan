import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/chat/chat_voice_screen.dart';
import 'package:lordan_v1/utils/components/primary_back_button.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/components/gradient_backdrop.dart';
import 'components/message_bubble.dart';
import '../../theme.dart';

class ChatTextScreen extends StatefulWidget {
  static const String routeName = '/chat-text';

  final String? roleId;
  final String? roleName;
  final String? roleDescription;
  final bool isPremium;

  const ChatTextScreen({
    super.key,
    this.roleId,
    this.roleName,
    this.roleDescription,
    this.isPremium = false,
  });

  @override
  State<ChatTextScreen> createState() => _ChatTextScreenState();
}

class _ChatTextScreenState extends State<ChatTextScreen>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Check for context availability if premium role
    if (widget.isPremium) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatProvider>().checkContext();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
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
    final userProvider = context.watch<UserProvider>();
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                // ──────────────────────────────
                // 🔹 Header
                // ──────────────────────────────
                _buildHeader(),

                // ──────────────────────────────
                // 🔹 Messages List
                // ──────────────────────────────
                Expanded(
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, _) {
                      if (chatProvider.error != null) {
                        return Center(
                          child: Text(
                            'Error: ${chatProvider.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          return MessageBubble(
                            message: message,
                            onDelete: () =>
                                chatProvider.deleteMessage(message.id),
                          );
                        },
                      );
                    },
                  ),
                ),

                // ──────────────────────────────
                // 🔹 Input Bar
                // ──────────────────────────────
                _buildInputBar(
                  roleId: widget.roleId,
                  roleName: widget.roleName,
                  roleDescription: widget.roleDescription,
                  isPremium: widget.isPremium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.glassLight.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          const PrimaryBackButton(),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Image.asset(
                    'assets/brand_logos/logo_png.png',
                    width: 50,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roleName ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if ((widget.roleDescription ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.roleDescription ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Consumer<ChatProvider>(
          //   builder: (context, chatProvider, _) {
          //     if (!widget.isPremium || !chatProvider.hasContext) {
          //       return const SizedBox.shrink();
          //     }
          //     return TextButton.icon(
          //       icon: const Icon(Icons.refresh, size: 16),
          //       label: const Text('Resume'),
          //       style: TextButton.styleFrom(
          //         foregroundColor: Colors.white,
          //         backgroundColor: AppColors.glassLight.withValues(alpha: 0.1),
          //       ),
          //       onPressed: () {
          //         // TODO: Implement context resumption
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildInputBar(
      {String? roleId,
      String? roleName,
      String? roleDescription,
      bool? isPremium}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassLight.withValues(alpha: 0.1),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.blue,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle:
                    TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textController,
                  builder: (context, value, _) {
                    final hasText = value.text.trim().isNotEmpty;

                    if (_textController.text.isEmpty) {
                      return IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/voice.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          width: 30,
                        ),
                        onPressed: () =>
                            context.push(ChatVoiceScreen.routeName, extra: {
                          'roleId': roleId ?? '',
                          'roleName': roleName ?? '',
                          'roleDescription': roleDescription ?? '',
                          'isPremium': isPremium,
                        }),
                      );
                    } else {
                      return IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/arrow_up.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          width: 30,
                        ),
                        onPressed:
                            (!hasText || context.read<ChatProvider>().isLoading)
                                ? null
                                : () async {
                                    final message = value.text;
                                    _textController.clear();
                                    await context
                                        .read<ChatProvider>()
                                        .sendMessage(message);
                                    _scrollToBottom();
                                  },
                      );
                    }
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
                filled: true,
                fillColor: AppColors.glassLight.withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
