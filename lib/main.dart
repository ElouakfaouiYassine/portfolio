import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'web_url_stub.dart' if (dart.library.html) 'web_url_web.dart' as web;
import 'package:cached_network_image/cached_network_image.dart';
import 'web_analytics_stub.dart' if (dart.library.html) 'web_analytics_web.dart'
    as analytics;
import 'dart:ui' show ImageFilter;
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

// ─── App ────────────────────────────────────────────────────────────────────

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

extension _MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) sync* {
    var i = 0;
    for (final e in this) {
      yield f(i++, e);
    }
  }
}

class _PortfolioAppState extends State<PortfolioApp> {
  ThemeMode _mode = ThemeMode.dark;

  void _toggleTheme() => setState(
      () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  void _changeLanguage(String lang) => setState(() => I18n.current = lang);

  TextTheme _headingTheme(TextTheme base) => base.copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
            textStyle: base.displayLarge, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.spaceGrotesk(
            textStyle: base.displayMedium, fontWeight: FontWeight.w800),
        displaySmall: GoogleFonts.spaceGrotesk(
            textStyle: base.displaySmall, fontWeight: FontWeight.w700),
        headlineLarge: GoogleFonts.spaceGrotesk(
            textStyle: base.headlineLarge, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.spaceGrotesk(
            textStyle: base.headlineMedium, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.spaceGrotesk(
            textStyle: base.headlineSmall, fontWeight: FontWeight.w800),
        titleLarge: GoogleFonts.spaceGrotesk(
            textStyle: base.titleLarge, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.spaceGrotesk(
            textStyle: base.titleMedium, fontWeight: FontWeight.w700),
        titleSmall: GoogleFonts.spaceGrotesk(
            textStyle: base.titleSmall, fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.ibmPlexSans(textStyle: base.bodyLarge),
        bodyMedium: GoogleFonts.ibmPlexSans(textStyle: base.bodyMedium),
        bodySmall: GoogleFonts.ibmPlexSans(textStyle: base.bodySmall),
        labelLarge: GoogleFonts.jetBrainsMono(
            textStyle: base.labelLarge, fontWeight: FontWeight.w700),
        labelMedium: GoogleFonts.jetBrainsMono(
            textStyle: base.labelMedium, fontWeight: FontWeight.w700),
      );

  @override
  Widget build(BuildContext context) {
    final baseLight =
        Typography.material2021(platform: TargetPlatform.android).black.apply(
              bodyColor: const Color(0xFF1B1F2A),
              displayColor: const Color(0xFF0F1230),
            );
    final baseDark = Typography.whiteCupertino;

    return MaterialApp(
      title: 'Elouakfaoui Yassine',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      locale: I18n.locale,
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
      builder: (context, child) => Directionality(
        textDirection:
            I18n.current == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: child!,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (device, supported) => supported.firstWhere(
          (l) => l.languageCode == I18n.current,
          orElse: () => const Locale('en')),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF007A5A),
          secondary: Color(0xFF0369A1),
          surface: Color(0xFFF7FAFC),
          onSurface: Color(0xFF102522),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8FA),
        textTheme: I18n.current == 'ar'
            ? GoogleFonts.cairoTextTheme(baseLight)
            : _headingTheme(baseLight),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DS.radius)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DS.pill)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DS.pill)),
            side: const BorderSide(color: Color(0x33102522)),
          ),
        ),
        chipTheme: ChipThemeData(
          shape:
              StadiumBorder(side: const BorderSide(color: Color(0x2200D084))),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          backgroundColor: const Color(0x0F00D084),
          selectedColor: const Color(0x2200D084),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: DS.signal,
          secondary: DS.cyan,
          tertiary: DS.amber,
          surface: DS.surface,
          onSurface: Color(0xFFE7FFF6),
        ),
        scaffoldBackgroundColor: DS.background,
        cardColor: DS.surface,
        textTheme: I18n.current == 'ar'
            ? GoogleFonts.cairoTextTheme(baseDark)
            : _headingTheme(baseDark),
        cardTheme: CardTheme(
          elevation: 0,
          color: const Color(0x66121623),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DS.radius)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DS.pill)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DS.pill)),
            side: const BorderSide(color: Color(0x33FFFFFF)),
            foregroundColor: Colors.white,
          ),
        ),
        chipTheme: ChipThemeData(
          shape: const StadiumBorder(side: BorderSide(color: DS.divider)),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0x1AFFFFFF),
          selectedColor: const Color(0x33FFFFFF),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0x1416212B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: DS.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: DS.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: DS.signal, width: 1.4),
          ),
        ),
      ),
      home: PortfolioHome(
        onToggleTheme: _toggleTheme,
        isDark: _mode == ThemeMode.dark,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

// ─── Data ───────────────────────────────────────────────────────────────────

class ProfileConfig {
  static const name = 'Elouakfaoui Yassine';
  static const title = 'Junior Cybersecurity Analyst | Mobile Developer';
  static const tagline =
      'Top 2% on TryHackMe · CompTIA Security+ Certified · CTF Player';
  static const location = 'Meknes, Morocco';
  static const email = 'elouakfaouiyassine@gmail.com';
  static const phone = '+212 777539454';
  static const github = 'https://github.com/ElouakfaouiYassine';
  static const linkedin = 'https://www.linkedin.com/in/yassine-elouakfaoui/';
  static const resumeUrl = 'assets/resume.pdf';
  static const contactEndpoint = 'https://formspree.io/f/mpwjborw';

  static const mobileSkills = [
    _Skill('Flutter'),
    _Skill('Kotlin'),
    _Skill(
      'Dart',
    ),
    _Skill(
      'Swift',
    ),
    _Skill(
      'Firebase',
    ),
    _Skill(
      'SQLite / MongoDB',
    ),
    _Skill(
      'Design Patterns',
    ),
  ];
  static const cybersecuritySkills = [
    _Skill(
      'OS (Linux / Windows)',
    ),
    _Skill(
      'Networking',
    ),
    _Skill(
      'Cryptography',
    ),
    _Skill(
      'EDR',
    ),
    _Skill(
      'XDR',
    ),
    _Skill(
      'SOAR',
    ),
    _Skill(
      'SIEM (Splunk / ELK)',
    ),
    _Skill(
      'IDS / IPS',
    ),
    _Skill(
      'Incident Response',
    ),
    _Skill(
      'Threat Hunting',
    ),
    _Skill(
      'Metasploit',
    ),
    _Skill(
      'OSINT',
    ),
    _Skill(
      'MITRE ATT&CK',
    ),
    _Skill(
      'Pyramid Of Pain',
    ),
    _Skill(
      'Python Scripting',
    ),
  ];
  static const toolSkills = [
    _Skill(
      'Git / GitHub',
    ),
    _Skill(
      'Nmap',
    ),
    _Skill(
      'Wireshark',
    ),
    _Skill(
      'Burp Suite',
    ),
    _Skill(
      'FlareVM',
    ),
    _Skill(
      'REMnux',
    ),
    _Skill(
      'CAPA',
    ),
    _Skill(
      'Snort',
    ),
    _Skill(
      'YARA / Sigma',
    ),
    _Skill(
      'Postman',
    ),
  ];

  static final projects = <Project>[
    Project(
      title: 'BlueTeam NetFlow Hunt',
      kind: 'Security (Threat Hunting)',
      summary:
          'Python + Zeek pipeline to flag C2 beacons and rare destinations.',
      tags: ['Python', 'Zeek', 'NetFlow'],
      github:
          'https://github.com/ElouakfaouiYassine/Sites-Sweeper?tab=readme-ov-file',
      demo: '',
      imageUrl:
          'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=2070&auto=format&fit=crop',
      category: 'cybersecurity',
      detail:
          'Threat hunting pipeline using NetFlow/Zeek to surface beaconing & rare destinations.',
      images: [
        'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=1200&auto=format',
      ],
      highlights: [
        'Rolling z-scores & rarity analysis.',
        'Python ETL into dashboards.',
      ],
      id: 'blueteam',
    ),
    Project(
      title: 'E‑commerce App',
      kind: 'Mobile (Kotlin)',
      summary:
          'A full-stack e-commerce mobile app built using Kotlin (Android), PHP (backend).',
      tags: [
        'Kotlin',
        'PHP',
        'Stripe',
        'MVVM',
        'Clean Architecture',
        'SQLite',
        'MongoDB'
      ],
      github: 'https://github.com/ElouakfaouiYassine/E-commerce-app',
      demo: '',
      imageUrl:
          'https://raw.githubusercontent.com/ElouakfaouiYassine/E-commerce-app/master/screenshots/Application%20sTORE.jpg',
      category: 'mobile',
      detail:
          'A full-stack e-commerce mobile app built using Kotlin (Android), PHP (backend), with hybrid database support using SQLite (local) and MongoDB (remote). The app offers complete user experience including authentication, product browsing, cart, admin management, and dark mode.',
      images: [
        'https://raw.githubusercontent.com/ElouakfaouiYassine/E-commerce-app/master/screenshots/photo_32_2025-03-26_23-52-47.jpg',
        'assets/images/3.jpg',
        'assets/images/4.jpg',
        'assets/images/5.jpg',
        'assets/images/6.jpg',
        'assets/images/7.jpg',
        'assets/images/8.jpg',
        'assets/images/9.jpg',
        'assets/images/10.jpg',
      ],
      highlights: [
        'Stripe payments with 3-D Secure.',
        'Clean Architecture + repository pattern.',
      ],
      id: 'ecommerce',
    ),
    Project(
      title: 'StopFire App',
      kind: 'Mobile (Kotlin)',
      summary:
          'Created a real-time alert app that detects charging-related fire risks.',
      tags: ['kotlin', 'MVVM', 'Notification'],
      github: 'https://github.com/ElouakfaouiYassine/Protect-Your-House-App',
      demo: '',
      imageUrl:
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Feature%20graphic.png',
      category: 'mobile',
      detail:
          'Protect Your House App is a mobile application built with Kotlin to strengthen home safety against fire risks caused by charging devices.',
      images: [
        'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/2.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Screenshot_20250704_224606.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Screenshot_20250708_235434.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Screenshot_20250709_004703.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/headr1.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/headr2.png',
      ],
      highlights: [
        'Built with Kotlin and MVVM architecture.',
        'Real-time monitoring of charging devices.',
        'Instant notifications and alerts.',
        'Lightweight UI optimized for performance.',
      ],
      id: 'stopfire',
    ),
    Project(
      title: 'Chat App',
      kind: 'Mobile',
      summary:
          'Chat with offline cache, message reactions, and push notifications.',
      tags: ['Kotlin', 'Spring Boot', 'MongoDB', 'PGP', 'WebSocket'],
      github:
          'https://github.com/ElouakfaouiYassine/Sites-Sweeper?tab=readme-ov-file',
      demo: '',
      imageUrl:
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/1.jpg',
      category: 'mobile',
      detail:
          'Realtime chat app with E2EE, offline cache, typing indicators and push notifications.',
      images: [
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/1.jpg',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/2.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/3.jpg',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/4.jpg',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/5.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/6.jpg',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/7.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/8.png',
        'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/9.jpg',
      ],
      highlights: [
        'End-to-end encryption with key rotation.',
        'Message queue + optimistic UI.',
      ],
      id: 'chatpulse',
    ),
  ];

  static final educationList = <Education>[
    Education(
      degree: "Bachelor's Degree in Computer Security and Networks",
      institution:
          "EST – École Supérieure de Technologie Guelmim, Ibn Zohr University",
      years: "2024 – 2025",
    ),
    Education(
      degree: "Diploma in Mobile Application Development",
      institution: "OFPPT – Bab Tizimi Meknès",
      years: "2022 – 2024",
    ),
  ];

  static final posts = <BlogPost>[
    BlogPost(
      title: "MACC 2026 Write-Up OpenClaw",
      summary: "Owning an ML Pipeline From an Open MLflow to a Pickle RCE",
      date: "May 2026",
      url:
          "https://medium.com/@elouakfaouiyassine/macc-2026-write-up-openclaw-owning-an-ml-pipeline-from-an-open-mlflow-to-a-pickle-rce-727ede9dedd1",
    ),
    BlogPost(
      title: "MACC 2026 Write-Up Lab Teletype",
      summary: "When a Forgotten Protocol Hands You Root",
      date: "May 2026",
      url:
          "https://medium.com/@elouakfaouiyassine/macc-2026-write-up-1-teletype-when-a-forgotten-protocol-hands-you-root-32b5b96fd261",
    ),
    BlogPost(
      title: "MACC 2026 Write-Up Compete",
      summary: "Chaining Four Bugs Into Full Server Compromise",
      date: "May 2026",
      url:
          "https://medium.com/@elouakfaouiyassine/macc-2026-write-up-compete-chaining-four-bugs-into-full-server-compromise-de8a130745e6",
    ),
    BlogPost(
      title: "MACC 2026 Write-Up Nebula",
      summary: "Breaking an AI Assistant by Talking to the Server Behind It",
      date: "May 2026",
      url:
          "https://medium.com/@elouakfaouiyassine/macc-2026-write-up-nebula-breaking-an-ai-assistant-by-talking-to-the-server-behind-it-9098c1e01693",
    ),
  ];

  static final experience = <ExperienceItem>[
    ExperienceItem(
      role: 'Mobile Developer',
      org: 'E-ContactMessage',
      period: '5 Months - Internship',
      bullets: [
        'Built using Android SDK: Activities, RecyclerViews, SQLite, etc.',
        'Integrated SQLite for offline storage and remote DB sync.',
        'Applied user feedback to improve UX and navigation.',
      ],
    ),
    ExperienceItem(
      role: 'Back-End Developer',
      org: 'E-ContactMessage',
      period: '2 Months - Internship',
      bullets: [
        'Developed REST APIs using PHP and MySQL',
        'Designed scalable database schemas',
        'Supported improvements in system security and performance',
      ],
    ),
  ];

  static final certs = <Certification>[
    Certification('Security+', 'Comptia', '2026'),
    Certification('Multi-Cloud Blue Team Analyst', 'CyberWarFare Labs', '2026'),
    Certification('Cyber Security Analyst (C3SA)', 'CyberWarFare Labs', '2025'),
    Certification('Blue Team Fundamentals (BTF)', 'CyberWarFare Labs', '2025'),
    Certification('Python Programming', 'Cisco', '2023'),
    Certification('Office Word', 'Microsoft', '2022'),
  ];
}

class _Skill {
  final String name;
  const _Skill(this.name);
}

class Project {
  final String title,
      kind,
      summary,
      github,
      demo,
      imageUrl,
      category,
      detail,
      id;
  final List<String> tags, images, highlights;
  const Project({
    required this.title,
    required this.kind,
    required this.summary,
    required this.tags,
    required this.github,
    required this.demo,
    required this.imageUrl,
    required this.category,
    required this.detail,
    this.images = const [],
    this.highlights = const [],
    required this.id,
  });
}

class ExperienceItem {
  final String role, org, period;
  final List<String> bullets;
  const ExperienceItem(
      {required this.role,
      required this.org,
      required this.period,
      required this.bullets});
}

class Certification {
  final String name, issuer, year;
  const Certification(this.name, this.issuer, this.year);
}

// ─── Home ───────────────────────────────────────────────────────────────────

class PortfolioHome extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  final ValueChanged<String> onLanguageChanged;
  const PortfolioHome(
      {super.key,
      required this.onToggleTheme,
      required this.isDark,
      required this.onLanguageChanged});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scroll = ScrollController();
  final _homeKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _certsKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _blogKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
        alignment: 0.05);
  }

  late final List<MapEntry<String, GlobalKey>> _sections = [
    MapEntry('About', _aboutKey),
    MapEntry('Skills', _skillsKey),
    MapEntry('Projects', _projectsKey),
    MapEntry('Experience', _experienceKey),
    MapEntry('Education', _educationKey),
    MapEntry('Certs', _certsKey),
    MapEntry('Blog', _blogKey),
    MapEntry('Contact', _contactKey),
  ];

  int _active = 0;

  void _handleScrollHighlight() {
    const focusY = 120.0;
    double best = double.infinity;
    int bestIdx = _active;
    for (int i = 0; i < _sections.length; i++) {
      final ctx = _sections[i].value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box is! RenderBox) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      final score = (dy - focusY).abs();
      if (score < best) {
        best = score;
        bestIdx = i;
      }
    }
    if (bestIdx != _active && mounted) setState(() => _active = bestIdx);
  }

  @override
  void initState() {
    super.initState();
    final hash = web.getHash();
    if (hash.startsWith('project=')) {
      final id = hash.split('=').last;
      final match = ProfileConfig.projects.firstWhere((p) => p.id == id,
          orElse: () => ProfileConfig.projects.first);
      WidgetsBinding.instance.addPostFrameCallback((_) => _openProject(match));
    }
    _scroll.addListener(_handleScrollHighlight);
  }

  @override
  void dispose() {
    _scroll.removeListener(_handleScrollHighlight);
    _scroll.dispose();
    super.dispose();
  }

  void _openProject(Project p) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: _ProjectDetails(project: p),
        ),
      ),
    );
  }

  void _downloadResume() async {
    analytics.trackEvent('Resume Click');
    final url = ProfileConfig.resumeUrl.isEmpty
        ? '/assets/resume.pdf'
        : ProfileConfig.resumeUrl;
    await _launch(url);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 980;

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.digit1): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit2): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit3): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit4): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit5): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit6): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit7): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit8): const ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (intent) {
            final label = HardwareKeyboard.instance.logicalKeysPressed
                .map((k) => k.keyLabel)
                .firstWhere((l) => RegExp(r'^\d$').hasMatch(l),
                    orElse: () => '');
            if (label.isEmpty) return null;
            final idx = int.parse(label) - 1;
            if (idx >= 0 && idx < _sections.length)
              _scrollTo(_sections[idx].value);
            return null;
          }),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              titleSpacing: 16,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/j.png',
                      width: 34,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ProfileConfig.name,
                          style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: -.2)),
                      Text('Cybersecurity Portfolio',
                          style: GoogleFonts.jetBrainsMono(
                              color: DS.signal,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              flexibleSpace: isWide
                  ? ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: (widget.isDark
                                    ? DS.background
                                    : const Color(0xFFF7FAFC))
                                .withOpacity(0.82),
                            border: const Border(
                                bottom:
                                    BorderSide(color: DS.divider, width: 1)),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? DS.background.withOpacity(.94)
                            : Colors.white.withOpacity(0.95),
                        border: const Border(
                            bottom: BorderSide(color: DS.divider, width: 1)),
                      ),
                    ),
              actions: isWide
                  ? [
                      ..._sections.mapIndexed((i, entry) => _navItemButton(
                            label: entry.key,
                            onTap: () => _scrollTo(entry.value),
                            active: _active == i,
                          )),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: FilledButton.icon(
                          onPressed: _downloadResume,
                          icon: const Icon(Icons.file_download, size: 18),
                          label: const Text('Resume'),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Toggle theme',
                        onPressed: widget.onToggleTheme,
                        icon: Icon(widget.isDark
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_round),
                      ),
                      _langButton(),
                    ]
                  : [
                      IconButton(
                        tooltip: 'Toggle theme',
                        onPressed: widget.onToggleTheme,
                        icon: Icon(widget.isDark
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_round),
                      ),
                      _langButton(),
                    ],
            ),
            floatingActionButton: AnimatedBuilder(
              animation: _scroll,
              builder: (_, __) {
                final show = _scroll.hasClients && _scroll.offset > 600;
                return AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: show ? Offset.zero : const Offset(0, 2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: show ? 1 : 0,
                    child: FloatingActionButton.small(
                      backgroundColor: DS.signal,
                      foregroundColor: DS.background,
                      onPressed: () => _scroll.animateTo(0,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeOut),
                      child: const Icon(Icons.arrow_upward),
                    ),
                  ),
                );
              },
            ),
            drawer: isWide
                ? null
                : Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // ── Drawer header ──────────────────────────────────
                        DrawerHeader(
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [DS.surfaceAlt, DS.background],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: DS.signal.withOpacity(.12),
                                  backgroundImage: const AssetImage(
                                      'assets/images/logo.png'),
                                  onBackgroundImageError: (_, __) {},
                                ),
                                const SizedBox(height: 10),
                                const Text(ProfileConfig.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                const Text(ProfileConfig.title,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                        // ── Nav items ──────────────────────────────────────
                        for (final entry in _sections)
                          ListTile(
                            title: Text(entry.key),
                            onTap: () {
                              Navigator.of(context).maybePop();
                              Future.delayed(const Duration(milliseconds: 180),
                                  () => _scrollTo(entry.value));
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: const Text('Resume'),
                          onTap: _downloadResume,
                        ),
                        const Divider(),
                        // ── Language ───────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Text('Language',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 1)),
                        ),
                        _drawerLangItem('English', 'en'),
                        _drawerLangItem('Français', 'fr'),
                        _drawerLangItem('العربية', 'ar'),
                      ],
                    ),
                  ),
            body: Stack(
              children: [
                ParallaxOrbs(controller: _scroll, isDark: widget.isDark),
                SafeArea(
                  child: Scrollbar(
                    controller: _scroll,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scroll,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Section(
                            key: _homeKey,
                            child: HeroSection(
                                onHireMe: () => _scrollTo(_contactKey)),
                            showDivider: true,
                          ),
                          Section(
                              key: _aboutKey,
                              child: const AboutSection(),
                              altBackground: true),
                          Section(
                              key: _skillsKey, child: const SkillsSection()),
                          Section(
                              key: _projectsKey,
                              child: const ProjectsSection(),
                              altBackground: true),
                          Section(
                              key: _experienceKey,
                              child: const ExperienceSection()),
                          Section(
                            key: _educationKey,
                            child: EducationSection(
                                educationList: ProfileConfig.educationList),
                            altBackground: true,
                          ),
                          Section(key: _certsKey, child: const CertsSection()),
                          Section(key: _blogKey, child: const BlogSection()),
                          Section(
                              key: _contactKey,
                              child: const ContactSection(),
                              altBackground: true),
                          const Footer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _langButton() => PopupMenuButton<String>(
        tooltip: 'Language',
        icon: const Icon(Icons.language),
        onSelected:
            widget.onLanguageChanged, // ← fix: goes to _PortfolioAppState
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'en', child: Text('English')),
          PopupMenuItem(value: 'fr', child: Text('Français')),
          PopupMenuItem(value: 'ar', child: Text('العربية')),
        ],
      );

  Widget _drawerLangItem(String label, String code) {
    final active = I18n.current == code;
    return ListTile(
      dense: true,
      leading: active
          ? Icon(Icons.check_circle,
              color: Theme.of(context).colorScheme.primary, size: 18)
          : const SizedBox(width: 18),
      title: Text(label),
      onTap: () {
        widget.onLanguageChanged(
            code); // ← fix: rebuilds MaterialApp locale + Directionality
        Navigator.pop(context);
      },
    );
  }

  Widget _navItemButton(
      {required String label,
      required VoidCallback onTap,
      required bool active}) {
    final theme = Theme.of(context);
    final fg =
        active ? DS.signal : theme.textTheme.labelLarge?.color ?? Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor:
              active ? DS.signal.withOpacity(0.10) : Colors.transparent,
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13)),
      ),
    );
  }
}

