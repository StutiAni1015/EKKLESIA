import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Global locale notifier — set this to change the whole app's language
// ---------------------------------------------------------------------------
final appLocaleNotifier = ValueNotifier<Locale>(const Locale('en'));

// ---------------------------------------------------------------------------
// AppLocalizations — all translated strings
// ---------------------------------------------------------------------------
class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<AppLocalizationsScope>();
    return inherited?.localizations ?? AppLocalizations(const Locale('en'));
  }

  static const _translations = <String, Map<String, String>>{
    // ── Navigation ──────────────────────────────────────────────────────────
    'home': {
      'en': 'Home', 'es': 'Inicio', 'fr': 'Accueil', 'pt': 'Início',
      'ko': '홈', 'zh': '首页', 'hi': 'होम', 'ar': 'الرئيسية',
      'sw': 'Nyumbani', 'tl': 'Tahanan',
    },
    'sermons': {
      'en': 'Sermons', 'es': 'Sermones', 'fr': 'Sermons', 'pt': 'Sermões',
      'ko': '설교', 'zh': '讲道', 'hi': 'उपदेश', 'ar': 'العظات',
      'sw': 'Mahubiri', 'tl': 'Mga Sermon',
    },
    'community': {
      'en': 'Community', 'es': 'Comunidad', 'fr': 'Communauté',
      'pt': 'Comunidade', 'ko': '커뮤니티', 'zh': '社区', 'hi': 'समुदाय',
      'ar': 'المجتمع', 'sw': 'Jamii', 'tl': 'Komunidad',
    },
    'profile': {
      'en': 'Profile', 'es': 'Perfil', 'fr': 'Profil', 'pt': 'Perfil',
      'ko': '프로필', 'zh': '个人资料', 'hi': 'प्रोफ़ाइल',
      'ar': 'الملف الشخصي', 'sw': 'Wasifu', 'tl': 'Profile',
    },
    'treasury': {
      'en': 'Treasury', 'es': 'Tesorería', 'fr': 'Trésorerie',
      'pt': 'Tesouraria', 'ko': '재정', 'zh': '财务', 'hi': 'खजाना',
      'ar': 'الخزينة', 'sw': 'Hazina', 'tl': 'Kabang-yaman',
    },
    'polls': {
      'en': 'Polls', 'es': 'Encuestas', 'fr': 'Sondages', 'pt': 'Enquetes',
      'ko': '투표', 'zh': '投票', 'hi': 'सर्वेक्षण', 'ar': 'الاستطلاعات',
      'sw': 'Kura', 'tl': 'Botohan',
    },
    'bible': {
      'en': 'Bible', 'es': 'Biblia', 'fr': 'Bible', 'pt': 'Bíblia',
      'ko': '성경', 'zh': '圣经', 'hi': 'बाइबिल', 'ar': 'الكتاب المقدس',
      'sw': 'Biblia', 'tl': 'Bibliya',
    },
    'hub': {
      'en': 'Hub', 'es': 'Centro', 'fr': 'Centre', 'pt': 'Hub',
      'ko': '허브', 'zh': '中心', 'hi': 'हब', 'ar': 'المركز',
      'sw': 'Kituo', 'tl': 'Hub',
    },
    'more': {
      'en': 'More', 'es': 'Más', 'fr': 'Plus', 'pt': 'Mais',
      'ko': '더보기', 'zh': '更多', 'hi': 'अधिक', 'ar': 'المزيد',
      'sw': 'Zaidi', 'tl': 'Higit pa',
    },
    // ── Common actions ───────────────────────────────────────────────────────
    'continueLabel': {
      'en': 'Continue', 'es': 'Continuar', 'fr': 'Continuer',
      'pt': 'Continuar', 'ko': '계속', 'zh': '继续', 'hi': 'जारी रखें',
      'ar': 'متابعة', 'sw': 'Endelea', 'tl': 'Magpatuloy',
    },
    'back': {
      'en': 'Back', 'es': 'Atrás', 'fr': 'Retour', 'pt': 'Voltar',
      'ko': '뒤로', 'zh': '返回', 'hi': 'वापस', 'ar': 'رجوع',
      'sw': 'Rudi', 'tl': 'Bumalik',
    },
    'cancel': {
      'en': 'Cancel', 'es': 'Cancelar', 'fr': 'Annuler', 'pt': 'Cancelar',
      'ko': '취소', 'zh': '取消', 'hi': 'रद्द करें', 'ar': 'إلغاء',
      'sw': 'Ghairi', 'tl': 'Kanselahin',
    },
    'save': {
      'en': 'Save', 'es': 'Guardar', 'fr': 'Enregistrer', 'pt': 'Salvar',
      'ko': '저장', 'zh': '保存', 'hi': 'सहेजें', 'ar': 'حفظ',
      'sw': 'Hifadhi', 'tl': 'I-save',
    },
    'edit': {
      'en': 'Edit', 'es': 'Editar', 'fr': 'Modifier', 'pt': 'Editar',
      'ko': '편집', 'zh': '编辑', 'hi': 'संपादित करें', 'ar': 'تعديل',
      'sw': 'Hariri', 'tl': 'I-edit',
    },
    'confirm': {
      'en': 'Confirm', 'es': 'Confirmar', 'fr': 'Confirmer',
      'pt': 'Confirmar', 'ko': '확인', 'zh': '确认', 'hi': 'पुष्टि करें',
      'ar': 'تأكيد', 'sw': 'Thibitisha', 'tl': 'Kumpirmahin',
    },
    'close': {
      'en': 'Close', 'es': 'Cerrar', 'fr': 'Fermer', 'pt': 'Fechar',
      'ko': '닫기', 'zh': '关闭', 'hi': 'बंद करें', 'ar': 'إغلاق',
      'sw': 'Funga', 'tl': 'Isara',
    },
    'share': {
      'en': 'Share', 'es': 'Compartir', 'fr': 'Partager', 'pt': 'Compartilhar',
      'ko': '공유', 'zh': '分享', 'hi': 'साझा करें', 'ar': 'مشاركة',
      'sw': 'Shiriki', 'tl': 'Ibahagi',
    },
    'search': {
      'en': 'Search', 'es': 'Buscar', 'fr': 'Rechercher', 'pt': 'Buscar',
      'ko': '검색', 'zh': '搜索', 'hi': 'खोजें', 'ar': 'بحث',
      'sw': 'Tafuta', 'tl': 'Hanapin',
    },
    'done': {
      'en': 'Done', 'es': 'Listo', 'fr': 'Terminé', 'pt': 'Concluído',
      'ko': '완료', 'zh': '完成', 'hi': 'हो गया', 'ar': 'تم',
      'sw': 'Imekamilika', 'tl': 'Tapos',
    },
    'submit': {
      'en': 'Submit', 'es': 'Enviar', 'fr': 'Soumettre', 'pt': 'Enviar',
      'ko': '제출', 'zh': '提交', 'hi': 'जमा करें', 'ar': 'إرسال',
      'sw': 'Wasilisha', 'tl': 'Isumite',
    },
    'loading': {
      'en': 'Loading...', 'es': 'Cargando...', 'fr': 'Chargement...',
      'pt': 'Carregando...', 'ko': '로딩 중...', 'zh': '加载中...',
      'hi': 'लोड हो रहा है...', 'ar': 'جار التحميل...',
      'sw': 'Inapakia...', 'tl': 'Naglo-load...',
    },
    'getStarted': {
      'en': 'Get Started', 'es': 'Comenzar', 'fr': 'Commencer',
      'pt': 'Começar', 'ko': '시작하기', 'zh': '开始', 'hi': 'शुरू करें',
      'ar': 'ابدأ', 'sw': 'Anza', 'tl': 'Magsimula',
    },
    'signIn': {
      'en': 'Sign In', 'es': 'Iniciar Sesión', 'fr': 'Se connecter',
      'pt': 'Entrar', 'ko': '로그인', 'zh': '登录', 'hi': 'साइन इन',
      'ar': 'تسجيل الدخول', 'sw': 'Ingia', 'tl': 'Mag-sign In',
    },
    'signUp': {
      'en': 'Sign Up', 'es': 'Registrarse', 'fr': "S'inscrire",
      'pt': 'Cadastrar', 'ko': '회원가입', 'zh': '注册', 'hi': 'साइन अप',
      'ar': 'إنشاء حساب', 'sw': 'Jisajili', 'tl': 'Mag-sign Up',
    },
    'invite': {
      'en': 'Invite', 'es': 'Invitar', 'fr': 'Inviter', 'pt': 'Convidar',
      'ko': '초대', 'zh': '邀请', 'hi': 'आमंत्रित करें', 'ar': 'دعوة',
      'sw': 'Alika', 'tl': 'Imbitahan',
    },
    'export': {
      'en': 'Export', 'es': 'Exportar', 'fr': 'Exporter', 'pt': 'Exportar',
      'ko': '내보내기', 'zh': '导出', 'hi': 'निर्यात करें', 'ar': 'تصدير',
      'sw': 'Hamisha', 'tl': 'I-export',
    },
    'register': {
      'en': 'Register', 'es': 'Registrar', 'fr': 'S\'inscrire',
      'pt': 'Registrar', 'ko': '등록', 'zh': '注册', 'hi': 'पंजीकरण करें',
      'ar': 'تسجيل', 'sw': 'Jisajili', 'tl': 'Mag-register',
    },
    'download': {
      'en': 'Download', 'es': 'Descargar', 'fr': 'Télécharger',
      'pt': 'Baixar', 'ko': '다운로드', 'zh': '下载', 'hi': 'डाउनलोड',
      'ar': 'تحميل', 'sw': 'Pakua', 'tl': 'I-download',
    },
    // ── Status labels ────────────────────────────────────────────────────────
    'verified': {
      'en': 'Verified', 'es': 'Verificado', 'fr': 'Vérifié',
      'pt': 'Verificado', 'ko': '인증됨', 'zh': '已认证', 'hi': 'सत्यापित',
      'ar': 'موثق', 'sw': 'Imethibitishwa', 'tl': 'Na-verify',
    },
    'pending': {
      'en': 'Pending', 'es': 'Pendiente', 'fr': 'En attente', 'pt': 'Pendente',
      'ko': '보류 중', 'zh': '待处理', 'hi': 'लंबित', 'ar': 'قيد الانتظار',
      'sw': 'Inasubiri', 'tl': 'Naghihintay',
    },
    'active': {
      'en': 'Active', 'es': 'Activo', 'fr': 'Actif', 'pt': 'Ativo',
      'ko': '활성', 'zh': '活跃', 'hi': 'सक्रिय', 'ar': 'نشط',
      'sw': 'Hai', 'tl': 'Aktibo',
    },
    'inactive': {
      'en': 'Inactive', 'es': 'Inactivo', 'fr': 'Inactif', 'pt': 'Inativo',
      'ko': '비활성', 'zh': '不活跃', 'hi': 'निष्क्रिय', 'ar': 'غير نشط',
      'sw': 'Haifanyi kazi', 'tl': 'Hindi aktibo',
    },
    'closed': {
      'en': 'Closed', 'es': 'Cerrado', 'fr': 'Fermé', 'pt': 'Fechado',
      'ko': '종료', 'zh': '已关闭', 'hi': 'बंद', 'ar': 'مغلق',
      'sw': 'Imefungwa', 'tl': 'Sarado',
    },
    'liveNow': {
      'en': 'LIVE', 'es': 'EN VIVO', 'fr': 'EN DIRECT', 'pt': 'AO VIVO',
      'ko': '라이브', 'zh': '直播中', 'hi': 'लाइव', 'ar': 'مباشر',
      'sw': 'MOJA KWA MOJA', 'tl': 'LIVE',
    },
    // ── Church / community ───────────────────────────────────────────────────
    'members': {
      'en': 'Members', 'es': 'Miembros', 'fr': 'Membres', 'pt': 'Membros',
      'ko': '회원', 'zh': '成员', 'hi': 'सदस्य', 'ar': 'الأعضاء',
      'sw': 'Wanachama', 'tl': 'Mga Miyembro',
    },
    'events': {
      'en': 'Events', 'es': 'Eventos', 'fr': 'Événements', 'pt': 'Eventos',
      'ko': '이벤트', 'zh': '活动', 'hi': 'कार्यक्रम', 'ar': 'الفعاليات',
      'sw': 'Matukio', 'tl': 'Mga Kaganapan',
    },
    'viewProfile': {
      'en': 'View Profile', 'es': 'Ver Perfil', 'fr': 'Voir le profil',
      'pt': 'Ver Perfil', 'ko': '프로필 보기', 'zh': '查看资料',
      'hi': 'प्रोफ़ाइल देखें', 'ar': 'عرض الملف', 'sw': 'Angalia Wasifu',
      'tl': 'Tingnan ang Profile',
    },
    'joinChurch': {
      'en': 'Join Church', 'es': 'Unirse a la Iglesia',
      'fr': "Rejoindre l'Église", 'pt': 'Entrar na Igreja',
      'ko': '교회 가입', 'zh': '加入教会', 'hi': 'चर्च में शामिल हों',
      'ar': 'الانضمام للكنيسة', 'sw': 'Jiunge na Kanisa',
      'tl': 'Sumali sa Simbahan',
    },
    'prayWith': {
      'en': 'Pray With Us', 'es': 'Ora Con Nosotros',
      'fr': 'Priez avec nous', 'pt': 'Ore Conosco',
      'ko': '함께 기도하기', 'zh': '一起祷告', 'hi': 'हमारे साथ प्रार्थना करें',
      'ar': 'صلي معنا', 'sw': 'Omba Nasi', 'tl': 'Manalangin Kasama Kami',
    },
    'about': {
      'en': 'About', 'es': 'Acerca de', 'fr': 'À propos', 'pt': 'Sobre',
      'ko': '소개', 'zh': '关于', 'hi': 'के बारे में', 'ar': 'حول',
      'sw': 'Kuhusu', 'tl': 'Tungkol sa',
    },
    'leaders': {
      'en': 'Leaders', 'es': 'Líderes', 'fr': 'Dirigeants', 'pt': 'Líderes',
      'ko': '지도자', 'zh': '领袖', 'hi': 'नेता', 'ar': 'القيادة',
      'sw': 'Viongozi', 'tl': 'Mga Lider',
    },
    'founded': {
      'en': 'Founded', 'es': 'Fundado', 'fr': 'Fondé', 'pt': 'Fundado',
      'ko': '창립', 'zh': '成立于', 'hi': 'स्थापित', 'ar': 'تأسس',
      'sw': 'Ilianzishwa', 'tl': 'Itinatag',
    },
    // ── Poll / voting ────────────────────────────────────────────────────────
    'votes': {
      'en': 'Votes', 'es': 'Votos', 'fr': 'Votes', 'pt': 'Votos',
      'ko': '투표수', 'zh': '票数', 'hi': 'वोट', 'ar': 'أصوات',
      'sw': 'Kura', 'tl': 'Mga Boto',
    },
    'vote': {
      'en': 'Vote', 'es': 'Votar', 'fr': 'Voter', 'pt': 'Votar',
      'ko': '투표', 'zh': '投票', 'hi': 'वोट करें', 'ar': 'تصويت',
      'sw': 'Piga kura', 'tl': 'Bumoto',
    },
    'results': {
      'en': 'Results', 'es': 'Resultados', 'fr': 'Résultats',
      'pt': 'Resultados', 'ko': '결과', 'zh': '结果', 'hi': 'परिणाम',
      'ar': 'النتائج', 'sw': 'Matokeo', 'tl': 'Mga Resulta',
    },
    'leading': {
      'en': 'Leading', 'es': 'Liderando', 'fr': 'En tête', 'pt': 'Liderando',
      'ko': '선두', 'zh': '领先', 'hi': 'अग्रणी', 'ar': 'متصدر',
      'sw': 'Inaongoza', 'tl': 'Nangunguna',
    },
    'yourVote': {
      'en': 'Your vote', 'es': 'Tu voto', 'fr': 'Votre vote',
      'pt': 'Seu voto', 'ko': '내 투표', 'zh': '您的投票', 'hi': 'आपका वोट',
      'ar': 'صوتك', 'sw': 'Kura yako', 'tl': 'Ang iyong boto',
    },
    'totalVotes': {
      'en': 'Total Votes', 'es': 'Total de Votos', 'fr': 'Total des votes',
      'pt': 'Total de Votos', 'ko': '총 투표수', 'zh': '总票数', 'hi': 'कुल वोट',
      'ar': 'إجمالي الأصوات', 'sw': 'Jumla ya Kura', 'tl': 'Kabuuang Boto',
    },
    'castYourVote': {
      'en': 'Cast Your Vote', 'es': 'Emite tu voto', 'fr': 'Votez',
      'pt': 'Vote agora', 'ko': '투표하기', 'zh': '立即投票', 'hi': 'अपना वोट डालें',
      'ar': 'أدلِ بصوتك', 'sw': 'Piga kura yako', 'tl': 'Iboto na',
    },
    'shareResults': {
      'en': 'Share Results', 'es': 'Compartir resultados',
      'fr': 'Partager les résultats', 'pt': 'Compartilhar resultados',
      'ko': '결과 공유', 'zh': '分享结果', 'hi': 'परिणाम साझा करें',
      'ar': 'مشاركة النتائج', 'sw': 'Shiriki matokeo',
      'tl': 'Ibahagi ang mga resulta',
    },
    'publishPoll': {
      'en': 'Publish Poll', 'es': 'Publicar Encuesta',
      'fr': 'Publier le sondage', 'pt': 'Publicar Enquete',
      'ko': '투표 게시', 'zh': '发布投票', 'hi': 'पोल प्रकाशित करें',
      'ar': 'نشر الاستطلاع', 'sw': 'Chapisha Kura', 'tl': 'I-publish ang Poll',
    },
    // ── Treasury / finance ───────────────────────────────────────────────────
    'income': {
      'en': 'Income', 'es': 'Ingresos', 'fr': 'Revenus', 'pt': 'Receita',
      'ko': '수입', 'zh': '收入', 'hi': 'आय', 'ar': 'الدخل',
      'sw': 'Mapato', 'tl': 'Kita',
    },
    'expenses': {
      'en': 'Expenses', 'es': 'Gastos', 'fr': 'Dépenses', 'pt': 'Despesas',
      'ko': '지출', 'zh': '支出', 'hi': 'व्यय', 'ar': 'المصروفات',
      'sw': 'Matumizi', 'tl': 'Gastos',
    },
    'balance': {
      'en': 'Balance', 'es': 'Saldo', 'fr': 'Solde', 'pt': 'Saldo',
      'ko': '잔액', 'zh': '余额', 'hi': 'शेष', 'ar': 'الرصيد',
      'sw': 'Salio', 'tl': 'Balanse',
    },
    'logTransaction': {
      'en': 'Log Transaction', 'es': 'Registrar Transacción',
      'fr': 'Enregistrer la transaction', 'pt': 'Registrar Transação',
      'ko': '거래 기록', 'zh': '记录交易', 'hi': 'लेनदेन दर्ज करें',
      'ar': 'تسجيل معاملة', 'sw': 'Rekodi Muamala',
      'tl': 'I-log ang Transaksyon',
    },
    'amount': {
      'en': 'Amount', 'es': 'Monto', 'fr': 'Montant', 'pt': 'Valor',
      'ko': '금액', 'zh': '金额', 'hi': 'राशि', 'ar': 'المبلغ',
      'sw': 'Kiasi', 'tl': 'Halaga',
    },
    'budget': {
      'en': 'Budget', 'es': 'Presupuesto', 'fr': 'Budget', 'pt': 'Orçamento',
      'ko': '예산', 'zh': '预算', 'hi': 'बजट', 'ar': 'الميزانية',
      'sw': 'Bajeti', 'tl': 'Badyet',
    },
    'transactions': {
      'en': 'Transactions', 'es': 'Transacciones', 'fr': 'Transactions',
      'pt': 'Transações', 'ko': '거래 내역', 'zh': '交易记录', 'hi': 'लेनदेन',
      'ar': 'المعاملات', 'sw': 'Miamala', 'tl': 'Mga Transaksyon',
    },
    // ── Onboarding ───────────────────────────────────────────────────────────
    'chooseLanguage': {
      'en': 'Choose your language', 'es': 'Elige tu idioma',
      'fr': 'Choisissez votre langue', 'pt': 'Escolha seu idioma',
      'ko': '언어를 선택하세요', 'zh': '选择语言', 'hi': 'अपनी भाषा चुनें',
      'ar': 'اختر لغتك', 'sw': 'Chagua lugha yako', 'tl': 'Piliin ang iyong wika',
    },
    'welcome': {
      'en': 'Welcome', 'es': 'Bienvenido', 'fr': 'Bienvenue',
      'pt': 'Bem-vindo', 'ko': '환영합니다', 'zh': '欢迎', 'hi': 'स्वागत है',
      'ar': 'أهلاً وسهلاً', 'sw': 'Karibu', 'tl': 'Maligayang pagdating',
    },
    'findYourLanguage': {
      'en': 'Find your language', 'es': 'Encuentra tu idioma',
      'fr': 'Trouvez votre langue', 'pt': 'Encontre seu idioma',
      'ko': '언어 찾기', 'zh': '搜索语言', 'hi': 'अपनी भाषा ढूंढें',
      'ar': 'ابحث عن لغتك', 'sw': 'Tafuta lugha yako',
      'tl': 'Hanapin ang iyong wika',
    },
    // ── Search / results ─────────────────────────────────────────────────────
    'noResults': {
      'en': 'No results found', 'es': 'No se encontraron resultados',
      'fr': 'Aucun résultat', 'pt': 'Nenhum resultado',
      'ko': '결과 없음', 'zh': '无结果', 'hi': 'कोई परिणाम नहीं',
      'ar': 'لا نتائج', 'sw': 'Hakuna matokeo', 'tl': 'Walang nahanap',
    },
    'searchResults': {
      'en': 'Search Results', 'es': 'Resultados de búsqueda',
      'fr': 'Résultats de recherche', 'pt': 'Resultados da busca',
      'ko': '검색 결과', 'zh': '搜索结果', 'hi': 'खोज परिणाम',
      'ar': 'نتائج البحث', 'sw': 'Matokeo ya Utafutaji',
      'tl': 'Mga Resulta ng Paghahanap',
    },
    // ── Days ─────────────────────────────────────────────────────────────────
    'sunday': {
      'en': 'Sunday', 'es': 'Domingo', 'fr': 'Dimanche', 'pt': 'Domingo',
      'ko': '일요일', 'zh': '星期日', 'hi': 'रविवार', 'ar': 'الأحد',
      'sw': 'Jumapili', 'tl': 'Linggo',
    },
    'monday': {
      'en': 'Monday', 'es': 'Lunes', 'fr': 'Lundi', 'pt': 'Segunda',
      'ko': '월요일', 'zh': '星期一', 'hi': 'सोमवार', 'ar': 'الاثنين',
      'sw': 'Jumatatu', 'tl': 'Lunes',
    },
    'wednesday': {
      'en': 'Wednesday', 'es': 'Miércoles', 'fr': 'Mercredi', 'pt': 'Quarta',
      'ko': '수요일', 'zh': '星期三', 'hi': 'बुधवार', 'ar': 'الأربعاء',
      'sw': 'Jumatano', 'tl': 'Miyerkules',
    },
    'friday': {
      'en': 'Friday', 'es': 'Viernes', 'fr': 'Vendredi', 'pt': 'Sexta',
      'ko': '금요일', 'zh': '星期五', 'hi': 'शुक्रवार', 'ar': 'الجمعة',
      'sw': 'Ijumaa', 'tl': 'Biyernes',
    },
  };

  String _t(String key) {
    final code = locale.languageCode;
    return _translations[key]?[code] ??
        _translations[key]?['en'] ??
        key;
  }

  // ── Navigation ──────────────────────────────────────────────────────────
  String get home => _t('home');
  String get sermons => _t('sermons');
  String get community => _t('community');
  String get profile => _t('profile');
  String get treasury => _t('treasury');
  String get polls => _t('polls');
  String get bible => _t('bible');
  String get hub => _t('hub');
  String get more => _t('more');

  // ── Common actions ───────────────────────────────────────────────────────
  String get continueLabel => _t('continueLabel');
  String get back => _t('back');
  String get cancel => _t('cancel');
  String get save => _t('save');
  String get edit => _t('edit');
  String get confirm => _t('confirm');
  String get close => _t('close');
  String get share => _t('share');
  String get search => _t('search');
  String get done => _t('done');
  String get submit => _t('submit');
  String get loading => _t('loading');
  String get getStarted => _t('getStarted');
  String get signIn => _t('signIn');
  String get signUp => _t('signUp');
  String get invite => _t('invite');
  String get export => _t('export');
  String get register => _t('register');
  String get download => _t('download');

  // ── Status ───────────────────────────────────────────────────────────────
  String get verified => _t('verified');
  String get pending => _t('pending');
  String get active => _t('active');
  String get inactive => _t('inactive');
  String get closed => _t('closed');
  String get liveNow => _t('liveNow');

  // ── Church / community ───────────────────────────────────────────────────
  String get members => _t('members');
  String get events => _t('events');
  String get viewProfile => _t('viewProfile');
  String get joinChurch => _t('joinChurch');
  String get prayWith => _t('prayWith');
  String get about => _t('about');
  String get leaders => _t('leaders');
  String get founded => _t('founded');

  // ── Poll / voting ────────────────────────────────────────────────────────
  String get votes => _t('votes');
  String get vote => _t('vote');
  String get results => _t('results');
  String get leading => _t('leading');
  String get yourVote => _t('yourVote');
  String get totalVotes => _t('totalVotes');
  String get castYourVote => _t('castYourVote');
  String get shareResults => _t('shareResults');
  String get publishPoll => _t('publishPoll');

  // ── Treasury / finance ───────────────────────────────────────────────────
  String get income => _t('income');
  String get expenses => _t('expenses');
  String get balance => _t('balance');
  String get logTransaction => _t('logTransaction');
  String get amount => _t('amount');
  String get budget => _t('budget');
  String get transactions => _t('transactions');

  // ── Onboarding ───────────────────────────────────────────────────────────
  String get chooseLanguage => _t('chooseLanguage');
  String get welcome => _t('welcome');
  String get findYourLanguage => _t('findYourLanguage');

  // ── Search ───────────────────────────────────────────────────────────────
  String get noResults => _t('noResults');
  String get searchResults => _t('searchResults');

  // ── Days ─────────────────────────────────────────────────────────────────
  String get sunday => _t('sunday');
  String get monday => _t('monday');
  String get wednesday => _t('wednesday');
  String get friday => _t('friday');
}

// ---------------------------------------------------------------------------
// InheritedWidget that provides AppLocalizations down the tree
// ---------------------------------------------------------------------------
class AppLocalizationsScope extends InheritedWidget {
  final AppLocalizations localizations;

  const AppLocalizationsScope({
    super.key,
    required this.localizations,
    required super.child,
  });

  @override
  bool updateShouldNotify(AppLocalizationsScope old) =>
      localizations.locale != old.localizations.locale;
}

