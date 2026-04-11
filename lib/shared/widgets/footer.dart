import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class Footer extends StatelessWidget {
  final VoidCallback? onFeaturesTap;
  final VoidCallback? onHowItWorksTap;
  final VoidCallback? onSupportTap;

  const Footer({
    super.key,
    this.onFeaturesTap,
    this.onHowItWorksTap,
    this.onSupportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      color: AppColors.textPrimary,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.link, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'SkillLynk',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'AI-based interview practice platform for serious developers.',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _FooterColumn(
                title: 'Product',
                links: [
                  _FooterLink(label: 'Features', onTap: onFeaturesTap ?? () {}),
                  _FooterLink(label: 'How it Works', onTap: onHowItWorksTap ?? () {}),
                  _FooterLink(label: 'Support', onTap: onSupportTap ?? () {}),
                  _FooterLink(label: 'Pricing', onTap: () {}),
                ],
              ),
              _FooterColumn(
                title: 'Legal',
                links: [
                  _FooterLink(label: 'Privacy Policy', onTap: () => context.go('/privacy')),
                  _FooterLink(label: 'Terms & Conditions', onTap: () => context.go('/terms')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterStoreButton(
                icon: Icons.apple,
                label: 'App Store',
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _FooterStoreButton(
                icon: Icons.play_arrow,
                label: 'Google Play',
                onTap: () {},
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 64),
          const Text(
            '© 2026 SkillLynk. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<_FooterLink> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ...links,
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _FooterStoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterStoreButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Download on',
                  style: TextStyle(color: Colors.white38, fontSize: 8),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