// ─── Section wrapper ────────────────────────────────────────────────────────

class Section extends StatelessWidget {
  final Widget child;
  final bool showDivider;
  final bool altBackground;

  const Section({
    super.key,
    required this.child,
    this.showDivider = true,
    this.altBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 600 ? 14.0 : 20.0;
    final vertical = width < 700 ? 24.0 : 34.0;
    final bg = altBackground
        ? isDark
            ? DS.signal.withOpacity(0.025)
            : DS.signal.withOpacity(0.055)
        : Colors.transparent;

    final sectionContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          if (showDivider) ...[
            const SizedBox(height: 12),
            const _GradientDivider(),
          ],
        ],
      ),
    );

    return Container(
      color: bg,
      width: double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: sectionContent,
        ),
      ),
    );
  }
}

class _GradientDivider extends StatelessWidget {
  const _GradientDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            DS.signal.withOpacity(.45),
            DS.danger.withOpacity(.34),
            DS.cyan.withOpacity(.22),
            Colors.transparent
          ],
          stops: [0.08, 0.42, 0.58, 0.72, 0.92],
        ),
      ),
    );
  }
}

// ─── Section title ──────────────────────────────────────────────────────────

class SectionTitle extends StatelessWidget {
  final String text;
  final String? kicker;
  const SectionTitle(this.text, {super.key, this.kicker});

