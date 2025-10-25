import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/message.dart';
import 'package:lordan_v1/providers/auth_provider.dart';
import 'package:lordan_v1/screens/chat/chat_voice_screen.dart';
import 'package:lordan_v1/screens/start/components/language_dropdown.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:lordan_v1/service/trial_service.dart';
import 'package:lordan_v1/utils/components/primary_back_button.dart';
import 'package:lordan_v1/utils/components/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
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
  var _searchQuery = '';

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
  final List<Locale> _allLocales = const [
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('ko'),
    Locale('tr'),
    Locale('de'),
    Locale('fr'),
    Locale('ja'),
    Locale('ar'),
    Locale('zh'),
    Locale('nl'),
  ];

  List<Locale> get _filteredLocales => _allLocales.where((locale) {
        final userProvider = context.read<UserProvider>();
        final label = userProvider.labelFor(locale).toLowerCase();
        final code = locale.languageCode.toLowerCase();

        final query = _searchQuery.toLowerCase();
        return label.contains(query) || code.contains(query);
      }).toList();

  String? selectedLanguageCode = 'en-US';

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final userProvider = Provider.of<UserProvider>(context, listen: false);
    //   userProvider.setLocale(_filteredLocales.first);
    //   for (var locale in _allLocales) {
    //     final String svgPath =
    //         'assets/country_flags/${locale.languageCode}.svg';
    //     final loader = SvgAssetLoader(svgPath);
    //     svg.cache
    //         .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    //   }
    // });
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
          const SizedBox(width: 4),
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
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.1), // soft blue tint
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF1976D2)
                    .withOpacity(0.6), // brighter blue border
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLanguageCode,
                isExpanded: true,
                dropdownColor: const Color(0xFF1565C0)
                    .withOpacity(0.95), // dropdown background
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
                borderRadius: BorderRadius.circular(14),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D47A1),
                ),

                items: languageMap.entries.map((entry) {
                  final path =
                      'assets/country_flags/${entry.key.split('-')[0]}.svg';
                  print(path);
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: SvgPicture.asset(path,
                        width: MediaQuery.of(context).size.width * 0.1),
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

          // SimpleDropdown(items: _a, onChanged:(call){}),
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

                                    GlobalData.mode = roleName;
                                    if (TrialManager.isTrialExpired) {
                                      showAppSnackbar(
                                          context,
                                          "24 hours trial expired Have to upgrade package to continue chat",
                                          "info");
                                      context.push('/paywall');
                                    }

                                    await context
                                        .read<ChatProvider>()
                                        .sendMessage(message,
                                            mode: "text",
                                            isPremium: isPremium!,
                                            language: selectedLanguageCode!,
                                            role: roleName ?? "");

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
