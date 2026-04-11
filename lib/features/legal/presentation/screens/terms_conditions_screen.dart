import 'package:flutter/material.dart';
import '../../../../shared/widgets/header.dart';
import '../../../../shared/widgets/footer.dart';
import '../../../../core/theme/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                        'Terms & Conditions',
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
                        title: '1. Agreement to Terms',
                        content: 'By accessing or using SkillLynk, you agree to be bound by these Terms and Conditions. If you do not agree, you must not use our service.',
                      ),
                      _Section(
                        title: '2. User Accounts',
                        content: 'To use SkillLynk, you must create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
                      ),
                      _Section(
                        title: '3. Wallet and Credits',
                        content: 'SkillLynk uses a credit-based system. Credits are purchased via our payment gateways. All purchases are final. Credits can only be used within the platform to schedule mock interviews and cannot be exchanged for cash or transferred to other users.',
                      ),
                      _Section(
                        title: '4. Refund Policy',
                        content: 'Refunds for credit purchases are only provided in exceptional cases of technical failure where the service was not delivered. Refund requests must be submitted within 7 days of purchase. No refunds will be issued for "no-shows" or for sessions cancelled less than 24 hours before the scheduled time.',
                      ),
                      _Section(
                        title: '5. User Conduct',
                        content: 'You agree not to use SkillLynk to:\n\n• Harass, abuse, or harm other users.\n• Share inappropriate, offensive, or illegal content.\n• Attempt to circumvent platform security or payment systems.\n• Conduct professional recruitment or advertising without authorization.',
                      ),
                      _Section(
                        title: '6. Intellectual Property',
                        content: 'All content on SkillLynk, including logos, text, and design elements, is the property of SkillLynk and is protected by international copyright and trademark laws.',
                      ),
                      _Section(
                        title: '7. Limitation of Liability',
                        content: 'SkillLynk is provided "as is" and "as available". We do not guarantee that mock interviews will result in actual employment. SkillLynk shall not be liable for any indirect, incidental, or consequential damages resulting from your use of the service.',
                      ),
                      _Section(
                        title: '8. Modifications to Terms',
                        content: 'We reserve the right to modify these Terms at any time. Changes will be effective immediately upon posting. Your continued use of the platform after changes are posted constitutes your acceptance of the new Terms.',
                      ),
                      _Section(
                        title: '9. Contact Information',
                        content: 'For any questions regarding these Terms, please contact us at skill.lynkk@gmail.com.',
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