  @override
  Widget build(BuildContext context) {
    final primary = DS.signal;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kicker != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(DS.pill),
              border: Border.all(color: primary.withOpacity(.28)),
            ),
            child: Text('[ ${kicker!.toUpperCase()} ]',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    letterSpacing: 1.5)),
          ),
          const SizedBox(height: 8),
        ],
        Text(text,
            style: GoogleFonts.spaceGrotesk(
                color: onSurface,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -.8)),
        const SizedBox(height: 9),
        Row(
          children: [
            Container(
              height: 2,
              width: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(colors: [
                  primary,
                  DS.danger.withOpacity(.8),
                  DS.cyan,
                  primary.withOpacity(0)
                ]),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: DS.danger,
                boxShadow: [
                  BoxShadow(color: DS.danger.withOpacity(.55), blurRadius: 10)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Hero ───────────────────────────────────────────────────────────────────

class HeroSection extends StatelessWidget {
  final VoidCallback onHireMe;
  const HeroSection({super.key, required this.onHireMe});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final desktop = c.maxWidth >= 960;
      final tablet = c.maxWidth >= 640 && !desktop;
      final heroText = _HeroCopy(isWide: desktop, onHireMe: onHireMe);
      final visual = SizedBox(
        height: desktop
            ? 520
            : tablet
                ? 360
                : 300,
        child: const _AuroraVisual(),
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (desktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 56, child: heroText),
                  const SizedBox(width: 18),
                  Expanded(flex: 44, child: visual),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heroText,
                SizedBox(height: tablet ? 16 : 14),
                visual,
              ],
            ),
          const SizedBox(height: 16),
          const _StatsStrip(),
        ],
      );
    });
  }
}

