import 'dart:async';
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
        colorSchemeSeed: Colors.indigo,
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
            side: const BorderSide(color: Color(0x331B1F2A)),
          ),
        ),
        chipTheme: ChipThemeData(
          shape:
              StadiumBorder(side: const BorderSide(color: Color(0x221B1F2A))),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          backgroundColor: const Color(0x0F1B1F2A),
          selectedColor: const Color(0x201B1F2A),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0B0D13),
        cardColor: const Color(0x80121623),
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
            borderSide: BorderSide(color: Colors.indigo.shade300, width: 1.4),
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
  static const title = 'Mobile Developer & SOC Analyst';
  static const tagline =
      'From Code to Cyber Defense: Crafting Apps and Protecting Systems';
  static const location = 'Meknes, Morocco';
  static const email = 'elouakfaouiyassine@gmail.com';
  static const phone = '+212 777539454';
  static const github = 'https://github.com/ElouakfaouiYassine';
  static const linkedin = 'https://www.linkedin.com/in/yassine-elouakfaoui/';
  static const resumeUrl = 'assets/resume.pdf';
  static const contactEndpoint = 'https://formspree.io/f/mpwjborw';

  static const mobileSkills = [
    _Skill('Flutter', 88),
    _Skill('Kotlin / Android', 85),
    _Skill('Dart', 82),
    _Skill('iOS (Swift basics)', 45),
    _Skill('Firebase', 75),
    _Skill('SQLite / MongoDB', 70),
    _Skill('Design Patterns', 80),
  ];
  static const socSkills = [
    _Skill('SIEM (Splunk / ELK)', 75),
    _Skill('Incident Response', 72),
    _Skill('Threat Hunting', 70),
    _Skill('MITRE ATT&CK', 68),
    _Skill('Network Forensics', 65),
    _Skill('OSINT', 70),
    _Skill('Python Scripting', 78),
  ];
  static const toolSkills = [
    _Skill('Git / GitHub', 88),
    _Skill('Docker', 65),
    _Skill('Wireshark', 72),
    _Skill('Burp Suite', 65),
    _Skill('Nmap', 72),
    _Skill('YARA / Sigma', 60),
    _Skill('Postman', 75),
  ];

  static final projects = <Project>[
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
          'E2EE chat with offline cache, message reactions, and push notifications.',
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
      category: 'security',
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
  ];

  static final testimonials = <Testimonial>[
    Testimonial(
      quote:
          "Yassine ships fast, writes clean code, and catches security issues early. A rare mix of mobile and blue-team skills.",
      name: "Anas B.",
      role: "Senior Android Engineer",
      avatar: "https://i.pravatar.cc/120?img=12",
    ),
    Testimonial(
      quote:
          "Great incident triage and thoughtful playbooks. His detections reduced our noisy alerts by ~40%.",
      name: "Sara M.",
      role: "SOC Team Lead",
      avatar: "https://i.pravatar.cc/120?img=32",
    ),
    Testimonial(
      quote:
          "Our Kotlin app's checkout went from flaky to rock-solid after his refactor and Stripe integration.",
      name: "Ismail K.",
      role: "Product Manager",
      avatar: "https://i.pravatar.cc/120?img=8",
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
      title: "Building a Secure Kotlin Checkout Flow",
      summary:
          "Lessons learned from integrating Stripe with 3-D Secure in a Kotlin e-commerce app.",
      date: "Mar 2025",
      url: "https://medium.com/@yassine/secure-kotlin-checkout",
    ),
    BlogPost(
      title: "SOC Analyst Playbook: Reducing Alert Fatigue",
      summary:
          "How I tuned detections and cut noisy alerts by 40% in a SOC environment.",
      date: "Feb 2025",
      url: "https://medium.com/@yassine/soc-analyst-playbook",
    ),
    BlogPost(
      title: "From PHP to MongoDB Hybrid Backends",
      summary:
          "Exploring hybrid persistence models for mobile apps that need offline + online sync.",
      date: "Jan 2025",
      url: "https://medium.com/@yassine/hybrid-backends",
    ),
  ];

  static final experience = <ExperienceItem>[
    ExperienceItem(
      role: 'Back-End Developer',
      org: 'E-ContactMessage',
      period: '1 Month',
      bullets: [
        'Developed REST APIs using PHP and MySQL',
        'Designed scalable database schemas',
        'Supported improvements in system security and performance',
      ],
    ),
    ExperienceItem(
      role: 'Mobile Developer',
      org: 'E-ContactMessage',
      period: '3 Months',
      bullets: [
        'Built using Android SDK: Activities, RecyclerViews, SQLite, etc.',
        'Integrated SQLite for offline storage and remote DB sync.',
        'Applied user feedback to improve UX and navigation.',
      ],
    ),
  ];

  static final certs = <Certification>[
    Certification('Python Programming', 'Cisco', '2023'),
    Certification('Blue Team Fundamentals (BTF)', 'CyberWarFare Labs', '2025'),
    Certification('Cyber Security Analyst (C3SA)', 'CyberWarFare Labs', '2025'),
  ];
}

