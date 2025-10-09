import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme.dart';
import '../../utils/components/gradient_backdrop.dart';
import '../../providers/voice_chat_provider.dart';
import '../../models/message.dart';
import '../../utils/components/primary_back_button.dart';
import 'components/message_bubble.dart';
import 'chat_text_screen.dart';
import 'components/mic_button.dart';

class ChatVoiceScreen extends StatefulWidget {
  static const String routeName = '/chat-voice';

  final String? roleId;
  final String? roleName;
  final String? roleDescription;
  final bool isPremium;

  const ChatVoiceScreen({
    super.key,
    this.roleId,
    this.roleName,
    this.roleDescription,
    this.isPremium = true,
  });

  @override
  State<ChatVoiceScreen> createState() => _ChatVoiceScreenState();
}

class _ChatVoiceScreenState extends State<ChatVoiceScreen>
    with SingleTickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return ChangeNotifierProvider(
      create: (_) => VoiceChatProvider(),
      child: Scaffold(
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
                  _buildHeader(context),

                  // ──────────────────────────────
                  // 🔹 Chat Messages
                  // ──────────────────────────────
                  Expanded(
                    child: Consumer<VoiceChatProvider>(
                      builder: (context, provider, _) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            final message = provider.messages[index];
                            return MessageBubble(
                              message: message,
                              onDelete: () {},
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // ──────────────────────────────
                  // 🔹 Voice Controls
                  // ──────────────────────────────
                  _buildVoiceControls(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glassLight.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
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
                  widget.roleName ?? 'Voice Chat',
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
        ],
      ),
    );
  }

  Widget _buildVoiceControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<VoiceChatProvider>(
            builder: (context, provider, _) {
              // Add permission error handling
              if (provider.hasError) {
                print(provider.errorMessage);
                return Column(
                  children: [
                    MicButton(
                      isListening: false,
                      onTap: () => provider.startListening(),
                      logoAsset: 'assets/brand_logos/logo_png.png',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'Microphone access needed',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }

              return MicButton(
                isListening: provider.isRecording,
                onTap: () {
                  if (provider.isRecording) {
                    provider.stopListening();
                  } else {
                    provider.startListening();
                  }
                },
                logoAsset: 'assets/brand_logos/logo_png.png',
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<VoiceChatProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  if (provider.transcript.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        provider.transcript,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.keyboard, size: 24),
                        label: const Text('Type'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Stop any ongoing voice interactions before switching
                          if (provider.isRecording) {
                            provider.stopListening();
                          }
                          context.pushReplacement(
                            ChatTextScreen.routeName,
                            extra: {
                              'roleId': widget.roleId,
                              'roleName': widget.roleName,
                              'roleDescription': widget.roleDescription,
                              'isPremium': widget.isPremium,
                            },
                          );
                        },
                      ),
                      if (widget.isPremium) ...[
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Text(
                              'Continuous',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            CupertinoSwitch(
                              value: provider.isContinuousMode,
                              onChanged: (value) {
                                if (provider.isRecording) {
                                  provider.stopListening();
                                }
                                provider.toggleContinuousMode(value);
                              },
                              activeTrackColor: Colors.blueAccent,
                              inactiveTrackColor:
                                  Colors.white.withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// class _MessageBubble extends StatelessWidget {
//   final Message message;
//
//   const _MessageBubble({required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     final isUser = message.role == 'user';
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           if (!isUser) const SizedBox(width: 40),
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//               decoration: BoxDecoration(
//                 color: isUser ? AppColors.primaryLight : AppColors.glassLight.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message.content,
//                     style: TextStyle(
//                       color: isUser ? Colors.white : Colors.white.withValues(alpha: 0.9),
//                       fontSize: 16,
//                     ),
//                   ),
//                   if (!isUser && context.read<VoiceChatProvider>().state != VoiceState.speaking) ...[
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: () => context.read<VoiceChatProvider>().speak(message.content),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.play_arrow,
//                             color: Colors.white.withValues(alpha: 0.7),
//                             size: 20,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Play',
//                             style: TextStyle(
//                               color: Colors.white.withValues(alpha: 0.7),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           if (isUser) const SizedBox(width: 40),
//         ],
//       ),
//     );
//   }
// }
