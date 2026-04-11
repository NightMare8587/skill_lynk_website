import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class Header extends StatelessWidget {
  final VoidCallback? onFeaturesTap;
  final VoidCallback? onHowItWorksTap;

  const Header({
    super.key,
    this.onFeaturesTap,
    this.onHowItWorksTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.link, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'SkillLynk',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (MediaQuery.of(context).size.width > 600) ...[
            _NavLink(label: 'Features', onTap: onFeaturesTap ?? () {}),
            _NavLink(label: 'How it Works', onTap: onHowItWorksTap ?? () {}),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Started'),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
