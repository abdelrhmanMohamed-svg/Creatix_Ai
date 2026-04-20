class ToneOfVoice {
  final String id;
  final String name;
  final String description;

  const ToneOfVoice({
    required this.id,
    required this.name,
    required this.description,
  });

  static const List<ToneOfVoice> predefined = [
    ToneOfVoice(
      id: 'professional',
      name: 'Professional',
      description: 'Formal, expert, and authoritative',
    ),
    ToneOfVoice(
      id: 'friendly',
      name: 'Friendly',
      description: 'Warm, approachable, and casual',
    ),
    ToneOfVoice(
      id: 'authoritative',
      name: 'Authoritative',
      description: 'Confident, decisive, and knowledgeable',
    ),
    ToneOfVoice(
      id: 'playful',
      name: 'Playful',
      description: 'Fun, creative, and lighthearted',
    ),
    ToneOfVoice(
      id: 'inspirational',
      name: 'Inspirational',
      description: 'Motivating, uplifting, and aspirational',
    ),
    ToneOfVoice(
      id: 'casual',
      name: 'Casual',
      description: 'Relaxed, informal, and conversational',
    ),
    ToneOfVoice(
      id: 'luxury',
      name: 'Luxury',
      description: 'Elegant, exclusive, and premium',
    ),
    ToneOfVoice(
      id: 'minimalist',
      name: 'Minimalist',
      description: 'Clean, simple, and uncluttered',
    ),
  ];
}
