// Supabase configuration (set your actual values in a secure way)
const String kSupabaseUrl = 'TODO_SUPABASE_URL';
const String kSupabaseAnonKey = 'TODO_SUPABASE_ANON_KEY';

// Header keys to include with API calls
const String kHeaderLocale = 'x-locale';
const String kHeaderPlan = 'x-plan';

// Route names and paths
class RoutePaths {
  static const String welcome = '/welcome';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String chatText = '/chat-text';
  static const String chatVoice = '/chat-voice';
  static const String history = '/history';
  static const String paywall = '/paywall';
  static const String settings = '/settings';
  static const String faq = '/faq';
  static const String splash = '/splash';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String about = '/about';
  static const String company = '/company';
}

enum AppPlan { free, premium }

// Feature flags (extend/override via entitlements or remote config as needed)
class FeatureFlags {
  final bool enableVoiceChat;
  final bool enableHistory;

  const FeatureFlags({
    this.enableVoiceChat = false,
    this.enableHistory = false,
  });
}

const String privacyText = """
Privacy Policy

Effective Date: September 22, 2025

Company: Lordan Labs LLC

Location: New Jersey, USA

Website: https://lordan.io

1. Your Privacy Matters
At Lordan Labs LLC (“we,” “our,” or “us”), we prioritize privacy. Lordan is designed to minimize data collection and give you full control over your experience.

We do not track, sell, or share your personal data. We collect only what’s needed to deliver a smooth, secure service.

2. What We Collect
On Our Website (Lordan.io):
We may collect limited non-personal data such as:

Device/browser type

General site usage (page views, time on site)

We do not collect personally identifiable information (PII) unless you directly email us or sign up for updates.

In the Lordan App:
If you use the app, we may process:

Microphone input (for voice features) — used in real time, not stored

Email or phone number (for login code access)

Session memory (premium only) — temporary and cleared after each session

We do not store conversations, and no audio or personal data is retained on our servers unless explicitly required to process your request.

3. No Ads. No Tracking. No Sharing.
We do not:

Sell or rent your data

Use tracking ads or analytics from third-party networks

Share your information with anyone outside Lordan Labs

4. Cookies (Minimal Use)
Our site may use basic cookies only for functionality. You can disable cookies in your browser without losing access to the site.

5. Emails (Optional)
If you subscribe or contact us:

We may use your email to respond or share occasional updates

You can opt out at any time

We do not share or sell your email address

6. Children’s Privacy
Lordan is not intended for children under 13. We do not knowingly collect personal data from minors.

7. Your Rights
Depending on your location, you may have the right to:

Access or delete your data

Withdraw consent or unsubscribe

Request information about our data use

To make a request, contact: privacy@lordan.io

8. Updates
We may update this Privacy Policy as needed. Material changes will be posted here.

Last updated: September 22, 2025

9. Contact
Lordan Labs LLC

New Jersey, USA

📧 info@lordan.io
""";

const String termsOfServiceText = """
Terms of Use

Effective Date: September 22, 2025

Company: Lordan Labs LLC

Website: https://lordan.io

App Platforms: App Store, Google Play, and other authorized platforms

1. Acceptance of Terms
By using the Lordan app or visiting lordan.io, you agree to these Terms of Use (“Terms”). If you do not accept them, please do not use the Service.

These Terms form a legal agreement between you (“you” or “user”) and Lordan Labs LLC, based in New Jersey, USA (“we,” “our,” or “us”).

2. No Therapy or Medical Advice
Lordan is not therapy, diagnosis, or a medical service.

It is an AI-powered tool for self-reflection, communication practice, and mental clarity—not a substitute for professional help.

We do not provide:

Medical or psychological advice

Diagnosis or treatment

Emergency or crisis response

If you are in distress, please contact a licensed professional or emergency services.

3. Platform Use
The Lordan app may be downloaded from:

Apple App Store

Google Play Store

Other approved platforms

Your use is subject to these Terms and platform-specific terms (e.g., Apple Media Services, Google Play TOS).

4. Responsible Use
You agree not to:

Misuse, hack, or reverse-engineer the Service

Share abusive, illegal, or harmful content

Violate local or platform-specific laws

We reserve the right to suspend or terminate your access if misuse occurs.

5. Intellectual Property
All content, features, and technology in the app and website are owned by Lordan Labs LLC. You may not copy, reuse, or redistribute without written permission.

6. Temporary Session Memory (Premium App Only)
In the premium version, temporary memory may be used to maintain conversation flow. This:

Exists only during a session

Is cleared immediately after

Is not stored, linked, or shared

This does not apply to the website or free-tier use.

7. Termination
You may stop using the Service at any time. We may suspend or remove access if you violate these Terms or applicable laws.

8. Limitation of Liability
We provide the Service “as-is.” To the maximum extent allowed by law, we are not liable for any direct, indirect, or incidental damages related to your use of the Service.

9. Updates
We may revise these Terms as needed. If updates are significant, we’ll notify you via the app or website. Continued use means you accept the new Terms.

Last updated: September 22, 2025

10. Contact
Questions? Contact us at:

📧 info@lordan.io

Lordan Labs LLC

New Jersey, USA
""";
