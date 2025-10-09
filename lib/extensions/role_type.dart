enum RoleType {
  reflect,
  studyPrep,
  meetingWarmup,
  debatePractice,
  brainstorm,
  languageChat,
  focusAid,
  talkItOut,
  pitchPractice,
  dealPrep,
  lessonBuilder,
  creatorIdeas,
  parentPrep,
  healthExplainer,
  militaryBriefing,
  diplomacy,
  legalPrep,
  longJournal,
  liveVoice,
  logicCoach,
}

extension RoleX on RoleType {
  /// Free vs Premium
  bool get isPremium => const {
        RoleType.pitchPractice,
        RoleType.dealPrep,
        RoleType.lessonBuilder,
        RoleType.creatorIdeas,
        RoleType.parentPrep,
        RoleType.healthExplainer,
        RoleType.militaryBriefing,
        RoleType.diplomacy,
        RoleType.legalPrep,
        RoleType.longJournal,
        RoleType.liveVoice,
        RoleType.logicCoach,
      }.contains(this);

  /// Human-friendly name
  String get displayName =>
      const {
        RoleType.studyPrep: 'Study Prep',
        RoleType.meetingWarmup: 'Meeting Warm-up',
        RoleType.debatePractice: 'Debate Practice',
        RoleType.languageChat: 'Language Chat',
        RoleType.focusAid: 'Focus Aid',
        RoleType.talkItOut: 'Talk It Out',
        RoleType.pitchPractice: 'Pitch Practice',
        RoleType.dealPrep: 'Deal Prep',
        RoleType.lessonBuilder: 'Lesson Builder',
        RoleType.creatorIdeas: 'Creator Ideas',
        RoleType.parentPrep: 'Parent Prep',
        RoleType.healthExplainer: 'Health Explainer',
        RoleType.militaryBriefing: 'Military Briefing',
        RoleType.longJournal: 'Long Journal',
        RoleType.liveVoice: 'Live Voice',
        RoleType.logicCoach: 'Logic Coach',
      }[this] ??
      _capitalize(name);
}

String _capitalize(String s) => s.replaceFirst(s[0], s[0].toUpperCase());