class _HeroCopy extends StatelessWidget {
  final bool isWide;
  final VoidCallback onHireMe;
  const _HeroCopy({required this.isWide, required this.onHireMe});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.white.withOpacity(.74);
    final headlineSize = isWide ? 54.0 : 36.0;

    return Container(
      padding: EdgeInsets.all(isWide ? 24 : 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: DS.signal.withOpacity(.26)),
        boxShadow: [
          BoxShadow(
            color: DS.signal.withOpacity(.12),
            blurRadius: 34,
            spreadRadius: -16,
            offset: const Offset(0, 18),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DS.surfaceAlt.withOpacity(.88),
            DS.surface.withOpacity(.52),
            DS.danger.withOpacity(.035),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          const _StatusBadge(),
          const SizedBox(height: 16),
          Text(
            'SOC dashboard for code, traffic, and threats.',
            textAlign: isWide ? TextAlign.start : TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: headlineSize,
              height: .96,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.8,
            ),
          ),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [DS.signal, DS.cyan, DS.danger],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              ProfileConfig.name,
              textAlign: isWide ? TextAlign.start : TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: isWide ? 29 : 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -.8,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _TypewriterText(
            texts: const [
              'whoami: junior_security_analyst',
              'nmap scan initialized',
              'analyzing traffic...',
              'access granted: bleu team mindset',
            ],
            style: GoogleFonts.jetBrainsMono(
              fontSize: isWide ? 15 : 12.5,
              fontWeight: FontWeight.w800,
              color: DS.signal,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'I triage alerts, hunt suspicious patterns, and translate developer experience into sharper application-security decisions.',
            textAlign: isWide ? TextAlign.start : TextAlign.center,
            style: TextStyle(color: muted, height: 1.6, fontSize: 15),
          ),
          const SizedBox(height: 14),
          const _MiniTerminal(),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onHireMe,
                icon: const Icon(Icons.radar, size: 18),
                label: const Text('Initialize Contact'),
                style: FilledButton.styleFrom(
                  backgroundColor: DS.signal,
                  foregroundColor: DS.background,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shadowColor: DS.signal.withOpacity(.35),
                  elevation: 4,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _launch(ProfileConfig.github),
                icon: const Icon(Icons.terminal, size: 18),
                label: const Text('Open Repository'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DS.cyan,
                  side: BorderSide(color: DS.cyan.withOpacity(.42)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 520.ms).slideY(begin: .03);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: DS.danger.withOpacity(.075),
        border: Border.all(color: DS.danger.withOpacity(.32)),
        borderRadius: BorderRadius.circular(DS.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: DS.danger,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: DS.danger.withOpacity(.75), blurRadius: 12)
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fade(begin: .38, end: 1, duration: 720.ms),
          const SizedBox(width: 8),
          Text(
            'ACCESS GRANTED: AVAILABLE',
            style: GoogleFonts.jetBrainsMono(
              color: DS.danger,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTerminal extends StatelessWidget {
  const _MiniTerminal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DS.signal.withOpacity(.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TerminalLine(
              command: 'whoami', output: 'Security+ / THM top 2% / SOC L1'),
          SizedBox(height: 7),
          _TerminalLine(
              command: 'nmap -sV target',
              output: 'mobile apps + backend APIs discovered'),
          SizedBox(height: 7),
          _TerminalLine(
              command: 'tail -f alerts.log',
              output: 'threat detected -> investigate',
              critical: true),
        ],
      ),
    );
  }
}

class _TerminalLine extends StatelessWidget {
  final String command;
  final String output;
  final bool critical;
  const _TerminalLine(
      {required this.command, required this.output, this.critical = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.jetBrainsMono(
          color: Colors.white.withOpacity(.74),
          fontSize: 12,
          height: 1.45,
        ),
        children: [
          const TextSpan(
              text: r'$ ',
              style: TextStyle(color: DS.signal, fontWeight: FontWeight.w800)),
          TextSpan(
              text: command,
              style:
                  const TextStyle(color: DS.cyan, fontWeight: FontWeight.w700)),
          TextSpan(
              text: '  ->  $output',
              style: TextStyle(
                  color: critical ? DS.danger : null,
                  fontWeight: critical ? FontWeight.w800 : FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── Typewriter ──────────────────────────────────────────────────────────────

class _TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  const _TypewriterText({required this.texts, this.style});
  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  int _textIndex = 0;
  int _charCount = 0;
  bool _deleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  void _schedule() {
    Duration delay;
    if (!_deleting && _charCount >= widget.texts[_textIndex].length) {
      delay = const Duration(milliseconds: 1800);
    } else if (_deleting) {
      delay = const Duration(milliseconds: 38);
    } else {
      delay = const Duration(milliseconds: 75);
    }
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final current = widget.texts[_textIndex];
    if (!_deleting) {
      if (_charCount < current.length) {
        setState(() => _charCount++);
        _schedule();
      } else {
        _deleting = true;
        _schedule();
      }
    } else {
      if (_charCount > 0) {
        setState(() => _charCount--);
        _schedule();
      } else {
        _deleting = false;
        _textIndex = (_textIndex + 1) % widget.texts.length;
        _schedule();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final full = widget.texts[_textIndex];
    final shown = full.substring(0, _charCount.clamp(0, full.length));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(shown, style: widget.style),
        AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 2,
            height: (widget.style?.fontSize ?? 16) + 2,
            decoration: BoxDecoration(
              color:
                  widget.style?.color ?? Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fade(duration: 500.ms),
        ),
      ],
    );
  }
}

// ─── Stats strip ─────────────────────────────────────────────────────────────

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.flag_outlined, '175+', 'THM rooms', DS.signal),
      (Icons.workspace_premium_outlined, 'Security+', 'Certified', DS.signal),
      (Icons.radar_outlined, 'SOC L1', 'Path complete', DS.cyan),
      (Icons.warning_amber_outlined, 'CTF Player', '2024-present', DS.danger),
    ];

    return LayoutBuilder(builder: (_, c) {
      final columns = c.maxWidth >= 820
          ? 4
          : c.maxWidth >= 460
              ? 2
              : 1;
      final cardWidth = (c.maxWidth - ((columns - 1) * 10)) / columns;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: items.map((item) {
          final accent = item.$4;
          return SizedBox(
            width: cardWidth,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(.24)),
                boxShadow: accent == DS.danger ? DS.redGlow() : null,
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(.10),
                    DS.surface.withOpacity(.20),
                    Colors.transparent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(item.$1, color: accent, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$2,
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: accent)),
                        const SizedBox(height: 1),
                        Text(item.$3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.62))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

// ─── Aurora visual ──────────────────────────────────────────────────────────

class _AuroraVisual extends StatefulWidget {
  const _AuroraVisual();
  @override
  State<_AuroraVisual> createState() => _AuroraVisualState();
}

class _AuroraVisualState extends State<_AuroraVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 430;
      final height =
          constraints.maxHeight.isFinite ? constraints.maxHeight : 360;
      return AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final t = _c.value;
          final scanTop =
              48.0 + t * (height - 74).clamp(120.0, 520.0).toDouble();
          return ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: DS.signal.withOpacity(.30)),
                boxShadow: [
                  BoxShadow(
                    color: DS.signal.withOpacity(.14),
                    blurRadius: 34,
                    spreadRadius: -14,
                    offset: const Offset(0, 18),
                  ),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF020706), Color(0xFF08231B)],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: _GridPainter(opacity: .07)),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(-.15 + t * .28, -.58),
                          radius: .85,
                          colors: [
                            DS.signal.withOpacity(.18),
                            DS.danger.withOpacity(.055),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(compact ? 12 : 16),
                    child: Column(
                      children: [
                        _DashboardHeader(
                          dotBuilder: _windowDot,
                          threatPulse: t,
                        ),
                        SizedBox(height: compact ? 10 : 12),
                        Expanded(
                          child: compact
                              ? Column(
                                  children: [
                                    Expanded(child: _RadarPanel(progress: t)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: const [
                                        Expanded(
                                          child: _ThreatTile(
                                            icon: Icons.warning_amber_outlined,
                                            label: 'ALERT',
                                            value: 'credential probe',
                                            color: DS.danger,
                                            pulse: true,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: _ThreatTile(
                                            icon: Icons.hub_outlined,
                                            label: 'SIEM',
                                            value: 'correlating',
                                            color: DS.signal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: _RadarPanel(progress: t),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: const [
                                          Expanded(
                                            child: _ThreatTile(
                                              icon:
                                                  Icons.warning_amber_outlined,
                                              label: 'THREAT DETECTED',
                                              value: 'credential probe',
                                              color: DS.danger,
                                              pulse: true,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: _ThreatTile(
                                              icon: Icons.hub_outlined,
                                              label: 'SIEM PIPELINE',
                                              value: 'events correlated',
                                              color: DS.signal,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: _ThreatTile(
                                              icon: Icons.travel_explore,
                                              label: 'OSINT TRACE',
                                              value: 'source enriched',
                                              color: DS.cyan,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        SizedBox(height: compact ? 10 : 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.36),
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: DS.signal.withOpacity(.14)),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                  child: _ConsoleMetric(
                                      label: 'scan',
                                      value: 'running',
                                      color: DS.signal)),
                              SizedBox(width: 8),
                              Expanded(
                                  child: _ConsoleMetric(
                                      label: 'risk',
                                      value: 'medium',
                                      color: DS.danger)),
                              SizedBox(width: 8),
                              Expanded(
                                  child: _ConsoleMetric(
                                      label: 'access',
                                      value: 'granted',
                                      color: DS.cyan)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: scanTop,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: DS.signal.withOpacity(.35),
                        boxShadow: [
                          BoxShadow(
                              color: DS.signal.withOpacity(.45), blurRadius: 12)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _windowDot(Color color) => Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _DashboardHeader extends StatelessWidget {
  final Widget Function(Color color) dotBuilder;
  final double threatPulse;
  const _DashboardHeader({required this.dotBuilder, required this.threatPulse});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        dotBuilder(DS.danger),
        const SizedBox(width: 6),
        dotBuilder(DS.amber),
        const SizedBox(width: 6),
        dotBuilder(DS.signal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'root@soc:~/live-monitor',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.jetBrainsMono(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w800),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: DS.danger.withOpacity(.08 + threatPulse * .045),
            borderRadius: BorderRadius.circular(DS.pill),
            border: Border.all(color: DS.danger.withOpacity(.34)),
          ),
          child: Text(
            'LIVE',
            style: GoogleFonts.jetBrainsMono(
                color: DS.danger, fontSize: 9, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class _RadarPanel extends StatelessWidget {
  final double progress;
  const _RadarPanel({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DS.signal.withOpacity(.18)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _RadarPainter(progress: progress)),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: DS.background.withOpacity(.72),
                borderRadius: BorderRadius.circular(DS.pill),
                border: Border.all(color: DS.signal.withOpacity(.24)),
              ),
              child: Text(
                'analyzing traffic...',
                style: GoogleFonts.jetBrainsMono(
                    color: DS.signal,
                    fontSize: 10,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool pulse;
  const _ThreatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.pulse = false,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(.075),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.24)),
        boxShadow: pulse ? DS.redGlow() : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.jetBrainsMono(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .4)),
                const SizedBox(height: 4),
                Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(.76),
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );

    if (!pulse) return tile;
    return tile
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: .82, end: 1, duration: 1200.ms)
        .scale(
            begin: const Offset(.985, .985),
            end: const Offset(1, 1),
            duration: 1200.ms);
  }
}

class _ConsoleMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ConsoleMetric(
      {required this.label, required this.value, this.color = DS.signal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> $label',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.jetBrainsMono(
                color: DS.cyan, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(value,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.jetBrainsMono(
                color: color, fontSize: 11, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  const _RadarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * .42;
    final ring = Paint()
      ..color = DS.signal.withOpacity(.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final sweep = Paint()
      ..color = DS.signal.withOpacity(.52)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final redPing = Paint()
      ..color = DS.danger.withOpacity(.9)
      ..style = PaintingStyle.fill;

    for (final scale in const [.28, .52, .76, 1.0]) {
      canvas.drawCircle(center, radius * scale, ring);
    }
    canvas.drawLine(Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy), ring);
    canvas.drawLine(Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius), ring);

    final angle = progress * math.pi * 2;
    final sweepEnd = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
    final sweepPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(sweepEnd.dx, sweepEnd.dy);
    canvas.drawPath(sweepPath, sweep);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle - .42,
        .42, true, Paint()..color = DS.signal.withOpacity(.08));

    final redNode = Offset(
      center.dx + math.cos(angle + 1.15) * radius * .62,
      center.dy + math.sin(angle + 1.15) * radius * .62,
    );
    canvas.drawCircle(redNode, 4.5, redPing);
    canvas.drawCircle(redNode, 10, Paint()..color = DS.danger.withOpacity(.10));
    canvas.drawCircle(Offset(center.dx - radius * .42, center.dy + radius * .3),
        3.5, Paint()..color = DS.cyan);
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.progress != progress;
}

class _GridPainter extends CustomPainter {
  final double opacity;
  const _GridPainter({required this.opacity});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = DS.signal.withOpacity(opacity)
      ..strokeWidth = .5;
    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    final accent = Paint()
      ..color = DS.cyan.withOpacity(opacity * 1.2)
      ..strokeWidth = 1;
    canvas.drawLine(
        const Offset(0, 0), Offset(size.width, size.height), accent);
    final breach = Paint()
      ..color = DS.danger.withOpacity(opacity * .9)
      ..strokeWidth = .8;
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width * .64, size.height), breach);
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.opacity != opacity;
}

// ─── About ───────────────────────────────────────────────────────────────────

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(.72);

    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth > 840;
      final narrative = _CyberPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('whoami: security-analyst',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(
              "Junior cybersecurity analyst pursuing a Master's in AI & Cybersecurity. My background started in mobile engineering, where I built Android, Kotlin, Flutter, backend, and database-driven systems before shifting into the work that kept triggering my curiosity: traffic patterns, attacker behavior, weak controls, and the evidence defenders use to make fast decisions.",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(height: 1.75, color: muted),
            ),
            const SizedBox(height: 12),
            Text(
              "I bring a builder's eye into security work. I can read application logic, understand implementation tradeoffs, and map vulnerabilities to real product impact while still thinking like a SOC analyst watching the wire.",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(height: 1.75, color: muted),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _Pill(icon: Icons.radar, text: 'Threat triage'),
                _Pill(icon: Icons.search, text: 'nmap scan initialized'),
                _Pill(icon: Icons.code, text: 'AppSec code review'),
                _Pill(icon: Icons.memory, text: 'analyzing traffic...'),
              ],
            ),
          ],
        ),
      );

      final dossier = _CyberPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _DossierHeader(),
            SizedBox(height: 16),
            _IntelTile(
                icon: Icons.workspace_premium,
                label: 'credentials',
                value: 'CompTIA Security+'),
            _IntelTile(
                icon: Icons.flag,
                label: 'lab telemetry',
                value: '175+ TryHackMe rooms, top 2%'),
            _IntelTile(
                icon: Icons.route,
                label: 'learning path',
                value: 'Cyber Security 101, SOC Level 1'),
            _IntelTile(
                icon: Icons.warning_amber, label: 'red alert', value: 'CTFs'),
          ],
        ),
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(I18n.t('about_title'), kicker: '01 / About'),
          const SizedBox(height: 18),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: narrative),
                const SizedBox(width: 18),
                Expanded(flex: 5, child: dossier),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                narrative,
                const SizedBox(height: 16),
                dossier,
              ],
            ),
        ],
      ).animate().fadeIn(duration: 500.ms);
    });
  }
}

class _CyberPanel extends StatelessWidget {
  final Widget child;
  const _CyberPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? DS.surface.withOpacity(.72) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark
                ? DS.signal.withOpacity(.18)
                : DS.signal.withOpacity(.2)),
        boxShadow: isDark
            ? [
                ...DS.shadowSoft(context),
                BoxShadow(
                  color: DS.danger.withOpacity(.055),
                  blurRadius: 26,
                  spreadRadius: -16,
                  offset: const Offset(0, 18),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class _DossierHeader extends StatelessWidget {
  const _DossierHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: DS.signal.withOpacity(.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: DS.signal.withOpacity(.3)),
          ),
          child: const Icon(Icons.verified_user_outlined, color: DS.signal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('live analyst dossier',
                  style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w800, fontSize: 18)),
              Text('access granted / evidence loaded',
                  style: GoogleFonts.jetBrainsMono(
                      color: DS.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntelTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _IntelTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final accent = label.toLowerCase().contains('red') ? DS.danger : DS.signal;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withOpacity(.045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                        color: DS.cyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .5)),
                const SizedBox(height: 3),
                Text(value,
                    style: const TextStyle(
                        height: 1.35, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final accent = text.contains('nmap') || text.contains('traffic')
        ? DS.danger
        : DS.signal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: accent.withOpacity(.07),
        border: Border.all(color: accent.withOpacity(.22)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 8),
          Text(text,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─── Skills ──────────────────────────────────────────────────────────────────

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});
  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('skills_title'), kicker: '02 / Skills'),
        const SizedBox(height: 8),
        Text(
            'Operator toolkit: detection logic, packet-level curiosity, secure app building, and field-ready tooling.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(.62))),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
                label: const Text('Cybersecurity'),
                selected: _index == 0,
                onSelected: (_) => setState(() => _index = 0)),
            ChoiceChip(
                label: const Text('App Build'),
                selected: _index == 1,
                onSelected: (_) => setState(() => _index = 1)),
            ChoiceChip(
                label: const Text('Tooling'),
                selected: _index == 2,
                onSelected: (_) => setState(() => _index = 2)),
          ],
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(
                  sizeFactor: anim, axisAlignment: -1, child: child)),
          child: _SkillCards(
            key: ValueKey(_index),
            skills: [
              ProfileConfig.cybersecuritySkills,
              ProfileConfig.mobileSkills,
              ProfileConfig.toolSkills,
            ][_index],
          ),
        ),
      ],
    );
  }
}

class _SkillCards extends StatelessWidget {
  final List<_Skill> skills;
  const _SkillCards({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.mapIndexed((i, s) {
        final icon = _skillIcon(s.name);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? DS.surface.withOpacity(.72) : Colors.white,
            borderRadius: BorderRadius.circular(DS.pill),
            border: Border.all(
              color: isDark
                  ? DS.signal.withOpacity(.22)
                  : DS.signal.withOpacity(.18),
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: DS.signal.withOpacity(.06),
                      blurRadius: 12,
                      spreadRadius: -4,
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      spreadRadius: -2,
                    )
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: DS.signal),
              const SizedBox(width: 8),
              Text(
                s.name,
                style: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: 45 * i))
            .fadeIn(duration: 260.ms)
            .slideY(begin: .08, duration: 260.ms);
      }).toList(),
    );
  }

  IconData _skillIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('siem') || lower.contains('splunk')) {
      return Icons.monitor_heart_outlined;
    }
    if (lower.contains('incident') || lower.contains('threat')) {
      return Icons.radar_outlined;
    }
    if (lower.contains('mitre') || lower.contains('yara')) {
      return Icons.account_tree_outlined;
    }
    if (lower.contains('wireshark') || lower.contains('nmap')) {
      return Icons.lan_outlined;
    }
    if (lower.contains('flutter') ||
        lower.contains('kotlin') ||
        lower.contains('dart')) {
      return Icons.phone_android_outlined;
    }
    if (lower.contains('python')) return Icons.terminal_outlined;
    if (lower.contains('docker')) return Icons.developer_board_outlined;
    return Icons.shield_outlined;
  }
}