class _Skill {
  final String name;
  final int level; // 0–100
  const _Skill(this.name, this.level);
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
  final _testimonialsKey = GlobalKey();
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
    MapEntry('Testimonials', _testimonialsKey),
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
              title: Text(ProfileConfig.name,
                  style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700, fontSize: 17)),
              flexibleSpace: isWide
                  ? ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: (widget.isDark ? Colors.black : Colors.white)
                                .withOpacity(0.18),
                            border: const Border(
                                bottom: BorderSide(
                                    color: Color(0x22FFFFFF), width: 1)),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xE00B0D13)
                            : Colors.white.withOpacity(0.95),
                        border: const Border(
                            bottom:
                                BorderSide(color: Color(0x22FFFFFF), width: 1)),
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
                              colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Color(0xFF3949AB),
                                  backgroundImage: NetworkImage(
                                      'https://github.com/ElouakfaouiYassine.png'),
                                ),
                                SizedBox(height: 10),
                                Text(ProfileConfig.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text(ProfileConfig.title,
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
                          Section(
                              key: _testimonialsKey,
                              child: const TestimonialsSection(),
                              altBackground: true),
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
    final fg = active
        ? theme.colorScheme.primary
        : theme.textTheme.labelLarge?.color ?? Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: active
              ? theme.colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
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
    final horizontal = width < 420
        ? 10.0
        : width < 700
            ? 12.0
            : width >= 1400
                ? 12.0
                : width >= 1100
                    ? 16.0
                    : 20.0;
    final vertical = width < 700 ? 16.0 : 24.0;
    final bg = altBackground
        ? isDark
            ? Colors.white.withOpacity(0.02)
            : Colors.black.withOpacity(0.03)
        : Colors.transparent;

    final sectionContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          if (showDivider) ...[
            const SizedBox(height: 16),
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
        child: width >= 900
            ? ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1360),
                child: sectionContent,
              )
            : sectionContent,
      ),
    );
  }
}

