import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  const InputCard({
    super.key,
    required this.label,
    required this.value,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  final String label;
  final int value;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onLeftPressed,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onRightPressed,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