// ─── Projects ────────────────────────────────────────────────────────────────

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});
  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cross = w >= 1100
        ? 3
        : w >= 700
            ? 2
            : 1;
    final ratio = w >= 1100
        ? 0.82
        : w >= 700
            ? 0.78
            : 0.70;

    final projects = _filter == 'all'
        ? ProfileConfig.projects
        : ProfileConfig.projects.where((p) => p.category == _filter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('projects_title'), kicker: '03 / Projects'),
        const SizedBox(height: 8),
        Text(
            'Case files from the lab: apps, secure flows, telemetry, and threat-hunting experiments.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(.62))),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
                label: const Text('All'),
                selected: _filter == 'all',
                onSelected: (_) => setState(() => _filter = 'all')),
            ChoiceChip(
                label: const Text('Cybersecurity'),
                selected: _filter == 'cybersecurity',
                onSelected: (_) => setState(() => _filter = 'cybersecurity')),
            ChoiceChip(
                label: const Text('Mobile'),
                selected: _filter == 'mobile',
                onSelected: (_) => setState(() => _filter = 'mobile')),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: ratio,
          ),
          itemCount: projects.length,
          itemBuilder: (context, i) => ProjectCard(project: projects[i]),
        ),
      ],
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});
  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.project.category == 'security' ? DS.signal : DS.cyan;
    final hoverAccent = _hover ? DS.danger : primary;
    final muted = Colors.white.withOpacity(.64);
    return AnimatedScale(
      scale: _hover ? 1.018 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hover
              ? [
                  BoxShadow(
                      color: hoverAccent.withOpacity(.28),
                      blurRadius: 30,
                      spreadRadius: -9)
                ]
              : [],
          border: Border.all(
            color: _hover ? hoverAccent.withOpacity(.58) : DS.divider,
            width: 1.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DS.surfaceAlt.withOpacity(.74),
              DS.surface.withOpacity(.58),
              hoverAccent.withOpacity(_hover ? .075 : .045),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 172,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: _hover ? 1.04 : 1.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: _netImage(widget.project.imageUrl,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(.10),
                                Colors.black.withOpacity(.72)
                              ],
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(painter: _GridPainter(opacity: .035)),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.55),
                            borderRadius: BorderRadius.circular(DS.pill),
                            border:
                                Border.all(color: hoverAccent.withOpacity(.42)),
                          ),
                          child: Text(
                            widget.project.category.toUpperCase(),
                            style: GoogleFonts.jetBrainsMono(
                                color: hoverAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(DS.pill),
                            onTap: () => _openDetails(context, widget.project),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: DS.background.withOpacity(.72),
                                borderRadius: BorderRadius.circular(DS.pill),
                                border: Border.all(
                                    color: hoverAccent.withOpacity(.38)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.visibility,
                                      size: 16, color: hoverAccent),
                                  const SizedBox(width: 6),
                                  Text('View',
                                      style: GoogleFonts.jetBrainsMono(
                                          color: Colors.white70,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.project.kind.toUpperCase(),
                            style: GoogleFonts.jetBrainsMono(
                                color: primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .8)),
                        const SizedBox(height: 7),
                        Text(
                          widget.project.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            widget.project.summary,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: muted, fontSize: 13, height: 1.45),
                          ),
                        ),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.project.tags
                              .take(3)
                              .map((t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(.08),
                                      borderRadius:
                                          BorderRadius.circular(DS.pill),
                                      border: Border.all(
                                          color: primary.withOpacity(.18)),
                                    ),
                                    child: Text(t,
                                        style: GoogleFonts.jetBrainsMono(
                                            fontSize: 10,
                                            color:
                                                Colors.white.withOpacity(.72))),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(children: [
                          if (widget.project.github.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => _launch(widget.project.github),
                              icon: const Icon(Icons.terminal, size: 16),
                              label: const Text('Repo'),
                              style: TextButton.styleFrom(
                                  foregroundColor: primary,
                                  padding: EdgeInsets.zero),
                            ),
                          const Spacer(),
                          TextButton(
                            onPressed: () =>
                                _openDetails(context, widget.project),
                            style: TextButton.styleFrom(
                                foregroundColor: primary,
                                padding: EdgeInsets.zero),
                            child: const Text('Open file'),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, Project p) {
    web.replaceHash('project=${p.id}');
    analytics.trackEvent('Project Open', {'id': p.id, 'title': p.title});
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: _ProjectDetails(project: p),
        ),
      ),
    ).then((_) => web.clearHash());
  }
}