class _GradientDivider extends StatelessWidget {
  const _GradientDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0x55FFFFFF), Colors.transparent],
          stops: [0.1, 0.5, 0.9],
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
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kicker != null) ...[
          Text(kicker!,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: primary,
                  letterSpacing: 2.5)),
          const SizedBox(height: 6),
        ],
        Text(text,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -.5)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 3,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient:
                    LinearGradient(colors: [primary, primary.withOpacity(0)]),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: primary.withOpacity(.2),
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
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(.65);
    final primary = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(builder: (context, c) {
      final isWide = c.maxWidth > 760;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isWide ? 6 : 10,
                child: Column(
                  crossAxisAlignment: isWide
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    // ── Gradient name ──────────────────────────────────────
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [primary, const Color(0xFF00E5FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        ProfileConfig.name,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isWide ? 44 : 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ── Typewriter roles ───────────────────────────────────
                    _TypewriterText(
                      texts: const [
                        'Mobile Developer',
                        'Flutter Developer',
                        'SOC Analyst',
                        'Blue Team Engineer',
                      ],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: isWide ? 20 : 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ProfileConfig.tagline,
                      textAlign: isWide ? TextAlign.start : TextAlign.center,
                      style: TextStyle(color: muted, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    // ── CTA buttons ────────────────────────────────────────
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      alignment:
                          isWide ? WrapAlignment.start : WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: onHireMe,
                          icon: const Icon(Icons.mail_outline, size: 18),
                          label: const Text('Hire Me'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _launch(ProfileConfig.github),
                          icon: const Icon(Icons.code, size: 18),
                          label: const Text('GitHub'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isWide) ...[
                const SizedBox(width: 32),
                Expanded(flex: 4, child: const _AuroraVisual()),
              ],
            ],
          ),
          // ── Stats strip ─────────────────────────────────────────────────
          const SizedBox(height: 40),
          const _StatsStrip(),
        ],
      );
    });
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
    final primary = Theme.of(context).colorScheme.primary;
    final items = [
      ('4+', 'Projects'),
      ('3', 'Certifications'),
      ('2+', 'Years Exp.'),
      ('3', 'Languages'),
    ];

    return LayoutBuilder(builder: (_, c) {
      final narrow = c.maxWidth < 500;
      return Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.start,
        children: items.map((item) {
          return Container(
            constraints: BoxConstraints(minWidth: narrow ? 120 : 140),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: primary.withOpacity(.25)),
              gradient: LinearGradient(
                colors: [primary.withOpacity(.07), primary.withOpacity(.02)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(item.$1,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: primary)),
                const SizedBox(height: 2),
                Text(item.$2,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white60)),
              ],
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
      AnimationController(vsync: this, duration: const Duration(seconds: 9))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // base
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0D0F1A), Color(0xFF1A1040)],
                    ),
                  ),
                ),
                // blobs
                Align(
                  alignment: Alignment(-0.9 + 0.35 * t, -0.9 + 0.25 * t),
                  child: FractionallySizedBox(
                    widthFactor: .75,
                    heightFactor: .75,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          const Color(0xFF6C63FF).withOpacity(.38),
                          const Color(0xFF6C63FF).withOpacity(0),
                        ]),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.85 - 0.25 * t, 0.8 - 0.2 * t),
                  child: FractionallySizedBox(
                    widthFactor: .6,
                    heightFactor: .6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          const Color(0xFF00E5FF).withOpacity(.28),
                          const Color(0xFF00E5FF).withOpacity(0),
                        ]),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.1 + 0.15 * t, 0.95 - 0.15 * t),
                  child: FractionallySizedBox(
                    widthFactor: .5,
                    heightFactor: .5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          const Color(0xFFFF2D95).withOpacity(.22),
                          const Color(0xFFFF2D95).withOpacity(0),
                        ]),
                      ),
                    ),
                  ),
                ),
                // grid
                CustomPaint(painter: _GridPainter(opacity: .05)),
                // icon chips
                _chip(Icons.smartphone, -0.72, -0.72, 'Flutter', 0.07 * t),
                _chip(Icons.security, 0.62, -0.78, 'SOC', -0.06 * t),
                _chip(Icons.code, 0.68, 0.50, 'Kotlin', 0.05 * t),
                _chip(Icons.network_check, -0.58, 0.72, 'SIEM', -0.07 * t),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(
          IconData icon, double ax, double ay, String label, double drift) =>
      Align(
        alignment: Alignment(ax + drift, ay + drift * .6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.07),
            border: Border.all(color: Colors.white.withOpacity(.12)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white60),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms),
      );
}

class _GridPainter extends CustomPainter {
  final double opacity;
  const _GridPainter({required this.opacity});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = .5;
    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.opacity != opacity;
}

