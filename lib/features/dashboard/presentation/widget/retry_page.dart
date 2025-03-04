import 'package:flutter/material.dart';

class RetryPage extends StatelessWidget {
  final String? title;
  final String? desc;
  final VoidCallback onRetry;
  final bool showRetry;

  const RetryPage(
      {super.key,
      required this.onRetry,
      this.title,
      this.desc,
      this.showRetry = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 12),
            if (title != null) ...[
              Text(
                title ?? "Oops! Something went wrong.",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              const SizedBox(height: 8),
            ],
            if (desc != null) ...[
              Text(
                desc ?? "Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
            if (showRetry)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