// ─── Experience ───────────────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ProfileConfig.experience;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('experience_title'), kicker: '05 / Experience'),
        const SizedBox(height: 24),
        for (int i = 0; i < items.length; i++) ...[
          _TimelineItem(item: items[i], isLast: i == items.length - 1),
        ],
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ExperienceItem item;
  final bool isLast;
  const _TimelineItem({required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final primary = DS.signal;
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(.68);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // spine
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                    boxShadow: [
                      BoxShadow(color: primary.withOpacity(.4), blurRadius: 6)
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primary.withOpacity(.5),
                            primary.withOpacity(.05)
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: DS.signal.withOpacity(.18)),
                  gradient: LinearGradient(
                    colors: [
                      DS.signal.withOpacity(.045),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('${item.role} — ${item.org}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(item.period,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final b in item.bullets)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: TextStyle(color: primary)),
                            Expanded(
                                child: Text(b,
                                    style:
                                        TextStyle(color: muted, height: 1.5))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -.05);
  }
}

// ─── Education ────────────────────────────────────────────────────────────────

class EducationSection extends StatelessWidget {
  final List<Education> educationList;
  const EducationSection({super.key, required this.educationList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('education_title'), kicker: '06 / Education'),
        const SizedBox(height: 24),
        for (int i = 0; i < educationList.length; i++) ...[
          _EduTimelineItem(
              edu: educationList[i], isLast: i == educationList.length - 1),
        ],
      ],
    );
  }
}

class _EduTimelineItem extends StatelessWidget {
  final Education edu;
  final bool isLast;
  const _EduTimelineItem({required this.edu, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final primary = DS.cyan;
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(.62);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primary, width: 2.5),
                    color: Colors.transparent,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primary.withOpacity(.4),
                            primary.withOpacity(.05)
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(edu.degree,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${edu.institution} · ${edu.years}',
                      style: TextStyle(color: muted, height: 1.5)),
                  if (edu.details != null)
                    Text(edu.details!,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.42))),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -.05);
  }
}

