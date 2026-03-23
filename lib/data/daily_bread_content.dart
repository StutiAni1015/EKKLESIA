import 'package:flutter/material.dart';

class BreadContent {
  final String tag;
  final String heroTitle;
  final String verseText;
  final String verseRef;
  final String readingRef;
  final String readingText;
  final String reflectionQuestion;
  final String footerVerse;
  final List<Color> gradientColors;

  const BreadContent({
    required this.tag,
    required this.heroTitle,
    required this.verseText,
    required this.verseRef,
    required this.readingRef,
    required this.readingText,
    required this.reflectionQuestion,
    required this.footerVerse,
    required this.gradientColors,
  });
}

/// Returns a BreadContent for the given emotion index (0–5) and a seed value.
/// The seed is derived from the user's name + today's date so each person
/// gets a unique reflection each day.
BreadContent getDailyBread(int emotionIndex, int seed) {
  final list = _content[emotionIndex % _content.length];
  return list[seed % list.length];
}

/// emotionIndex → label
const emotionLabels = [
  'Anxious',
  'Joyful',
  'Grateful',
  'Stressed',
  'Lonely',
  'Peaceful',
];

// 6 emotions × 3 variations = 18 unique daily reflections
final _content = [
  // 0 – Anxious
  [
    BreadContent(
      tag: 'OVERCOMING ANXIETY',
      heroTitle: 'Finding Peace in the\nMidst of Worry',
      verseText:
          '"Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God. And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus."',
      verseRef: 'Philippians 4:6–7',
      readingRef: 'Matthew 6:25–34',
      readingText:
          '"Therefore I tell you, do not worry about your life, what you will eat or drink; or about your body, what you will wear. Is not life more than food, and the body more than clothes? Look at the birds of the air — they do not sow or reap or store away in barns, and yet your heavenly Father feeds them. Are you not much more valuable than they? Can any one of you by worrying add a single hour to your life?"',
      reflectionQuestion: 'What is one worry you can hand over to God right now?',
      footerVerse: 'Peace I leave with you; my peace I give you. — John 14:27',
      gradientColors: [Color(0xFF4A6741), Color(0xFF8BA888)],
    ),
    BreadContent(
      tag: 'CASTING YOUR CARES',
      heroTitle: 'He Carries the\nWeight You Cannot',
      verseText:
          '"Cast your cares on the Lord and he will sustain you; he will never let the righteous be shaken."',
      verseRef: 'Psalm 55:22',
      readingRef: '1 Peter 5:6–11',
      readingText:
          '"Humble yourselves, therefore, under God\'s mighty hand, that he may lift you up in due time. Cast all your anxiety on him because he cares for you. Be alert and of sober mind. Your enemy the devil prowls around like a roaring lion looking for someone to devour. Resist him, standing firm in the faith, because you know that the family of believers throughout the world is undergoing the same kind of sufferings."',
      reflectionQuestion: 'What burden have you been carrying alone that you need to give to God?',
      footerVerse: 'The Lord is my shepherd; I shall not want. — Psalm 23:1',
      gradientColors: [Color(0xFF3D5A6B), Color(0xFF6B8E9F)],
    ),
    BreadContent(
      tag: 'DO NOT FEAR',
      heroTitle: 'God Is With You\nin the Storm',
      verseText:
          '"So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you; I will uphold you with my righteous right hand."',
      verseRef: 'Isaiah 41:10',
      readingRef: 'John 14:25–31',
      readingText:
          '"Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled and do not be afraid. You heard me say, \'I am going away and I am coming back to you.\' If you loved me, you would be glad that I am going to the Father, for the Father is greater than I."',
      reflectionQuestion: 'Which truth about God brings the most calm to your current fear?',
      footerVerse: 'Fear not, for I have redeemed you. — Isaiah 43:1',
      gradientColors: [Color(0xFF5B4B7A), Color(0xFF9B7FB0)],
    ),
  ],

  // 1 – Joyful
  [
    BreadContent(
      tag: 'REJOICE ALWAYS',
      heroTitle: 'This Is the Day\nthe Lord Has Made',
      verseText:
          '"Rejoice in the Lord always. I will say it again: Rejoice! Let your gentleness be evident to all. The Lord is near."',
      verseRef: 'Philippians 4:4–5',
      readingRef: 'Psalm 100',
      readingText:
          '"Shout for joy to the Lord, all the earth. Worship the Lord with gladness; come before him with joyful songs. Know that the Lord is God. It is he who made us, and we are his; we are his people, the sheep of his pasture. Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name. For the Lord is good and his love endures forever."',
      reflectionQuestion: 'What blessing from God will you celebrate out loud today?',
      footerVerse: 'This is the day the Lord has made; let us rejoice and be glad. — Psalm 118:24',
      gradientColors: [Color(0xFFB8860B), Color(0xFFD4A547)],
    ),
    BreadContent(
      tag: 'JOY OVERFLOWING',
      heroTitle: 'Your Joy Is a\nWitness to the World',
      verseText:
          '"You make known to me the path of life; you will fill me with joy in your presence, with eternal pleasures at your right hand."',
      verseRef: 'Psalm 16:11',
      readingRef: 'Nehemiah 8:9–12',
      readingText:
          '"Do not grieve, for the joy of the Lord is your strength." The Levites calmed all the people, saying, "Be still, for this is a holy day. Do not grieve." Then all the people went away to eat and drink, to send portions of food and to celebrate with great joy, because they now understood the words that had been made known to them.',
      reflectionQuestion: 'How can you share the joy you feel with someone who needs it today?',
      footerVerse: 'The joy of the Lord is your strength. — Nehemiah 8:10',
      gradientColors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    ),
    BreadContent(
      tag: 'HE SINGS OVER YOU',
      heroTitle: 'God Delights in\nYou Today',
      verseText:
          '"The Lord your God is with you, the Mighty Warrior who saves. He will take great delight in you; in his love he will no longer rebuke you, but will rejoice over you with singing."',
      verseRef: 'Zephaniah 3:17',
      readingRef: 'Romans 15:13',
      readingText:
          '"May the God of hope fill you with all joy and peace as you trust in him, so that you may overflow with hope by the power of the Holy Spirit." What a promise — that joy, peace, and hope are not things we manufacture but gifts poured into us by the Spirit of God himself.',
      reflectionQuestion: 'Knowing God sings over you, what does that change about your day?',
      footerVerse: 'May your joy be complete. — John 15:11',
      gradientColors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
  ],

  // 2 – Grateful
  [
    BreadContent(
      tag: 'GIVE THANKS',
      heroTitle: 'A Grateful Heart\nIs a Powerful Heart',
      verseText:
          '"Give thanks in all circumstances; for this is God\'s will for you in Christ Jesus."',
      verseRef: '1 Thessalonians 5:18',
      readingRef: 'Psalm 107:1–9',
      readingText:
          '"Give thanks to the Lord, for he is good; his love endures forever. Let the redeemed of the Lord tell their story — those he redeemed from the hand of the foe, those he gathered from the lands, from east and west, from north and south... Let them give thanks to the Lord for his unfailing love and his wonderful deeds for mankind, for he satisfies the thirsty and fills the hungry with good things."',
      reflectionQuestion: 'Name three specific gifts from God today — big or small.',
      footerVerse: 'Oh give thanks to the Lord, for he is good! — Psalm 107:1',
      gradientColors: [Color(0xFF6A1B9A), Color(0xFFBA68C8)],
    ),
    BreadContent(
      tag: 'THANKFUL LIVING',
      heroTitle: 'Everything You Have\nIs a Gift',
      verseText:
          '"Let the peace of Christ rule in your hearts, since as members of one body you were called to peace. And be thankful... whatever you do, whether in word or deed, do it all in the name of the Lord Jesus, giving thanks to God the Father through him."',
      verseRef: 'Colossians 3:15–17',
      readingRef: 'Psalm 136:1–9',
      readingText:
          '"Give thanks to the Lord, for he is good. His love endures forever. Give thanks to the God of gods. His love endures forever. Give thanks to the Lord of lords. His love endures forever. To him who alone does great wonders, his love endures forever. Who by his understanding made the heavens, his love endures forever..."',
      reflectionQuestion: 'Who has God placed in your life that you are truly thankful for? Have you told them?',
      footerVerse: 'In everything give thanks. — 1 Thessalonians 5:18',
      gradientColors: [Color(0xFF00695C), Color(0xFF4DB6AC)],
    ),
    BreadContent(
      tag: 'COUNT YOUR BLESSINGS',
      heroTitle: 'Ten Lepers, One\nReturned to Say Thanks',
      verseText:
          '"Praise the Lord, my soul; all my inmost being, praise his holy name. Praise the Lord, my soul, and forget not all his benefits — who forgives all your sins and heals all your diseases, who redeems your life from the pit and crowns you with love and compassion."',
      verseRef: 'Psalm 103:1–4',
      readingRef: 'Luke 17:11–19',
      readingText:
          '"One of them, when he saw he was healed, came back, praising God in a loud voice. He threw himself at Jesus\' feet and thanked him — and he was a Samaritan. Jesus asked, \'Were not all ten cleansed? Where are the other nine? Has no one returned to give praise to God except this foreigner?\' Then he said to him, \'Rise and go; your faith has made you well.\'"',
      reflectionQuestion: 'How will you express gratitude to God — and to others — in a tangible way today?',
      footerVerse: 'Every good and perfect gift is from above. — James 1:17',
      gradientColors: [Color(0xFFD84315), Color(0xFFFF8A65)],
    ),
  ],

  // 3 – Stressed
  [
    BreadContent(
      tag: 'COME TO ME',
      heroTitle: 'His Yoke Is Easy,\nHis Burden Is Light',
      verseText:
          '"Come to me, all you who are weary and burdened, and I will give you rest. Take my yoke upon you and learn from me, for I am gentle and humble in heart, and you will find rest for your souls."',
      verseRef: 'Matthew 11:28–30',
      readingRef: 'Psalm 62:1–8',
      readingText:
          '"Truly my soul finds rest in God; my salvation comes from him. Truly he is my rock and my salvation; he is my fortress, I will never be shaken... Trust in him at all times, you people; pour out your hearts to him, for God is our refuge."',
      reflectionQuestion: 'What does it actually mean for you to "rest" in God today — not tomorrow?',
      footerVerse: 'Be still and know that I am God. — Psalm 46:10',
      gradientColors: [Color(0xFF37474F), Color(0xFF78909C)],
    ),
    BreadContent(
      tag: 'PERFECT PEACE',
      heroTitle: 'Surrender the\nThings You Cannot Control',
      verseText:
          '"You will keep in perfect peace those whose minds are steadfast, because they trust in you. Trust in the Lord forever, for the Lord, the Lord himself, is the Rock eternal."',
      verseRef: 'Isaiah 26:3–4',
      readingRef: 'Romans 8:26–28',
      readingText:
          '"In the same way, the Spirit helps us in our weakness. We do not know what we ought to pray for, but the Spirit himself intercedes for us through wordless groans... And we know that in all things God works for the good of those who love him, who have been called according to his purpose."',
      reflectionQuestion: 'What situation are you gripping tightly that needs to be surrendered to God?',
      footerVerse: 'God works all things together for good. — Romans 8:28',
      gradientColors: [Color(0xFF1A237E), Color(0xFF5C6BC0)],
    ),
    BreadContent(
      tag: 'STRENGTH IN WEAKNESS',
      heroTitle: 'When You Are Weak,\nHe Is Strong',
      verseText:
          '"God is our refuge and strength, an ever-present help in trouble. Therefore we will not fear, though the earth give way and the mountains fall into the heart of the sea."',
      verseRef: 'Psalm 46:1–2',
      readingRef: '2 Corinthians 12:7–10',
      readingText:
          '"But he said to me, \'My grace is sufficient for you, for my power is made perfect in weakness.\' Therefore I will boast all the more gladly about my weaknesses, so that Christ\'s power may rest on me. That is why, for Christ\'s sake, I delight in weaknesses, in insults, in hardships, in persecutions, in difficulties. For when I am weak, then I am strong."',
      reflectionQuestion: 'Where do you most need God\'s strength to show up right now?',
      footerVerse: 'My grace is sufficient for you. — 2 Corinthians 12:9',
      gradientColors: [Color(0xFF4E342E), Color(0xFF8D6E63)],
    ),
  ],

  // 4 – Lonely
  [
    BreadContent(
      tag: 'YOU ARE NOT ALONE',
      heroTitle: 'God Is Closer Than\nYour Next Breath',
      verseText:
          '"Where can I go from your Spirit? Where can I flee from your presence? If I go up to the heavens, you are there; if I make my bed in the depths, you are there."',
      verseRef: 'Psalm 139:7–8',
      readingRef: 'Hebrews 13:5–6',
      readingText:
          '"Never will I leave you; never will I forsake you." So we say with confidence, "The Lord is my helper; I will not be afraid. What can mere mortals do to me?"',
      reflectionQuestion: 'When do you feel most alone? What does God\'s promise of presence mean to you in that moment?',
      footerVerse: 'I am with you always, to the very end of the age. — Matthew 28:20',
      gradientColors: [Color(0xFF283593), Color(0xFF5E81F4)],
    ),
    BreadContent(
      tag: 'CALLED BY NAME',
      heroTitle: 'You Are His,\nAnd He Knows You',
      verseText:
          '"But now, this is what the Lord says — he who created you, Jacob, he who formed you, Israel: \'Do not fear, for I have redeemed you; I have summoned you by name; you are mine.\'"',
      verseRef: 'Isaiah 43:1–3',
      readingRef: 'John 15:13–17',
      readingText:
          '"Greater love has no one than this: to lay down one\'s life for one\'s friends. You are my friends if you do what I command. I no longer call you servants, because a servant does not know his master\'s business. Instead, I have called you friends, for everything that I learned from my Father I have made known to you."',
      reflectionQuestion: 'Jesus calls you His friend. How does being known and chosen by God change your sense of loneliness?',
      footerVerse: 'You are precious in my eyes. — Isaiah 43:4',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
    ),
    BreadContent(
      tag: 'NEVER SEPARATED',
      heroTitle: 'Nothing Can Separate\nYou from His Love',
      verseText:
          '"Even though I walk through the darkest valley, I will fear no evil, for you are with me; your rod and your staff, they comfort me."',
      verseRef: 'Psalm 23:4',
      readingRef: 'Romans 8:38–39',
      readingText:
          '"For I am convinced that neither death nor life, neither angels nor demons, neither the present nor the future, nor any powers, neither height nor depth, nor anything else in all creation, will be able to separate us from the love of God that is in Christ Jesus our Lord."',
      reflectionQuestion: 'What would change if you truly believed nothing could separate you from God\'s love?',
      footerVerse: 'The Lord is close to the brokenhearted. — Psalm 34:18',
      gradientColors: [Color(0xFF4A148C), Color(0xFFCE93D8)],
    ),
  ],

  // 5 – Peaceful
  [
    BreadContent(
      tag: 'PEACE THAT PASSES ALL',
      heroTitle: 'Still Waters,\nRestored Soul',
      verseText:
          '"The peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus."',
      verseRef: 'Philippians 4:7',
      readingRef: 'Colossians 3:12–16',
      readingText:
          '"Let the peace of Christ rule in your hearts, since as members of one body you were called to peace. And be thankful. Let the message of Christ dwell among you richly as you teach and admonish one another with all wisdom through psalms, hymns, and songs from the Spirit, singing to God with gratitude in your hearts."',
      reflectionQuestion: 'How can you carry this peace you feel today into the life of someone around you?',
      footerVerse: 'He leads me beside still waters; he restores my soul. — Psalm 23:2–3',
      gradientColors: [Color(0xFF006064), Color(0xFF4DD0E1)],
    ),
    BreadContent(
      tag: 'REST IN HIM',
      heroTitle: 'Lie Down in Green\nPastures Today',
      verseText:
          '"In peace I will lie down and sleep, for you alone, Lord, make me dwell in safety."',
      verseRef: 'Psalm 4:8',
      readingRef: 'John 16:31–33',
      readingText:
          '"I have told you these things, so that in me you may have peace. In this world you will have trouble. But take heart! I have overcome the world." Jesus does not promise a life without storms — he promises that through him every storm has already been overcome.',
      reflectionQuestion: 'What do you want to do with this stillness you have today? How will you steward it?',
      footerVerse: 'Take heart! I have overcome the world. — John 16:33',
      gradientColors: [Color(0xFF2E7D32), Color(0xFFA5D6A7)],
    ),
    BreadContent(
      tag: 'GUARDED IN PEACE',
      heroTitle: 'A Mind Stayed on God\nIs a Mind at Peace',
      verseText:
          '"You will keep in perfect peace those whose minds are steadfast, because they trust in you."',
      verseRef: 'Isaiah 26:3',
      readingRef: 'Luke 2:13–14',
      readingText:
          '"Suddenly a great company of the heavenly host appeared with the angel, praising God and saying, \'Glory to God in the highest heaven, and on earth peace to those on whom his favor rests.\'" The peace you carry is not yours alone — it is heaven\'s announcement over your life.',
      reflectionQuestion: 'Your peace is a gift from God. How is your peace a witness and blessing to others today?',
      footerVerse: 'Glory to God in the highest; on earth, peace. — Luke 2:14',
      gradientColors: [Color(0xFF0D47A1), Color(0xFF90CAF9)],
    ),
  ],
];
