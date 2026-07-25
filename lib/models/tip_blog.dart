class TipBlog {
  final String id;
  final String category;
  final DateTime date;
  final String title;
  final String excerpt;
  final String body;
  final String imageAsset;
  bool isFavorite;

  TipBlog({
    required this.id,
    required this.category,
    required this.date,
    required this.title,
    required this.excerpt,
    required this.body,
    required this.imageAsset,
    this.isFavorite = false,
  });
}

final List<TipBlog> tipBlogsSeed = [
  TipBlog(
    id: '1',
    category: 'Traditions',
    date: DateTime(2023, 1, 24),
    title:
        'How Tamil letters carry rhythm, breath, and everyday spoken meaning.',
    excerpt:
        'Learn why each uyir and mei sound matters, and how listening first makes practice stick.',
    body:
        'Tamil writing is built from a clear system of vowels (உயிர் எழுத்துகள்), '
        'consonants (மெய் எழுத்துகள்), and their combinations. When you tap a letter '
        'in Eluthozhi, listen for the breath and ending of the sound before you try '
        'to speak it. Start with short daily sessions: review a few characters, '
        'repeat them aloud, and return the next day. Over time the shapes and sounds '
        'link together, and reading becomes far more natural.',
    imageAsset: 'assets/images/abstract.png',
  ),
  TipBlog(
    id: '2',
    category: 'Traditions',
    date: DateTime(2023, 2, 8),
    title: 'A simple path from அ to ஔ without rushing the foundations.',
    excerpt:
        'Build confidence with vowels first, then layer consonants and combined forms.',
    body:
        'Many learners jump ahead to full words too early. Stay with the twelve vowels '
        'until you can recognize and pronounce them quickly. Then move to the eighteen '
        'consonants, noticing how the pulli (்) changes the sound. Only after that '
        'should you spend more time on uyirmei combinations. This order mirrors how '
        'the script is traditionally taught and keeps progress steady.',
    imageAsset: 'assets/images/auth_bg.png',
    isFavorite: true,
  ),
  TipBlog(
    id: '3',
    category: 'Traditions',
    date: DateTime(2023, 3, 12),
    title: 'Why daily sound practice beats long weekend cramming.',
    excerpt:
        'Short listening loops help your ear lock onto Tamil phonetics faster.',
    body:
        'Your ear learns Tamil sounds through repetition, not marathon study. '
        'Five focused minutes—tap, listen, repeat—will usually beat an hour of '
        'passive scrolling. Use the category bar on Home to jump between groups, '
        'and revisit weaker letters intentionally. Consistency compounds.',
    imageAsset: 'assets/images/splash_bg.png',
  ),
  TipBlog(
    id: '4',
    category: 'History',
    date: DateTime(2023, 4, 2),
    title: 'A brief look at how Tamil script grew across centuries.',
    excerpt:
        'From classical inscriptions to modern print, the letters you learn today '
        'carry a long cultural line.',
    body:
        'Tamil is one of the world\'s classical languages, with a written tradition '
        'stretching back more than two millennia. The modern forms you practice in '
        'this app descend from that lineage, refined for clarity in print and screens. '
        'Knowing a little of that history can make each character feel less abstract '
        'and more connected to living culture.',
    imageAsset: 'assets/images/splash-white-wide.png',
  ),
];