class Education {
  final String degree, institution, years;
  final String? details;
  Education(
      {required this.degree,
      required this.institution,
      required this.years,
      this.details});
}

// ─── Certs ────────────────────────────────────────────────────────────────────

class CertsSection extends StatelessWidget {
  const CertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final certs = ProfileConfig.certs;
    final w = MediaQuery.of(context).size.width;
    final cross = w > 1000
        ? 3
        : w > 700
            ? 2
            : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('certs_title'), kicker: '07 / Certifications'),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
          ),
          itemCount: certs.length,
          itemBuilder: (context, i) => _CertCard(c: certs[i]),
        ),
      ],
    );
  }
}

class _CertCard extends StatelessWidget {
  final Certification c;
  const _CertCard({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final primary = DS.signal;
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(.62);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(.2)),
        gradient: LinearGradient(
          colors: [primary.withOpacity(.075), DS.cyan.withOpacity(.025)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.verified, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 3),
                Text('${c.issuer} · ${c.year}',
                    style: TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contact ──────────────────────────────────────────────────────────────────

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final isWide = c.maxWidth > 880;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(I18n.t('contact_title'), kicker: '09 / Contact'),
          const SizedBox(height: 8),
          Text(
              "Send a mission brief, Cybersecurity question, app-security task, or freelance opportunity.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(.62))),
          const SizedBox(height: 16),
          if (isWide)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 2, child: _ContactForm()),
              const SizedBox(width: 20),
              Expanded(child: _ContactSidebar()),
            ])
          else
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ContactForm(),
                SizedBox(height: 20),
                _ContactSidebar()
              ],
            ),
        ],
      );
    });
  }
}

// ─── Footer ──────────────────────────────────────────────────────────────────

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          const _GradientDivider(),
          const SizedBox(height: 20),
          // social links
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _SocialBtn(
                icon: Icons.code,
                label: 'GitHub',
                onTap: () => _launch(ProfileConfig.github),
              ),
              _SocialBtn(
                icon: Icons.link,
                label: 'LinkedIn',
                onTap: () => _launch(ProfileConfig.linkedin),
              ),
              _SocialBtn(
                icon: Icons.mail_outline,
                label: 'Email',
                onTap: () => _launch('mailto:${ProfileConfig.email}'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© ${DateTime.now().year} ${ProfileConfig.name}.',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.46),
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        side: BorderSide(color: DS.signal.withOpacity(.22)),
        foregroundColor: DS.signal,
      ),
    );
  }
}

// ─── Contact sidebar + form ───────────────────────────────────────────────────

class _ContactSidebar extends StatelessWidget {
  const _ContactSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DS.signal.withOpacity(.2)),
        gradient: LinearGradient(
          colors: [DS.signal.withOpacity(.06), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Secure channels',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _launch('mailto:${ProfileConfig.email}'),
            icon: const Icon(Icons.mail_outline),
            label: const Text('Email'),
            style: FilledButton.styleFrom(
                backgroundColor: DS.signal, foregroundColor: DS.background),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _launch(ProfileConfig.linkedin),
            icon: const Icon(Icons.link),
            label: const Text('LinkedIn'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _launch(ProfileConfig.github),
            icon: const Icon(Icons.code),
            label: const Text('GitHub'),
          ),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.place, size: 18, color: DS.signal),
            const SizedBox(width: 6),
            Expanded(
                child: Text(ProfileConfig.location,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.66)))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.phone, size: 18, color: DS.signal),
            const SizedBox(width: 6),
            Expanded(
                child: Text(ProfileConfig.phone,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.66)))),
          ]),
        ],
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm({super.key});
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  final _website = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    _website.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_website.text.trim().isNotEmpty) return;
    if (ProfileConfig.contactEndpoint.contains('REPLACE_ME')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Set ProfileConfig.contactEndpoint to your Formspree URL.')),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      final resp =
          await http.post(Uri.parse(ProfileConfig.contactEndpoint), headers: {
        'Accept': 'application/json',
      }, body: {
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'subject': _subject.text.trim(),
        'message': _message.text.trim(),
      });
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        _formKey.currentState?.reset();
        for (final c in [_name, _email, _subject, _message]) {
          c.clear();
        }
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Message sent ✅')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Send failed (${resp.statusCode})')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DS.signal.withOpacity(.2)),
        color: isDark ? DS.surface.withOpacity(.42) : Colors.white,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Offstage(
              offstage: true,
              child: TextFormField(
                  controller: _website,
                  decoration: const InputDecoration(labelText: 'Website')),
            ),
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Your name'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _email,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Your email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v != null && v.contains('@') ? null : 'Valid email required',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _subject,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Subject'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _message,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Message'),
              maxLines: 5,
              validator: (v) => v == null || v.trim().length < 10
                  ? 'Write a bit more (10+ chars)'
                  : null,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send),
                label: Text(_sending ? 'Sending…' : 'Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── I18n ─────────────────────────────────────────────────────────────────────

class I18n {
  static String current = 'en';
  static Locale get locale => Locale(current);

  static const Map<String, Map<String, String>> texts = {
    'en': {
      'about_title': 'About Me',
      'projects_title': 'Featured Projects',
      'skills_title': 'Skills',
      'experience_title': 'Experience',
      'education_title': 'Education',
      'certs_title': 'Certifications',
      'contact_title': 'Get in Touch',
      'blog_title': 'Blog & Notes',
    },
    'fr': {
      'about_title': 'À propos de moi',
      'projects_title': 'Projets en vedette',
      'skills_title': 'Compétences',
      'experience_title': 'Expérience',
      'education_title': 'Formation',
      'certs_title': 'Certifications',
      'contact_title': 'Me contacter',
      'blog_title': 'Articles & Notes',
    },
    'ar': {
      'about_title': 'نبذة عني',
      'projects_title': 'المشاريع المميزة',
      'skills_title': 'المهارات',
      'experience_title': 'الخبرات',
      'education_title': 'التعليم',
      'certs_title': 'الشهادات',
      'contact_title': 'تواصل معي',
      'blog_title': 'مقالات وملاحظات',
    },
  };

  static String t(String key) => texts[current]?[key] ?? key;
}

// ─── Project details dialog ────────────────────────────────────────────────────

class _ProjectDetails extends StatefulWidget {
  final Project project;
  const _ProjectDetails({super.key, required this.project});
  @override
  State<_ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<_ProjectDetails> {
  late final PageController _page = PageController();
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _openFullscreen(List<String> images, int startIndex) {
    analytics.trackEvent('Lightbox Open',
        {'project': widget.project.id, 'index': '$startIndex'});
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) =>
          _ImageLightbox(images: images, initialIndex: startIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final images = p.images.isNotEmpty ? p.images : [p.imageUrl];

    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth > 860;
      final gallery = Column(children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: GestureDetector(
            onTap: () => _openFullscreen(images, _index),
            child: PageView.builder(
              controller: _page,
              onPageChanged: (i) => setState(() => _index = i),
              itemCount: images.length,
              itemBuilder: (_, i) => Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: _netImage(images[i], fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) {
            final active = i == _index;
            return InkWell(
              onTap: () => _page.animateToPage(i,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut),
              child: Container(
                width: active ? 18 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
      ]);

      final content = SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(p.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            IconButton(
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close),
            ),
          ]),
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.06),
                  borderRadius: BorderRadius.circular(999)),
              child: Text(p.kind, style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 2,
                children: p.tags
                    .take(10)
                    .map((t) => Chip(
                          label: Text(t),
                          visualDensity:
                              const VisualDensity(horizontal: -2, vertical: -2),
                        ))
                    .toList(),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Text(p.detail.isNotEmpty ? p.detail : p.summary,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70, height: 1.6)),
          const SizedBox(height: 12),
          if (p.highlights.isNotEmpty) ...[
            Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            ...p.highlights.map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                        Expanded(child: Text(h)),
                      ]),
                )),
            const SizedBox(height: 12),
          ],
          Wrap(spacing: 10, children: [
            if (p.github.isNotEmpty)
              FilledButton.icon(
                  onPressed: () => _launch(p.github),
                  icon: const Icon(Icons.code),
                  label: const Text('Code')),
            if (p.demo.isNotEmpty)
              OutlinedButton.icon(
                  onPressed: () => _launch(p.demo),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Live Demo')),
          ]),
        ]),
      );

      return SizedBox(
        width: c.maxWidth,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      flex: 6,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: gallery)),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: content),
                ])
              : Column(mainAxisSize: MainAxisSize.min, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12), child: gallery),
                  content,
                ]),
        ),
      );
    });
  }
}

