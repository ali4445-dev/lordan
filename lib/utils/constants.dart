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
  static const String comparison = '/comparison';
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
​Privacy Policy
​Effective:​​October 3, 2025​
​Lordan Labs LLC takes your privacy seriously. This explains what we collect, how we use it, and​ how we protect it.​

​1. What We Collect​
​Account Access:​​ 
​●​ ​Email or phone number for login​
​●​ ​Authentication data for subscriptions​

​Conversations:​
● Text or voice input you share​
​●​ ​Used only in real-time to generate responses​
​●​ ​Not stored on our servers after your session ends​

​Session Memory:​
● Temporary memory stored locally on your device for conversation continuity​
​●​ ​Automatically deleted after 24 hours​
​●​ ​Premium users can manually delete anytime​

​Technical Data:​
● Device type, app version, error reports (non-identifiable)​
​●​ ​Used only for security and reliability​

​2. What We Don't Collect​
​We do not store or sell your conversations. We do not track you across apps or websites. We do​ not use your conversations to train AI models. We do not keep audio recordings.​

​3. How We Use Information​
​To let you log in and manage your subscription. To provide real-time voice or text responses. To​ ​maintain security and prevent abuse. To improve reliability and fix technical issues.​
""";

const String termsOfServiceText = """
Terms of Use
​Effective Date:​​October 18, 2025​
​By using Lordan, you agree to these Terms of Use.​

​1. Acceptance​
​These Terms form a legal agreement between you and Lordan Labs LLC. If you don't accept​ ​them, please don't use the app.​

​2. Not Medical or Therapy​
​Lordan is an educational tool for thinking and communication skills—not therapy, medical​ ​advice, diagnosis, or treatment. It does not provide crisis support.​​If you're experiencing an emergency, contact local emergency services immediately.​​Lordan is not a substitute for professional medical or psychological care.​

​3. Responsible Use​
​You agree not to misuse, hack, or reverse-engineer the service, share illegal or harmful content ​or violate applicable laws.​​We may suspend or terminate access if you violate these Terms.​

​4. Privacy & Session Memory​
​Lordan uses temporary session memory for conversation continuity. This memory is​​automatically deleted after 24 hours and is never shared or used for AI training.​​Premium users can manually delete session memory anytime.​​See our Privacy Policy for full details.​

​5. Intellectual Property​
​All content, features, and technology are owned by Lordan Labs LLC. You may not copy,​​redistribute, or reuse without written permission.​

​6. Platform Terms​
​Your use is also subject to App Store or Google Play terms of service.​

​7. Limitation of Liability​
​Lordan is provided "as-is." We are not liable for any damages related to your use of the service,​to the maximum extent allowed by law.​

​8. Changes​
​We may update these Terms and the app's design or features at any time. Continued use​ ​means you accept the changes.​

​9. Contact​
​Questions? Email us at​​info@lordan.io​
​Lordan Labs LLC​

​New Jersey, USA​
​Last updated: October 18, 2025
""";

const String safetyEthics = """
Safety & Ethics​
​Lordan is a private AI Thinking Companion designed to promote clarity, reflection, and personal​ growth through safe, respectful dialogue.​

​Ethical Principles​-​Human Dignity​
​Every interaction is guided by empathy, respect, and non-judgment.​

​Safety First​
​Conversations are moderated to prevent or redirect any content involving harm, violence, or​ ​self-harm.​

​No Explicit Content​
​Lordan does not generate or engage in pornographic, obscene, or sexually suggestive dialogue.​

​No Hate or Manipulation​
​The system refuses and reframes any discriminatory, hostile, or exploitative topics.​

​Privacy and Calm​
​User data is never used for profiling, advertising, or behavioral manipulation.​

​Constructive Reflection​
​Even when frustration or venting occurs, Lordan maintains composure and redirects toward​ understanding and growth.​

​Core Safeguards​
​Real-time moderation filter for all inputs and outputs.​
​Embedded crisis-support messages available in 11 languages.​
​Context-aware tone normalization and cultural sensitivity.​
​Continuous ethical oversight through philosophical and educational frameworks.​

​Result​
​Every conversation—whether casual, challenging, or intellectual—remains safe, private, and​ ​growth-oriented, aligned with Lordan's purpose:​

​Clarity. Presence. Progress.​
​Lordan Labs LLC​
​New Jersey, USA​
""";
