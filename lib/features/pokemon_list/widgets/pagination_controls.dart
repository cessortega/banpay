import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final String? previous;
  final String? next;
  final void Function(String url) onPrevious;
  final void Function(String url) onNext;

  const PaginationControls({
    super.key,
    required this.previous,
    required this.next,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const buttonSize = 48.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          previous != null
              ? _NavigationButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => onPrevious(previous!),
                )
              : const SizedBox(width: buttonSize),
          next != null
              ? _NavigationButton(
                  icon: Icons.arrow_forward_ios,
                  onTap: () => onNext(next!),
                )
              : const SizedBox(width: buttonSize),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.redAccent,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: Colors.blueAccent.withOpacity(0.2),
        highlightColor: Colors.blueAccent.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}
