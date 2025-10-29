import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/methods/text_format.dart';
import '../../../models/message.dart';
import '../../../theme.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isUser) ...[
          const SizedBox(width: 8),
          _buildAvatar(isUser: false),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [0.0, 0.3, 1.0],
                colors: message.isUser
                    ? [
                        Colors.white.withValues(alpha: 0.1),
                        const Color(0xFFCDCDFF).withValues(alpha: 0.3),
                        AppColors.primaryLight,
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.1),
                        AppColors.glassLight.withValues(alpha: 0.05),
                        AppColors.glassLight.withValues(alpha: 0.1),
                      ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: message.isUser
                    ? const Radius.circular(16)
                    : const Radius.circular(4),
                bottomRight: message.isUser
                    ? const Radius.circular(4)
                    : const Radius.circular(16),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onLongPress: () => _showActions(context),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message content
                      RichText(
                        text: formatApiText(message.content),
                      ),
                      if (message.isStreaming) ...[
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (message.isUser) ...[
          const SizedBox(width: 8),
          _buildAvatar(isUser: true),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.0, 0.4, 1.0],
          colors: isUser
              ? [
                  Colors.white,
                  const Color(0xFFCDCDFF),
                  AppColors.secondaryLight,
                ]
              : [
                  Colors.white,
                  const Color(0xFFCDCDFF),
                  AppColors.primaryLight,
                ],
        ),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        size: 18,
        color: isUser ? AppColors.secondaryLight : AppColors.primaryLight,
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.glassLight.withValues(alpha: 0.2),
              AppColors.glassLight.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.white),
              title: const Text('Copy', style: TextStyle(color: Colors.white)),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Share', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Share.share(message.content);
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                onDelete();
                context.pop();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
