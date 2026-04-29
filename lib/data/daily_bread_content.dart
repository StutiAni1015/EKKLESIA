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

// 6 emotions × 7 variations = 42 unique daily reflections (one per day of the week)
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
    BreadContent(
      tag: 'PLANS FOR YOUR FUTURE',
      heroTitle: 'God Holds Your\nTomorrow in His Hands',
      verseText:
          '"For I know the plans I have for you," declares the Lord, "plans to prosper you and not to harm you, plans to give you hope and a future."',
      verseRef: 'Jeremiah 29:11',
      readingRef: 'Romans 8:26–30',
      readingText:
          '"And we know that in all things God works for the good of those who love him, who have been called according to his purpose... For those God foreknew he also predestined to be conformed to the image of his Son... And those he predestined, he also called; those he called, he also justified; those he justified, he also glorified."',
      reflectionQuestion: 'When anxiety about the future grips you, how does knowing God has a plan for you bring relief?',
      footerVerse: 'Commit your way to the Lord; trust in him. — Psalm 37:5',
      gradientColors: [Color(0xFF33691E), Color(0xFF8BC34A)],
    ),
    BreadContent(
      tag: 'ONE DAY AT A TIME',
      heroTitle: 'Today Is Enough —\nDo Not Borrow Tomorrow',
      verseText:
          '"Therefore do not worry about tomorrow, for tomorrow will worry about itself. Each day has enough trouble of its own."',
      verseRef: 'Matthew 6:34',
      readingRef: 'Lamentations 3:22–24',
      readingText:
          '"Because of the Lord\'s great love we are not consumed, for his compassions never fail. They are new every morning; great is your faithfulness. I say to myself, \'The Lord is my portion; therefore I will wait for him.\'"',
      reflectionQuestion: 'What specific anxiety about the future are you carrying today that belongs to God, not you?',
      footerVerse: 'Great is thy faithfulness. — Lamentations 3:23',
      gradientColors: [Color(0xFF546E7A), Color(0xFF90A4AE)],
    ),
    BreadContent(
      tag: 'MY LIGHT AND SALVATION',
      heroTitle: 'When Fear Comes,\nRemember Who Your God Is',
      verseText:
          '"The Lord is my light and my salvation — whom shall I fear? The Lord is the stronghold of my life — of whom shall I be afraid?"',
      verseRef: 'Psalm 27:1',
      readingRef: 'Psalm 27:1–8',
      readingText:
          '"When the wicked advance against me to devour me, it is my enemies and my foes who will stumble and fall. Though an army besiege me, my heart will not fear; though war break out against me, even then I will be confident... For in the day of trouble he will keep me safe in his dwelling; he will hide me in the shelter of his sacred tent."',
      reflectionQuestion: 'Name one thing you fear today. Then read this verse aloud. What changes?',
      footerVerse: 'The Lord is my helper; I will not be afraid. — Hebrews 13:6',
      gradientColors: [Color(0xFF6D1B7B), Color(0xFFCE93D8)],
    ),
    BreadContent(
      tag: 'WINGS LIKE EAGLES',
      heroTitle: 'God Renews Your Strength\nWhen You Are Exhausted',
      verseText:
          '"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint."',
      verseRef: 'Isaiah 40:31',
      readingRef: 'Isaiah 40:28–31',
      readingText:
          '"Do you not know? Have you not heard? The Lord is the everlasting God, the Creator of the ends of the earth. He will not grow tired or weary, and his understanding no one can fathom. He gives strength to the weary and increases the power of the weak. Even youths grow tired and weary, and young men stumble and fall; but those who hope in the Lord will renew their strength."',
      reflectionQuestion: 'In what area of your life are you most weary right now? Ask God to be your strength there.',
      footerVerse: 'He gives strength to the weary. — Isaiah 40:29',
      gradientColors: [Color(0xFF01579B), Color(0xFF4FC3F7)],
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
    BreadContent(
      tag: 'A CHEERFUL HEART',
      heroTitle: 'Joy Is Medicine for\nthe Soul',
      verseText:
          '"A cheerful heart is good medicine, but a crushed spirit dries up the bones."',
      verseRef: 'Proverbs 17:22',
      readingRef: 'John 15:9–12',
      readingText:
          '"As the Father has loved me, so have I loved you. Now remain in my love. If you keep my commands, you will remain in my love, just as I have kept my Father\'s commands and remain in his love. I have told you this so that my joy may be in you and that your joy may be complete."',
      reflectionQuestion: 'How does the joy you carry today affect the people around you? Who needs to experience it?',
      footerVerse: 'A joyful heart makes a cheerful face. — Proverbs 15:13',
      gradientColors: [Color(0xFFF57F17), Color(0xFFFFD54F)],
    ),
    BreadContent(
      tag: 'YET I WILL REJOICE',
      heroTitle: 'True Joy Doesn\'t Need\nPerfect Circumstances',
      verseText:
          '"Though the fig tree does not bud and there are no grapes on the vines... yet I will rejoice in the Lord, I will be joyful in God my Savior."',
      verseRef: 'Habakkuk 3:17–18',
      readingRef: 'James 1:2–4',
      readingText:
          '"Consider it pure joy, my brothers and sisters, whenever you face trials of many kinds, because you know that the testing of your faith produces perseverance. Let perseverance finish its work so that you may be mature and complete, not lacking anything."',
      reflectionQuestion: 'What can you find to rejoice about today even if circumstances aren\'t ideal?',
      footerVerse: 'Rejoice in the Lord always. — Philippians 4:4',
      gradientColors: [Color(0xFF558B2F), Color(0xFFAED581)],
    ),
    BreadContent(
      tag: 'PRAISE HIS HOLY NAME',
      heroTitle: 'Praise Is the Language\nof a Joyful Heart',
      verseText:
          '"Shout for joy to the Lord, all the earth! Worship the Lord with gladness; come before him with joyful songs."',
      verseRef: 'Psalm 100:1–2',
      readingRef: 'Psalm 150:1–6',
      readingText:
          '"Praise the Lord. Praise God in his sanctuary; praise him in his mighty heavens. Praise him for his acts of power; praise him for his surpassing greatness. Praise him with the sounding of the trumpet, praise him with the harp and lyre... Let everything that has breath praise the Lord. Praise the Lord."',
      reflectionQuestion: 'What is one song, hymn, or prayer of praise you will offer to God today?',
      footerVerse: 'Let everything that has breath praise the Lord! — Psalm 150:6',
      gradientColors: [Color(0xFFE65100), Color(0xFFFFCC80)],
    ),
    BreadContent(
      tag: 'FULLNESS OF JOY',
      heroTitle: 'In His Presence Is\nFullness of Joy',
      verseText:
          '"You make known to me the path of life; in your presence there is fullness of joy; at your right hand are pleasures forevermore."',
      verseRef: 'Psalm 16:11',
      readingRef: 'Acts 2:25–28',
      readingText:
          '"I saw the Lord always before me. Because he is at my right hand, I will not be shaken. Therefore my heart is glad and my tongue rejoices; my body also will rest in hope... You have made known to me the paths of life; you will fill me with joy in your presence."',
      reflectionQuestion: 'How does spending time in God\'s presence deepen or renew your joy today?',
      footerVerse: 'In your presence there is fullness of joy. — Psalm 16:11',
      gradientColors: [Color(0xFF880E4F), Color(0xFFF48FB1)],
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
    BreadContent(
      tag: 'ENTER WITH PRAISE',
      heroTitle: 'Gratitude Opens the\nGates of His Presence',
      verseText:
          '"Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name. For the Lord is good and his love endures forever."',
      verseRef: 'Psalm 100:4–5',
      readingRef: 'Psalm 9:1–4',
      readingText:
          '"I will give thanks to you, Lord, with all my heart; I will tell of all your wonderful deeds. I will be glad and rejoice in you; I will sing the praises of your name, O Most High. My enemies turn back; they stumble and perish before you."',
      reflectionQuestion: 'How would approaching God with thanksgiving right now shift your heart\'s posture?',
      footerVerse: 'Give thanks to him and praise his name. — Psalm 100:4',
      gradientColors: [Color(0xFF1A237E), Color(0xFF7986CB)],
    ),
    BreadContent(
      tag: 'GRATITUDE IN ALL THINGS',
      heroTitle: 'Give Thanks Even\nWhen It Is Hard',
      verseText:
          '"And let the peace of Christ rule in your hearts, to which indeed you were called in one body. And be thankful."',
      verseRef: 'Colossians 3:15',
      readingRef: '1 Thessalonians 5:16–18',
      readingText:
          '"Rejoice always, pray continually, give thanks in all circumstances; for this is God\'s will for you in Christ Jesus." Three commands, one lifestyle: rejoice, pray, give thanks. Not when life is easy — in all circumstances.',
      reflectionQuestion: 'What is the hardest thing for you to be grateful for right now? Bring it before God.',
      footerVerse: 'Give thanks in all circumstances. — 1 Thessalonians 5:18',
      gradientColors: [Color(0xFF004D40), Color(0xFF4DB6AC)],
    ),
    BreadContent(
      tag: 'HE DID NOT WITHHOLD',
      heroTitle: 'The Cross Proves He\nHolds Nothing Back',
      verseText:
          '"He who did not spare his own Son, but gave him up for us all — how will he not also, along with him, graciously give us all things?"',
      verseRef: 'Romans 8:32',
      readingRef: 'Ephesians 1:3–8',
      readingText:
          '"Praise be to the God and Father of our Lord Jesus Christ, who has blessed us in the heavenly realms with every spiritual blessing in Christ... In him we have redemption through his blood, the forgiveness of sins, in accordance with the riches of God\'s grace that he lavished on us."',
      reflectionQuestion: 'Because of the cross, what can you be confident God will also provide for you today?',
      footerVerse: 'He lavished on us the riches of his grace. — Ephesians 1:8',
      gradientColors: [Color(0xFF311B92), Color(0xFFB39DDB)],
    ),
    BreadContent(
      tag: 'MORNING MERCIES',
      heroTitle: 'Every Morning Is a\nFresh Gift from God',
      verseText:
          '"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness."',
      verseRef: 'Lamentations 3:22–23',
      readingRef: 'Psalm 92:1–5',
      readingText:
          '"It is good to praise the Lord and make music to your name, O Most High, proclaiming your love in the morning and your faithfulness at night... For you make me glad by your deeds, Lord; I sing for joy at what your hands have done. How great are your works, Lord, how profound your thoughts!"',
      reflectionQuestion: 'What\'s one mercy God gave you today — this morning — that you almost missed?',
      footerVerse: 'His mercies are new every morning. — Lamentations 3:23',
      gradientColors: [Color(0xFF827717), Color(0xFFF9A825)],
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
    BreadContent(
      tag: 'TRUST WITH ALL YOUR HEART',
      heroTitle: 'Let Go of Your Own\nUnderstanding',
      verseText:
          '"Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight."',
      verseRef: 'Proverbs 3:5–6',
      readingRef: 'Psalm 46:1–7',
      readingText:
          '"God is our refuge and strength, an ever-present help in trouble. Therefore we will not fear, though the earth give way and the mountains fall into the heart of the sea, though its waters roar and foam and the mountains quake with their surging... The Lord Almighty is with us; the God of Jacob is our fortress."',
      reflectionQuestion: 'What area of your life are you trying to control instead of trusting God with? Hand it over.',
      footerVerse: 'He will make your paths straight. — Proverbs 3:6',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF81C784)],
    ),
    BreadContent(
      tag: 'DO NOT TROUBLE YOUR HEART',
      heroTitle: 'Jesus Is the Answer\nto Every Anxious Thought',
      verseText:
          '"Do not let your hearts be troubled. You believe in God; believe also in me."',
      verseRef: 'John 14:1',
      readingRef: 'John 14:1–6',
      readingText:
          '"My Father\'s house has many rooms; if that were not so, would I have told you that I am going there to prepare a place for you? And if I go and prepare a place for you, I will come back and take you to be with me that you also may be where I am."',
      reflectionQuestion: 'Jesus says "do not let your heart be troubled." What does it look like for you to choose that today?',
      footerVerse: 'You believe in God; believe also in me. — John 14:1',
      gradientColors: [Color(0xFF006064), Color(0xFF80DEEA)],
    ),
    BreadContent(
      tag: 'STILL AND KNOW',
      heroTitle: 'When the Storm Rages,\nBe Still',
      verseText:
          '"Be still, and know that I am God; I will be exalted among the nations, I will be exalted in the earth."',
      verseRef: 'Psalm 46:10',
      readingRef: 'Mark 4:35–41',
      readingText:
          '"He got up, rebuked the wind and said to the waves, \'Quiet! Be still!\' Then the wind died down and it was completely calm. He said to his disciples, \'Why are you so afraid? Do you still have no faith?\'"',
      reflectionQuestion: 'In the middle of your storm, what would it look like to truly "be still" before God today?',
      footerVerse: 'Even the winds and the waves obey him. — Mark 4:41',
      gradientColors: [Color(0xFF0D47A1), Color(0xFF64B5F6)],
    ),
    BreadContent(
      tag: 'LAID AT HIS FEET',
      heroTitle: 'Every Burden Is\nWelcome at the Cross',
      verseText:
          '"Come to me, all you who are weary and burdened, and I will give you rest."',
      verseRef: 'Matthew 11:28',
      readingRef: 'Psalm 55:22',
      readingText:
          '"Cast your cares on the Lord and he will sustain you; he will never let the righteous be shaken." There is no burden too heavy for Jesus to carry. Whatever you are dragging today — lay it at His feet. He is not overwhelmed by your stress.',
      reflectionQuestion: 'What specific burden will you physically imagine laying at Jesus\' feet right now?',
      footerVerse: 'Cast your cares on the Lord. — Psalm 55:22',
      gradientColors: [Color(0xFF3E2723), Color(0xFFA1887F)],
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
    BreadContent(
      tag: 'I WILL NOT LEAVE YOU',
      heroTitle: 'He Has Promised to\nNever Walk Away',
      verseText:
          '"Be strong and courageous. Do not be afraid or terrified because of them, for the Lord your God goes with you; he will never leave you nor forsake you."',
      verseRef: 'Deuteronomy 31:6',
      readingRef: 'Joshua 1:7–9',
      readingText:
          '"Be strong and very courageous... Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go." These were not words of wishful thinking — they were God\'s personal promise to Joshua, and to you.',
      reflectionQuestion: 'God promises He goes with you. Where do you most need to feel His presence today?',
      footerVerse: 'The Lord your God is with you wherever you go. — Joshua 1:9',
      gradientColors: [Color(0xFF880E4F), Color(0xFFE91E63)],
    ),
    BreadContent(
      tag: 'WITH ME ALWAYS',
      heroTitle: 'Jesus Never Leaves\nYou to Walk Alone',
      verseText:
          '"And surely I am with you always, to the very end of the age."',
      verseRef: 'Matthew 28:20',
      readingRef: 'Psalm 23:1–6',
      readingText:
          '"Even though I walk through the darkest valley, I will fear no evil, for you are with me; your rod and your staff, they comfort me. You prepare a table before me in the presence of my enemies... Surely your goodness and love will follow me all the days of my life."',
      reflectionQuestion: 'Jesus walks with you today. What conversation are you yet to have with Him about your loneliness?',
      footerVerse: 'I am with you always. — Matthew 28:20',
      gradientColors: [Color(0xFF1A237E), Color(0xFF42A5F5)],
    ),
    BreadContent(
      tag: 'COMMUNITY IS GOD\'S GIFT',
      heroTitle: 'You Were Made\nfor Connection',
      verseText:
          '"Two are better than one, because they have a good return for their labor: If either of them falls down, one can help the other up."',
      verseRef: 'Ecclesiastes 4:9–10',
      readingRef: 'Acts 2:42–47',
      readingText:
          '"They devoted themselves to the apostles\' teaching and to fellowship, to the breaking of bread and to prayer... All the believers were together and had everything in common... They broke bread in their homes and ate together with glad and sincere hearts, praising God and enjoying the favor of all the people."',
      reflectionQuestion: 'Who in your church community can you reach out to today to break the cycle of loneliness?',
      footerVerse: 'God sets the lonely in families. — Psalm 68:6',
      gradientColors: [Color(0xFF004D40), Color(0xFF80CBC4)],
    ),
    BreadContent(
      tag: 'CLOSE TO THE BROKENHEARTED',
      heroTitle: 'He Draws Near When\nYou Feel Farthest Away',
      verseText:
          '"The Lord is close to the brokenhearted and saves those who are crushed in spirit."',
      verseRef: 'Psalm 34:18',
      readingRef: 'Psalm 34:15–22',
      readingText:
          '"The eyes of the Lord are on the righteous, and his ears are attentive to their cry... The righteous person may have many troubles, but the Lord delivers him from them all; he protects all his bones, not one of them will be broken. Evil will slay the wicked; the foes of the righteous will be condemned. The Lord will rescue his servants."',
      reflectionQuestion: 'In what ways has God showed up for you in past moments of loneliness? Remember those now.',
      footerVerse: 'The Lord is close to the brokenhearted. — Psalm 34:18',
      gradientColors: [Color(0xFF37474F), Color(0xFF90A4AE)],
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
    BreadContent(
      tag: 'JUSTIFIED BY FAITH',
      heroTitle: 'Peace with God Is\nYour Firm Foundation',
      verseText:
          '"Therefore, since we have been justified through faith, we have peace with God through our Lord Jesus Christ."',
      verseRef: 'Romans 5:1',
      readingRef: 'Romans 5:1–5',
      readingText:
          '"We have peace with God through our Lord Jesus Christ, through whom we have gained access by faith into this grace in which we now stand. And we boast in the hope of the glory of God. Not only so, but we also glory in our sufferings, because we know that suffering produces perseverance; perseverance, character; and character, hope."',
      reflectionQuestion: 'How does knowing you are at peace with God change how you see your circumstances today?',
      footerVerse: 'We have peace with God through our Lord Jesus Christ. — Romans 5:1',
      gradientColors: [Color(0xFF4A148C), Color(0xFF9C27B0)],
    ),
    BreadContent(
      tag: 'THE BLESSING OF PEACE',
      heroTitle: 'God\'s Face Is Turned\nToward You',
      verseText:
          '"The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you; the Lord turn his face toward you and give you peace."',
      verseRef: 'Numbers 6:24–26',
      readingRef: 'John 20:19–21',
      readingText:
          '"On the evening of that first day of the week, when the disciples were together, with the doors locked for fear of the Jewish leaders, Jesus came and stood among them and said, \'Peace be with you!\' After he said this, he showed them his hands and side... Again Jesus said, \'Peace be with you! As the Father has sent me, I am sending you.\'"',
      reflectionQuestion: 'Receive this blessing over your life today. How does it change your posture toward God and others?',
      footerVerse: 'The Lord turn his face toward you and give you peace. — Numbers 6:26',
      gradientColors: [Color(0xFF006064), Color(0xFF26C6DA)],
    ),
    BreadContent(
      tag: 'PEACEFUL SURRENDER',
      heroTitle: 'Surrender Is Not Defeat —\nIt Is Peace',
      verseText:
          '"Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God. And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus."',
      verseRef: 'Philippians 4:6–7',
      readingRef: 'Psalm 131:1–3',
      readingText:
          '"My heart is not lifted up; my eyes are not raised too high; I do not occupy myself with things too great and too marvelous for me. But I have calmed and quieted my soul, like a weaned child with its mother; like a weaned child is my soul within me. O Israel, hope in the Lord from this time forth and forevermore."',
      reflectionQuestion: 'Describe what a "calmed and quieted soul" looks like in your life. How do you get there today?',
      footerVerse: 'The peace of God will guard your hearts. — Philippians 4:7',
      gradientColors: [Color(0xFF37474F), Color(0xFF78909C)],
    ),
    BreadContent(
      tag: 'DEEP ROOTS IN PEACE',
      heroTitle: 'Let Your Peace Flow\nLike a River',
      verseText:
          '"If only you had paid attention to my commands, your peace would have been like a river, your well-being like the waves of the sea."',
      verseRef: 'Isaiah 48:18',
      readingRef: 'Isaiah 48:17–19',
      readingText:
          '"This is what the Lord says — your Redeemer, the Holy One of Israel: \'I am the Lord your God, who teaches you what is best for you, who directs you in the way you should go. If only you had paid attention to my commands, your peace would have been like a river, your well-being like the waves of the sea.\'"',
      reflectionQuestion: 'Where has obedience to God brought you peace? How can that truth anchor you today?',
      footerVerse: 'Your peace would have been like a river. — Isaiah 48:18',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
    ),
  ],
];
