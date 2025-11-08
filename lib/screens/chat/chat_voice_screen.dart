import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/service/trial_service.dart';
import 'package:lordan_v1/utils/components/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/components/gradient_backdrop.dart';
import '../../providers/voice_chat_provider.dart';
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
    this.isPremium = false,
  });

  @override
  State<ChatVoiceScreen> createState() => _ChatVoiceScreenState();
}

class _ChatVoiceScreenState extends State<ChatVoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  // final ScrollController _scrollController = ScrollController();

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  final Map<String, String> languageMap = {
    'en-US': 'English',
    'es-ES': 'Spanish',
    'pt-BR': 'Portuguese',
    'ko-KR': 'Korean',
    'tr-TR': 'Turkish',
    'de-DE': 'German',
    'fr-FR': 'French',
    'ja-JP': 'Japanese',
    'ar-SA': 'Arabic',
    'zh-KR': 'Chinese',
    'nl-NL': 'Dutch',
  };

  String? selectedLanguageCode = 'en-US';

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

    // final provider = context.read<VoiceChatProvider>();
    // provider.onScrollToBottom = _scrollToBottom;
  }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            final message = provider.messages[index];
                            print(message);
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

  // Widget _buildHeader(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: AppColors.glassLight.withValues(alpha: 0.1),
  //       border: Border(
  //         bottom: BorderSide(
  //           color: Colors.white.withValues(alpha: 0.05),
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         const PrimaryBackButton(),
  //         const SizedBox(width: 10),
  //         AnimatedBuilder(
  //           animation: _animationController,
  //           builder: (context, _) {
  //             return Transform.scale(
  //               scale: _scaleAnimation.value,
  //               child: Opacity(
  //                 opacity: _opacityAnimation.value,
  //                 child: Image.asset(
  //                   'assets/brand_logos/logo_png.png',
  //                   width: 50,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //         const SizedBox(width: 15),
  //         Expanded(
  //           flex: 2,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 widget.roleName ?? '',
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color.fromARGB(255, 206, 198, 198),
  //                 ),
  //               ),
  //               // if ((widget.roleDescription ?? '').isNotEmpty) ...[
  //               //   const SizedBox(height: 4),
  //               //   Text(
  //               //     widget.roleDescription ?? '',
  //               //     style: TextStyle(
  //               //       fontSize: 14,
  //               //       color: Colors.white.withValues(alpha: 0.7),
  //               //     ),
  //               //     maxLines: 1,
  //               //     overflow: TextOverflow.ellipsis,
  //               //   ),
  //               // ],
  //             ],
  //           ),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
  //           width: MediaQuery.of(context).size.width * 0.2,
  //           height: MediaQuery.of(context).size.width * 0.15,
  //           decoration: BoxDecoration(
  //             color: const Color(0xFF0D47A1).withOpacity(0.1), // soft blue tint
  //             borderRadius: BorderRadius.circular(18),
  //             border: Border.all(
  //               color: const Color(0xFF1976D2)
  //                   .withOpacity(0.6), // brighter blue border
  //               width: 1.3,
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.blue.withOpacity(0.15),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton<String>(
  //               value: selectedLanguageCode,
  //               menuMaxHeight: 350,
  //               isExpanded: true,
  //               dropdownColor: const Color(0xFF1565C0)
  //                   .withOpacity(0.95), // dropdown background
  //               icon:
  //                   const Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
  //               borderRadius: BorderRadius.circular(14),
  //               style: const TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF0D47A1),
  //               ),

  //               items: languageMap.entries.map((entry) {
  //                 final path =
  //                     'assets/country_flags/${entry.key.split('-')[0]}.svg';
  //                 print(path);
  //                 return DropdownMenuItem<String>(
  //                   value: entry.key,
  //                   child: SvgPicture.asset(path,
  //                       width: MediaQuery.of(context).size.width * 0.1),
  //                 );
  //               }).toList(),
  //               onChanged: (value) {
  //                 if (value != null) {
  //                   GlobalData.setLanguage(selectedLanguageCode);
  //                   setState(
  //                     () => selectedLanguageCode = value,
  //                   );
  //                 }
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side (Back button + logo + role info)
          Expanded(
            child: Row(
              children: [
                const PrimaryBackButton(),
                const SizedBox(width: 10),

                // Animated Logo
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Image.asset(
                          'assets/brand_logos/logo_png.png',
                          height: 35, // match buildTopBar height
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 15),

                // Role name and optional description
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.roleName ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: const Color.fromARGB(255, 206, 198, 198),
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // if ((widget.roleDescription ?? '').isNotEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 3),
                      //     child: Text(
                      //       widget.roleDescription ?? '',
                      //       style: theme.textTheme.bodySmall?.copyWith(
                      //         color: Colors.white.withValues(alpha: 0.7),
                      //         fontSize: 13,
                      //         height: 1.1,
                      //       ),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Right side (Language dropdown styled as user badge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuMaxHeight: 350,
                value: selectedLanguageCode,
                isExpanded: false,
                dropdownColor: const Color(0xFF1565C0)
                    .withOpacity(0.95), // dropdown background
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                borderRadius: BorderRadius.circular(12),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                items: languageMap.entries.map((entry) {
                  final path =
                      'assets/country_flags/${entry.key.split('-')[0]}.svg';
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: SvgPicture.asset(
                      path,
                      width: 40,
                      height: 20,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedLanguageCode = value);
                  }
                },
              ),
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
                        isPremium: widget.isPremium,
                        isListening: false,
                        onTap: () => TrialManager.isTrialExpired
                            ? {
                                showAppSnackbar(
                                    context,
                                    "24 hours trial expired Have to upgrade package to continue chat",
                                    "info"),
                                context.push('/paywall'),
                              }
                            : provider.state == VoiceState.idle
                                ? provider.startListening()
                                : provider.stopListening(
                                    isPremium: widget.isPremium,
                                    language: selectedLanguageCode!,
                                    mode: "voice",
                                    role: widget.roleName!),
                        logoAsset: 'assets/brand_logos/logo_png.png',
                        onLongPress: !widget.isPremium
                            ? () {
                                print(selectedLanguageCode);
                                provider.startListening();
                              }
                            : () {},
                        onLongPressUp: !widget.isPremium
                            ? () {
                                provider.stopListening(
                                    isPremium: widget.isPremium,
                                    language: selectedLanguageCode!,
                                    mode: "voice",
                                    role: widget.roleName!);
                              }
                            : () {}),
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
                isPremium: widget.isPremium,
                isListening: provider.isRecording,
                onTap: widget.isPremium
                    ? () {
                        if (provider.isRecording) {
                          provider.stopListening(
                              isPremium: widget.isPremium,
                              mode: "tts",
                              role: widget.roleName!,
                              language: selectedLanguageCode!);
                        } else {
                          provider.startListening();
                        }
                      }
                    : () {},
                onLongPress: !widget.isPremium
                    ? () {
                        provider.startListening();
                      }
                    : () {},
                onLongPressUp: !widget.isPremium
                    ? () {
                        provider.stopListening(
                            isPremium: widget.isPremium,
                            mode: "tts",
                            role: widget.roleName!,
                            language: selectedLanguageCode!);
                      }
                    : () {},
                logoAsset: 'assets/brand_logos/logo_png.png',
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<VoiceChatProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  // if (provider.transcript.isNotEmpty)
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 16),
                  //   child: Text(
                  //     provider.transcript,
                  //     style: TextStyle(
                  //       color: Colors.white.withValues(alpha: 0.9),
                  //       fontSize: 14,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
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
                              'Flow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            CupertinoSwitch(
                              value: provider.isflowMode,
                              onChanged: (value) {
                                if (provider.isRecording) {
                                  provider.stopListening();

                                  // provider.startFlowMode();
                                }
                                provider.toggleflowMode(value);
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