// ─── About ───────────────────────────────────────────────────────────────────

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('about_title'), kicker: '01 / About'),
        const SizedBox(height: 16),
        Text(
          "Motivated Mobile Developer and SOC Analyst passionate about Blue Team cybersecurity and building secure, user-friendly mobile applications. Skilled in mobile app development and security fundamentals, with a strong interest in defending networks against threats. Actively seeking a job opportunity to apply my skills and grow in both development and cybersecurity fields.",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(height: 1.7, color: Colors.white70),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _Pill(
                icon: Icons.integration_instructions,
                text: 'Clean, testable app architectures'),
            _Pill(
                icon: Icons.dataset,
                text: 'Data‑driven detections & dashboards'),
            _Pill(icon: Icons.device_hub, text: 'Network & endpoint triage'),
            _Pill(
                icon: Icons.lock_outline,
                text: 'Privacy by Design / Secure SDLC'),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13)),
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

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('skills_title'), kicker: '02 / Skills'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
                label: const Text('Mobile'),
                selected: _index == 0,
                onSelected: (_) => setState(() => _index = 0)),
            ChoiceChip(
                label: const Text('SOC'),
                selected: _index == 1,
                onSelected: (_) => setState(() => _index = 1)),
            ChoiceChip(
                label: const Text('Tools'),
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
              ProfileConfig.mobileSkills,
              ProfileConfig.socSkills,
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
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.mapIndexed((i, s) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: primary.withOpacity(.35),
              width: 1.2,
            ),
            color: isDark
                ? Colors.white.withOpacity(.04)
                : Colors.black.withOpacity(.04),
          ),
          child: Text(
            s.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white.withOpacity(.88) : Colors.black87,
              letterSpacing: .2,
            ),
          ),
        )
            .animate(delay: Duration(milliseconds: 40 * i))
            .fadeIn(duration: 260.ms)
            .scale(begin: const Offset(.92, .92), duration: 260.ms);
      }).toList(),
    );
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
        ? 1.05
        : w >= 700
            ? 0.90
            : 0.78;

    final projects = _filter == 'all'
        ? ProfileConfig.projects
        : ProfileConfig.projects.where((p) => p.category == _filter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('projects_title'), kicker: '03 / Projects'),
        const SizedBox(height: 8),
        Text('A mix of mobile apps and blue-team security work.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white60)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
                label: const Text('All'),
                selected: _filter == 'all',
                onSelected: (_) => setState(() => _filter = 'all')),
            ChoiceChip(
                label: const Text('Mobile'),
                selected: _filter == 'mobile',
                onSelected: (_) => setState(() => _filter = 'mobile')),
            ChoiceChip(
                label: const Text('Security'),
                selected: _filter == 'security',
                onSelected: (_) => setState(() => _filter = 'security')),
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
    final primary = Theme.of(context).colorScheme.primary;
    return AnimatedScale(
      scale: _hover ? 1.025 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DS.radius),
          boxShadow: _hover
              ? [
                  BoxShadow(
                      color: primary.withOpacity(.35),
                      blurRadius: 22,
                      spreadRadius: -4)
                ]
              : [],
          border: Border.all(
            color: _hover ? primary.withOpacity(.4) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DS.radius),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: _hover ? 1.06 : 1.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: _netImage(widget.project.imageUrl,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 56,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Color(0xAA000000), Color(0x00000000)],
                            ),
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
                                color: Colors.black.withOpacity(.55),
                                borderRadius: BorderRadius.circular(DS.pill),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.visibility,
                                      size: 16, color: Colors.white70),
                                  SizedBox(width: 6),
                                  Text('View',
                                      style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.06),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(widget.project.kind,
                                style: const TextStyle(fontSize: 11)),
                          ),
                          const Spacer(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: widget.project.tags
                                  .take(2)
                                  .map((t) => Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Chip(
                                            label: Text(t),
                                            visualDensity: const VisualDensity(
                                                horizontal: -2, vertical: -2)),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(
                          widget.project.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            widget.project.summary,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 13),
                          ),
                        ),
                        Row(children: [
                          if (widget.project.github.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => _launch(widget.project.github),
                              icon: const Icon(Icons.code, size: 16),
                              label: const Text('Code'),
                            ),
                          if (widget.project.demo.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => _launch(widget.project.demo),
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: const Text('Live'),
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
    final primary = Theme.of(context).colorScheme.primary;
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
                  border: Border.all(color: Colors.white10),
                  color: Colors.white.withOpacity(.03),
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
                                    style: const TextStyle(
                                        color: Colors.white70, height: 1.5))),
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
    final primary = Theme.of(context).colorScheme.primary;
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
                      style:
                          const TextStyle(color: Colors.white60, height: 1.5)),
                  if (edu.details != null)
                    Text(edu.details!,
                        style: const TextStyle(color: Colors.white38)),
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
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
        gradient: LinearGradient(
          colors: [primary.withOpacity(.05), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: primary),
          const SizedBox(width: 10),
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
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 12)),
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
          Text("Email me or send a message — I'll respond quickly.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white60)),
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
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          const Divider(color: Colors.white12),
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
            '© ${DateTime.now().year} ${ProfileConfig.name}. All rights reserved.',
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Built with Flutter · Deployed on GitHub Pages',
            style: TextStyle(color: primary.withOpacity(.5), fontSize: 11),
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
        side: const BorderSide(color: Colors.white12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () => _launch('mailto:${ProfileConfig.email}'),
            icon: const Icon(Icons.mail_outline),
            label: const Text('Email'),
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
            const Icon(Icons.place, size: 18, color: Colors.white60),
            const SizedBox(width: 6),
            Expanded(
                child: Text(ProfileConfig.location,
                    style: const TextStyle(color: Colors.white60))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.phone, size: 18, color: Colors.white60),
            const SizedBox(width: 6),
            Expanded(
                child: Text(ProfileConfig.phone,
                    style: const TextStyle(color: Colors.white60))),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
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
      'testimonials_title': 'Testimonials',
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
      'testimonials_title': 'Témoignages',
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
      'testimonials_title': 'آراء العملاء',
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

// ─── Testimonials ─────────────────────────────────────────────────────────────

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});
  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final _ctrl = PageController(viewportFraction: 1.0);
  int _index = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ProfileConfig.testimonials;
    if (items.isEmpty) return const SizedBox.shrink();
    final width = MediaQuery.of(context).size.width;
    final cardHeight = width < 700
        ? 320.0
        : width < 1100
            ? 300.0
            : 280.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionTitle(I18n.t('testimonials_title'), kicker: '08 / Testimonials'),
      const SizedBox(height: 12),
      SizedBox(
        height: cardHeight,
        child: PageView.builder(
          controller: _ctrl,
          onPageChanged: (i) => setState(() => _index = i),
          itemCount: items.length,
          itemBuilder: (_, i) => _TestimonialCard(t: items[i]),
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(items.length, (i) {
          final active = i == _index;
          return Container(
            width: active ? 18 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white24,
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    ]);
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
  static const divider = Color(0x1AFFFFFF);
  static List<BoxShadow> shadowSoft(BuildContext c) => [
        BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 10)),
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
    final baseA = isDark ? const Color(0xFF6C63FF) : const Color(0xFF5B6CFF);
    final baseB = isDark ? const Color(0xFF00E5FF) : const Color(0xFF00C8E5);
    final baseC = isDark ? const Color(0xFFFF2D95) : const Color(0xFFFF4DAA);

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final o = controller.hasClients ? controller.offset : 0.0;
            return Stack(children: [
              _orb(
                  left: -140 + o * .03,
                  top: -120 + o * .015,
                  size: 360,
                  color: baseA.withOpacity(.22)),
              _orb(
                  right: -120 - o * .06,
                  top: 220 - o * .048,
                  size: 300,
                  color: baseB.withOpacity(.18)),
              _orb(
                  left: -80 + o * .045 * .6,
                  bottom: -100 + o * .045,
                  size: 420,
                  color: baseC.withOpacity(.16)),
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
