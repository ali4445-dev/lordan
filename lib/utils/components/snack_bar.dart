import 'package:flutter/material.dart';

/// Centralized Snackbar utility
void showAppSnackbar(BuildContext context, String message, String type) {
  // Determine background and icon based on type
  Color backgroundColor;
  IconData icon;

  switch (type.toLowerCase()) {
    case 'success':
      backgroundColor = Colors.greenAccent.shade700;
      icon = Icons.check_circle;
      break;
    case 'error':
      backgroundColor = Colors.redAccent.shade700;
      icon = Icons.error_outline;
      break;
    case 'warning':
      backgroundColor = Colors.orangeAccent.shade700;
      icon = Icons.warning_amber_rounded;
      break;
    case 'info':
      backgroundColor = Colors.blueAccent.shade700;
      icon = Icons.info_outline;
      break;
    default:
      backgroundColor = Colors.grey.shade800;
      icon = Icons.notifications_none_rounded;
  }

  // Remove any existing snackbar
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Show the new snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 8,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins', // Use a nice readable font
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
