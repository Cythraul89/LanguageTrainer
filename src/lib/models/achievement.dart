enum AchievementTrigger {
  firstCorrect,    // totalCorrect >= 1
  correct50,       // totalCorrect >= 50
  correct100,      // totalCorrect >= 100
  correct500,      // totalCorrect >= 500
  firstCorrect100, // totalFirstCorrect >= 100
  level5,          // level >= 5
  level10,         // level >= 10
  level20,         // level >= 20
  consecutive10,   // 10 consecutive correct in one session
  firstSession,    // sessionsCompleted >= 1
}

class Achievement {
  final String id;
  final String emoji;
  final String title;
  final String description;
  final AchievementTrigger trigger;

  const Achievement({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.trigger,
  });
}

const kAchievements = <Achievement>[
  Achievement(
    id: 'first_correct',
    emoji: '🌱',
    title: 'First Steps',
    description: 'Answer your first card correctly.',
    trigger: AchievementTrigger.firstCorrect,
  ),
  Achievement(
    id: 'correct_50',
    emoji: '📚',
    title: 'Word Collector',
    description: 'Accumulate 50 correct answers.',
    trigger: AchievementTrigger.correct50,
  ),
  Achievement(
    id: 'correct_100',
    emoji: '💯',
    title: 'Century',
    description: 'Accumulate 100 correct answers.',
    trigger: AchievementTrigger.correct100,
  ),
  Achievement(
    id: 'correct_500',
    emoji: '🎓',
    title: 'Dedicated Learner',
    description: 'Accumulate 500 correct answers.',
    trigger: AchievementTrigger.correct500,
  ),
  Achievement(
    id: 'first_correct_100',
    emoji: '⚡',
    title: 'Quick Study',
    description: 'Answer 100 new cards correctly on the first attempt.',
    trigger: AchievementTrigger.firstCorrect100,
  ),
  Achievement(
    id: 'level_5',
    emoji: '⭐',
    title: 'Adventurer',
    description: 'Reach Level 5.',
    trigger: AchievementTrigger.level5,
  ),
  Achievement(
    id: 'level_10',
    emoji: '🌟',
    title: 'Expert',
    description: 'Reach Level 10.',
    trigger: AchievementTrigger.level10,
  ),
  Achievement(
    id: 'level_20',
    emoji: '👑',
    title: 'Master',
    description: 'Reach Level 20.',
    trigger: AchievementTrigger.level20,
  ),
  Achievement(
    id: 'consecutive_10',
    emoji: '🎯',
    title: 'On a Roll',
    description: '10 correct answers in a row within one session.',
    trigger: AchievementTrigger.consecutive10,
  ),
  Achievement(
    id: 'first_session',
    emoji: '🏅',
    title: 'Committed',
    description: 'Complete your first review session.',
    trigger: AchievementTrigger.firstSession,
  ),
];
