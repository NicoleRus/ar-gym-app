import 'package:ar_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import 'package:visa_nova_icons_flutter/svg_content.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  const ConfirmEmailPage({super.key, required this.email});

  Future<void> _resendConfirmationEmail() async {
    try {
      await AuthService.resendConfirmationEmail(email);
    } catch (e) {
      // Handle error if needed
      print('Error resending confirmation email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // no drawer, no nav bar
      body: Center(
        child: VPanel(
          isFullScreen: false,
          // padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VIcon(
                svgIcon: VIcons.emailHigh, // an envelope icon
                iconHeight: 48,
                iconWidth: 48,
                iconColor: VColors.defaultActive,
              ),
              const SizedBox(height: 16),
              Text(
                'Check your email',
                style: defaultVTheme.textStyles.headline4.copyWith(
                  color: VColors.defaultActive,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We’ve sent a confirmation link to',
                style: defaultVTheme.textStyles.bodyText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: defaultVTheme.textStyles.subtitle2.copyWith(
                  color: VColors.defaultActive,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              VButton(
                onPressed: () => _resendConfirmationEmail(),
                child: const Text('Resend confirmation'),
              ),
              const SizedBox(height: 12),
              VLink(
                title: 'Back to Sign In',
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (r) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
