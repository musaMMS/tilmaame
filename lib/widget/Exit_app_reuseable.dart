import 'package:flutter/material.dart';
import 'color.dart';

Future<bool> showExitDialog(BuildContext context) async {
  final result = await showGeneralDialog<bool>(
    barrierDismissible: true,
    barrierLabel: "Exit",
    context: context,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Material( // ✨ important: Material wrap
        color: Colors.transparent, // background transparent
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75, // 75% width
            constraints: const BoxConstraints(
              maxWidth: 320, //  width
              minHeight: 120,
              maxHeight: 220,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // height auto adjust
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.exit_to_app, color: Colors.deepOrange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Exit App",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Do you really want to exit the app?",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
  );

  return result ?? false;
}

