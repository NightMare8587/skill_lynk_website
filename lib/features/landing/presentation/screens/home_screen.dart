import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/header.dart';
import '../../../../shared/widgets/footer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../support/presentation/widgets/contact_support_dialog.dart';

Future<void> _launchUrl() async {
  final Uri url = Uri.parse('https://skill-lynk.web.app/');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuresKey = GlobalKey();
    final howItWorksKey = GlobalKey();

    void scrollTo(GlobalKey key) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }

    void showContactSupport() {
      showDialog(
        context: context,
        builder: (context) => const ContactSupportDialog(),
      );
    }

    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'SkillLynk',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ),
            ListTile(
              title: const Text('Features'),
              onTap: () {
                Navigator.pop(context);
                scrollTo(featuresKey);
              },
            ),
            ListTile(
              title: const Text('How it Works'),
              onTap: () {
                Navigator.pop(context);
                scrollTo(howItWorksKey);
              },
            ),
            ListTile(
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
                showContactSupport();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              onFeaturesTap: () => scrollTo(featuresKey),
              onHowItWorksTap: () => scrollTo(howItWorksKey),
              onSupportTap: showContactSupport,
            ),
            const _HeroSection(),
            _FeaturesSection(key: featuresKey),
            _HowItWorksSection(key: howItWorksKey),
            const _CTASection(),
            Footer(
              onFeaturesTap: () => scrollTo(featuresKey),
              onHowItWorksTap: () => scrollTo(howItWorksKey),
              onSupportTap: showContactSupport,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: isMobile ? 40 : 80,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            AppColors.primary.withAlpha(13),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '🚀 Empowering Developers Worldwide',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Master Your Technical\nInterviews with AI',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'The professional platform to practice interviews with peers and experts.\nReceive real-time feedback and get industry-ready.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
                child: const Text('Get Started for Free'),
              ),
              OutlinedButton(
                onPressed: _launchUrl,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
                child: const Text('See Demo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _StoreButton(
                icon: Icons.apple,
                label: 'App Store',
                onTap: () {},
              ),
              _StoreButton(
                icon: Icons.play_arrow,
                label: 'Google Play',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          // App Preview Placeholder
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500, maxWidth: isMobile ? double.infinity : 1000),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: AppColors.background,
                  child: Row(
                    children: [
                      // Sidebar Mock
                      Container(
                        width: isMobile ? 50 : 70,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            const Icon(Icons.dashboard, color: AppColors.primary, size: 24),
                            const SizedBox(height: 32),
                            Icon(Icons.video_call, color: Colors.grey.withAlpha(100), size: 24),
                            const SizedBox(height: 32),
                            Icon(Icons.account_balance_wallet, color: Colors.grey.withAlpha(100), size: 24),
                            const Spacer(),
                            Icon(Icons.settings, color: Colors.grey.withAlpha(100), size: 24),
                          ],
                        ),
                      ),
                      // Main Content Mock
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isMobile ? 'Hi, Alex!' : 'Welcome back, Alex!',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      Text(
                                        '12 credits remaining',
                                        style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (!isMobile)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Recharge',
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'Available Interviewers',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: isMobile ? 2 : 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: isMobile ? 0.8 : 0.9,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _InterviewerCardMock(name: 'Sarah Chen', role: 'Google', skills: ['System']),
                                    _InterviewerCardMock(name: 'Alex Kumar', role: 'Meta', skills: ['Java']),
                                    _InterviewerCardMock(name: 'Jane Doe', role: 'Amazon', skills: ['Python']),
                                    if (!isMobile) ...[
                                      _InterviewerCardMock(name: 'Michael R.', role: 'Netflix', skills: ['Node.js']),
                                      _InterviewerCardMock(name: 'Priya S.', role: 'Apple', skills: ['Swift']),
                                      _InterviewerCardMock(name: 'David L.', role: 'Microsoft', skills: ['C#']),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Everything you need to succeed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: const [
              _FeatureCard(
                icon: Icons.people_outline,
                title: 'Peer Interviews',
                description: 'Practice with other developers in real-time. Learn from each other and build confidence.',
              ),
              _FeatureCard(
                icon: Icons.psychology_outlined,
                title: 'Expert Feedback',
                description: 'Get reviewed by industry experts from top tech companies. Know exactly where to improve.',
              ),
              _FeatureCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Wallet System',
                description: 'Manage your interview credits seamlessly. Recharge and schedule sessions with one click.',
              ),
              _FeatureCard(
                icon: Icons.video_call_outlined,
                title: 'HD Video Calls',
                description: 'Experience crystal clear communication with our integrated Agora RTC calling system.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      child: Column(
        children: [
          const Text(
            'How it Works',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 64),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 32,
            runSpacing: 48,
            children: const [
              _StepItem(number: '1', title: 'Sign Up', subtitle: 'Create your professional profile.'),
              _StepItem(number: '2', title: 'Schedule', subtitle: 'Pick a time and an interviewer.'),
              _StepItem(number: '3', title: 'Practice', subtitle: 'Conduct the mock interview.'),
              _StepItem(number: '4', title: 'Succeed', subtitle: 'Improve and land your dream job.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _StepItem({required this.number, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 24 : 120),
      color: AppColors.primary,
      child: Column(
        children: [
          Text(
            'Ready to level up your career?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Join thousands of developers who are practicing on SkillLynk.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _launchUrl,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            ),
            child: const Text('Start Practice Now'),
          ),
        ],
      ),
    );
  }
}

class _MockCircle extends StatelessWidget {
  final Color color;
  const _MockCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StoreButton({
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
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Download on the',
                  style: TextStyle(color: Colors.white70, fontSize: 8),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

class _InterviewerCardMock extends StatelessWidget {
  final String name;
  final String role;
  final List<String> skills;

  const _InterviewerCardMock({
    required this.name,
    required this.role,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isMobile ? 24 : 32,
                height: isMobile ? 24 : 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.primary, size: isMobile ? 12 : 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 10 : 12),
                    ),
                    Text(
                      role,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black.withAlpha(100), fontSize: isMobile ? 8 : 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isMobile) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: skills.map((skill) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                ),
              )).toList(),
            ),
          ],
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                'Book Now',
                style: TextStyle(color: AppColors.primary, fontSize: isMobile ? 8 : 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
