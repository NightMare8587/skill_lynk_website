import 'package:flutter/material.dart';
import '../../../../shared/widgets/header.dart';
import '../../../../shared/widgets/footer.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Last updated: April 11, 2026',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 48),
                      _Section(
                        title: '1. Introduction',
                        content: 'Welcome to SkillLynk. We value your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application and website.',
                      ),
                      _Section(
                        title: '2. Information We Collect',
                        content: 'We collect information that you provide directly to us, including:\n\n• Profile Information: Name, age, gender, experience, and resume details provided during onboarding.\n• Authentication Data: Phone numbers, OTP verification data, and Google account identifiers.\n• Communication Data: Audio and video data transmitted during mock interviews conducted via Agora RTC SDK. Please note that we do not store recordings of these calls unless explicitly stated for specific feedback purposes.\n• Wallet Transactions: Records of credit purchases and usage.',
                      ),
                      _Section(
                        title: '3. How We Use Your Information',
                        content: 'We use the collected data to:\n\n• Provide and maintain our services.\n• Facilitate mock interviews between peers and experts.\n• Process wallet transactions and manage interview credits.\n• Provide feedback and ratings based on interview performance.\n• Send technical notices, updates, and security alerts.',
                      ),
                      _Section(
                        title: '4. Data Sharing and Disclosure',
                        content: 'We do not sell your personal data. We may share information with:\n\n• Other Users: Limited profile information (name, experience) is visible to peers and experts for scheduling interviews.\n• Service Providers: Third-party vendors like Agora (for RTC calls) and payment gateways (for wallet recharges).\n• Legal Compliance: When required by law or to protect our rights.',
                      ),
                      _Section(
                        title: '5. Data Security',
                        content: 'We implement industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
                      ),
                      _Section(
                        title: '6. Your Rights',
                        content: 'You have the right to access, correct, or delete your personal data. You can manage your profile settings within the app or contact us for assistance with account deletion.',
                      ),
                      _Section(
                        title: '7. Contact Us',
                        content: 'If you have any questions about this Privacy Policy, please contact us at skill.lynkk@gmail.com.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