// ─── Image lightbox ───────────────────────────────────────────────────────────

class _ImageLightbox extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const _ImageLightbox(
      {super.key, required this.images, this.initialIndex = 0});
  @override
  State<_ImageLightbox> createState() => _ImageLightboxState();
}

class _ImageLightboxState extends State<_ImageLightbox> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: imgs.length,
            itemBuilder: (_, i) => Center(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(40),
                minScale: 1,
                maxScale: 4,
                child: _netImage(imgs[i], fit: BoxFit.contain, big: true),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: IconButton(
              iconSize: 28,
              style: IconButton.styleFrom(backgroundColor: Colors.black45),
              onPressed: _close,
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          Positioned.fill(
            child: Row(children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _controller.animateToPage(
                      (_index - 1).clamp(0, imgs.length - 1),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _controller.animateToPage(
                      (_index + 1).clamp(0, imgs.length - 1),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut),
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imgs.length, (i) {
                final active = i == _index;
                return InkWell(
                  onTap: () => _controller.animateToPage(i,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut),
                  child: Container(
                    width: active ? 18 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Testimonial t;
  const _TestimonialCard({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = Stack(alignment: Alignment.center, children: [
      CircleAvatar(radius: 36, backgroundColor: Colors.white10),
      CircleAvatar(radius: 33, backgroundImage: NetworkImage(t.avatar)),
    ]);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [
          Icon(Icons.format_quote,
              color: theme.colorScheme.primary.withOpacity(.8), size: 20),
          const SizedBox(width: 4),
          Text('Testimonial',
              style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(.65))),
        ]),
        const SizedBox(height: 8),
        Text('"${t.quote}"',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.45)),
        const SizedBox(height: 8),
        Text('${t.name} — ${t.role}',
            style: const TextStyle(color: Colors.white60)),
      ],
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(DS.radius),
        border: Border.all(color: DS.divider),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final compact = c.maxWidth < 420;
        if (compact) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: avatar),
                const SizedBox(height: 12),
                content,
              ]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          avatar,
          const SizedBox(width: 14),
          Expanded(child: content),
        ]);
      }),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .1);
  }
}

class Testimonial {
  final String quote, name, role, avatar;
  const Testimonial(
      {required this.quote,
      required this.name,
      required this.role,
      required this.avatar});
}

// ─── Blog ─────────────────────────────────────────────────────────────────────

class BlogPost {
  final String title, summary, date, url;
  const BlogPost(
      {required this.title,
      required this.summary,
      required this.date,
      required this.url});
}

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = ProfileConfig.posts;
    if (posts.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionTitle(I18n.t('blog_title'), kicker: '— Blog'),
      const SizedBox(height: 16),
      ...posts.map((p) => _BlogCard(post: p)),
    ]);
  }
}

class _BlogCard extends StatelessWidget {
  final BlogPost post;
  const _BlogCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DS.radius),
        border: Border.all(color: DS.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              borderRadius: BorderRadius.circular(DS.pill)),
          child: Text(post.date, style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 10),
        Text(post.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(post.summary, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => launchUrl(Uri.parse(post.url)),
            icon: const Icon(Icons.north_east, size: 16),
            label: const Text('Read'),
          ),
        ),
      ]),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: .08);
  }
}

// ─── DS tokens ────────────────────────────────────────────────────────────────

class DS {
  static const radius = 16.0;
  static const pill = 999.0;
  static const background = Color(0xFF050A09);
  static const surface = Color(0xFF071310);
  static const surfaceAlt = Color(0xFF0B1D18);
  static const signal = Color(0xFF00D084);
  static const cyan = Color(0xFF00D8FF);
  static const amber = Color(0xFFFFC857);
  static const danger = Color(0xFFFF3347);
  static const divider = Color(0x2600D084);
  static List<BoxShadow> shadowSoft(BuildContext _) => [
        BoxShadow(
            color: DS.signal.withOpacity(.12),
            blurRadius: 24,
            offset: const Offset(0, 16)),
      ];
  static List<BoxShadow> redGlow() => [
        BoxShadow(
          color: DS.danger.withOpacity(.22),
          blurRadius: 24,
          spreadRadius: -10,
          offset: const Offset(0, 14),
        ),
      ];
}

// ─── Parallax orbs ────────────────────────────────────────────────────────────

class ParallaxOrbs extends StatelessWidget {
  final ScrollController controller;
  final bool isDark;
  const ParallaxOrbs(
      {super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseA = isDark ? DS.signal : const Color(0xFF00A86B);
    final baseB = isDark ? DS.cyan : const Color(0xFF008DB3);
    final baseC = isDark ? DS.danger : const Color(0xFFB91C1C);

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final o = controller.hasClients ? controller.offset : 0.0;
            return Stack(children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CyberBackdropPainter(offset: o, isDark: isDark),
                ),
              ),
              _orb(
                  left: -140 + o * .03,
                  top: -120 + o * .015,
                  size: 360,
                  color: baseA.withOpacity(isDark ? .18 : .12)),
              _orb(
                  right: -120 - o * .06,
                  top: 220 - o * .048,
                  size: 300,
                  color: baseB.withOpacity(isDark ? .14 : .09)),
              _orb(
                  left: -80 + o * .045 * .6,
                  bottom: -100 + o * .045,
                  size: 420,
                  color: baseC.withOpacity(isDark ? .08 : .06)),
            ]);
          },
        ),
      ),
    );
  }

  Widget _orb(
      {double? left,
      double? right,
      double? top,
      double? bottom,
      required double size,
      required Color color}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
        ),
      ),
    );
  }
}

class _CyberBackdropPainter extends CustomPainter {
  final double offset;
  final bool isDark;
  const _CyberBackdropPainter({required this.offset, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = (isDark ? DS.signal : const Color(0xFF007A5A))
          .withOpacity(isDark ? .045 : .05)
      ..strokeWidth = .6;
    const step = 72.0;
    final shift = offset % step;

    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height * .18, size.height), grid);
    }
    for (double y = -step + shift * .35; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final node = Paint()
      ..color = DS.cyan.withOpacity(isDark ? .10 : .07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double x = 80; x < size.width; x += 220) {
      for (double y = 120; y < size.height; y += 260) {
        final p = Offset(x + (offset * .02 % 28), y - (offset * .01 % 18));
        canvas.drawCircle(p, 4, node);
        canvas.drawLine(p, p + const Offset(72, -36), node);
      }
    }
  }

  @override
  bool shouldRepaint(_CyberBackdropPainter old) =>
      old.offset != offset || old.isDark != isDark;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Future<void> _launch(String url) async {
  final parsed = Uri.tryParse(url);
  if (parsed == null) return;
  final scheme = parsed.scheme.toLowerCase();
  final isMailOrPhone =
      scheme == 'mailto' || scheme == 'tel' || scheme == 'sms';
  final isHttp = scheme == 'http' || scheme == 'https';

  if (isMailOrPhone) {
    await launchUrl(parsed,
        mode: LaunchMode.platformDefault, webOnlyWindowName: '_self');
    return;
  }

  if (kIsWeb) {
    if (!await launchUrl(parsed,
        mode: LaunchMode.platformDefault, webOnlyWindowName: '_blank')) {
      await launchUrl(parsed,
          mode: LaunchMode.platformDefault, webOnlyWindowName: '_self');
    }
    return;
  }

  if (!await launchUrl(parsed, mode: LaunchMode.externalApplication) &&
      isHttp) {
    await launchUrl(parsed, mode: LaunchMode.inAppWebView);
  }
}

Widget _netImage(String url, {BoxFit fit = BoxFit.cover, bool big = false}) {
  if (kIsWeb) {
    return Image.network(url,
        fit: fit, errorBuilder: (_, __, ___) => const _ImgError());
  }
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (_, __) => Center(
      child: SizedBox(
          width: big ? 36 : 24,
          height: big ? 36 : 24,
          child: const CircularProgressIndicator(strokeWidth: 2)),
    ),
    errorWidget: (_, __, ___) => const _ImgError(),
  );
}

class _ImgError extends StatelessWidget {
  const _ImgError({super.key});
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black26,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, size: 40, color: Colors.white54),
      );
}
