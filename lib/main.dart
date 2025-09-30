import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'web_url_stub.dart' if (dart.library.html) 'web_url_web.dart' as web;
import 'package:cached_network_image/cached_network_image.dart';
import 'web_analytics_stub.dart' if (dart.library.html) 'web_analytics_web.dart' as analytics;
import 'dart:ui' show ImageFilter;
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PortfolioApp());
}
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
    void _toggleTheme() {
      setState(() {
        _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      });
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Elouakfaoui Yassine',
        debugShowCheckedModeBanner: false,
        themeMode: _mode,
          locale: I18n.locale,
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
          Locale('ar'),
        ],
        builder: (context, child) => Directionality(
          textDirection: I18n.current == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (device, supported) =>
            supported.firstWhere((l) => l.languageCode == I18n.current, orElse: () => const Locale('en')),

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
              ? GoogleFonts.cairoTextTheme(Typography.material2021(platform: TargetPlatform.android).black)
              : Typography.material2021(platform: TargetPlatform.android).black.apply(
            bodyColor: const Color(0xFF1B1F2A),
            displayColor: const Color(0xFF0F1230),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.radius)),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.pill)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.pill)),
              side: const BorderSide(color: Color(0x331B1F2A)),
            ),
          ),
          chipTheme: ChipThemeData(
            shape: StadiumBorder(side: const BorderSide(color: Color(0x221B1F2A))),
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
              ? GoogleFonts.cairoTextTheme(Typography.whiteCupertino)
              : Typography.whiteCupertino,
          cardTheme: CardTheme(
            elevation: 0,
            color: const Color(0x66121623),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.radius)),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.pill)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.pill)),
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
        home: PortfolioHome(onToggleTheme: _toggleTheme, isDark: _mode==ThemeMode.dark),
  );
  }
}


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
  static const resumeUrl = 'web/assets/resume.pdf';
  static const contactEndpoint = 'https://formspree.io/f/mpwjborw';

  static const mobileSkills = [
    'Android (Kotlin/Java)',
    'Python',
    'Flutter',
    'Dart',
    'iOS (Swift basics)',
    'Design Pattern: MVC, MVP and MVVM',
    'MongoDB',
    'SQLite',
    'Firebase',
  ];
  static const socSkills = [
    'SOC L1/L2',
    'SIEM (Splunk/ELK/QRadar)',
    'Incident Response',
    'Threat Hunting',
    'MITRE ATT&CK',
    'Network Forensics',
    'OSINT',
    'Win/Linux Hardening',
    'Python Scripting',
  ];
  static const toolSkills = [
    'Git/GitHub',
    'Docker',
    'Postman',
    'Wireshark',
    'Burp Suite',
    'Nmap',
    'Regex',
    'YARA',
    'Sigma Rules',
    'Sysmon',
  ];

  static final projects = <Project>[
    Project(
      title: 'E‑commerce App',
      kind: 'Mobile (Kotlin)',
      summary:
      'A full-stack e-commerce mobile app built using Kotlin (Android), PHP (backend).',
      tags: ['Kotlin', 'PHP', 'Stripe', 'MVVM', 'Clean Architecture', 'SQLite', 'MongoDB'],
      github: 'https://github.com/ElouakfaouiYassine/E-commerce-app',
      demo: '',
      imageUrl: 'https://raw.githubusercontent.com/ElouakfaouiYassine/E-commerce-app/master/screenshots/Application%20sTORE.jpg',
      category: 'mobile',
      detail: 'A full-stack e-commerce mobile app built using Kotlin (Android), PHP (backend), with hybrid database support using SQLite (local) and MongoDB (remote). The app offers complete user experience including authentication, product browsing, cart, admin management, and dark mode.',
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
      'Created a real-time alert app that detects charging-related fire risks. Implemented instant notifications to warn users of potential hazards.',
      tags: ['kotlin', 'MVVM', 'Notification'],
      github: 'https://github.com/ElouakfaouiYassine/Protect-Your-House-App',
      demo: '',
      imageUrl: 'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Feature%20graphic.png',
      category: 'mobile',
      detail: 'Protect Your House App is a mobile application built with Kotlin to strengthen home safety against fire risks caused by charging devices. It continuously monitors charging conditions, detects anomalies in real-time, and provides instant notifications to alert users. The app is designed with an MVVM architecture to ensure scalability, clean code, and maintainability.',
      images: [
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/2.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Screenshot_20250704_224606.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Screenshot_20250708_235434.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/Screenshot_20250709_004703.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/headr1.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/Protect-Your-House-App/main/app/screenshots/headr2.png',
        ],
      highlights: [
        'Built with Kotlin and MVVM architecture for clean and maintainable code.',
        'Real-time monitoring of charging devices to prevent fire hazards.',
        'Instant notifications and alerts to warn users of risks.',
        'Lightweight UI optimized for fast performance and low battery usage.',
        'Modular design enabling easy future expansion (e.g., IoT integration).',
      ],
      id: 'stopfire',
    ),
    Project(
      title: 'Chat App',
      kind: 'Mobile',
      summary:
      'E2EE chat with offline cache, message reactions, and push notifications.',
      tags: ['Kotlin', 'Spring Boot', 'MongoDB', 'PGP', 'WebSocket'],
      github: 'https://github.com/ElouakfaouiYassine/Sites-Sweeper?tab=readme-ov-file',
      demo: '',
      imageUrl: 'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/1.jpg',
      category: 'mobile',
      detail: 'Realtime chat app with E2EE, offline cache, typing indicators and push notifications.',
      images: [
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/1.jpg',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/2.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/3.jpg',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/4.jpg',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/5.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/6.jpg',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/7.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/8.png',
          'https://raw.githubusercontent.com/ElouakfaouiYassine/SecureChatApp/main/app/Screenshots/9.jpg'
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
      'Python + Zeek pipeline to flag C2 beacons and rare destinations using rolling z‑scores.',
      tags: ['Python', 'Zeek', 'NetFlow'],
      github: 'https://github.com/ElouakfaouiYassine/Sites-Sweeper?tab=readme-ov-file',
      demo: '',
      imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      category: 'security',
      detail: 'Threat hunting pipeline using NetFlow/Zeek to surface beaconing & rare destinations.',
      images: [
          'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=1200&auto=format'
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
      quote: "Yassine ships fast, writes clean code, and catches security issues early. A rare mix of mobile and blue-team skills.",
      name: "Anas B.",
      role: "Senior Android Engineer",
      avatar: "https://i.pravatar.cc/120?img=12",
    ),
    Testimonial(
      quote: "Great incident triage and thoughtful playbooks. His detections reduced our noisy alerts by ~40%.",
      name: "Sara M.",
      role: "SOC Team Lead",
      avatar: "https://i.pravatar.cc/120?img=32",
    ),
    Testimonial(
      quote: "Our Kotlin app’s checkout went from flaky to rock-solid after his refactor and Stripe integration.",
      name: "Ismail K.",
      role: "Product Manager",
      avatar: "https://i.pravatar.cc/120?img=8",
    ),
  ];

  static final educationList = <Education>[
    Education(
      degree: "Bachelor’s Degree in Computer Security and Networks",
      institution: "EST – École Supérieure de Technologie Guelmim, Ibn Zohr University",
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
      summary: "Lessons learned from integrating Stripe with 3-D Secure in a Kotlin e-commerce app.",
      date: "Mar 2025",
      url: "https://medium.com/@yassine/secure-kotlin-checkout",
    ),
    BlogPost(
      title: "SOC Analyst Playbook: Reducing Alert Fatigue",
      summary: "How I tuned detections and cut noisy alerts by 40% in a SOC environment.",
      date: "Feb 2025",
      url: "https://medium.com/@yassine/soc-analyst-playbook",
    ),
    BlogPost(
      title: "From PHP to MongoDB Hybrid Backends",
      summary: "Exploring hybrid persistence models for mobile apps that need offline + online sync.",
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
      period: '3 Month',
      bullets: [
        'Built using Android SDK components: Activities, RecyclerViews, Layouts,SQLite, etc.',
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


class Project {
  final String title;
  final String kind;
  final String summary;
  final List<String> tags;
  final String github;
  final String demo;
  final String imageUrl;
  final String category;
  final String detail;
  final List<String> images;
  final List<String> highlights;
  final String id;
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
  final String role;
  final String org;
  final String period;
  final List<String> bullets;
  const ExperienceItem({
    required this.role,
    required this.org,
    required this.period,
    required this.bullets,
  });
}

class Certification {
  final String name;
  final String issuer;
  final String year;
  const Certification(this.name, this.issuer, this.year);
}


class PortfolioHome extends StatefulWidget {
    final VoidCallback onToggleTheme;
    final bool isDark;
    const PortfolioHome({super.key, required this.onToggleTheme, required this.isDark});

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
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
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
      if (score < best) { best = score; bestIdx = i; }
    }
    if (bestIdx != _active && mounted) {
      setState(() => _active = bestIdx);
    }
  }
  @override
  void initState() {
    super.initState();
    final hash = web.getHash();
    if (hash.startsWith('project=')) {
      final id = hash.split('=').last;
      final match = ProfileConfig.projects.firstWhere(
            (p) => p.id == id,
        orElse: () => ProfileConfig.projects.first,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openProject(match);
      });

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
                    .firstWhere(
                      (l) => RegExp(r'^[1-8]$').hasMatch(l),
                  orElse: () => '',
                );
                if (label.isEmpty) return null;
                final idx = int.parse(label) - 1;
                if (idx >= 0 && idx < _sections.length) {
                  _scrollTo(_sections[idx].value);
                }
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
        title: Text(ProfileConfig.name),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: (widget.isDark ? Colors.black : Colors.white).withOpacity(0.20),
                border: const Border(
                  bottom: BorderSide(color: Color(0x22FFFFFF), width: 1),
                ),
              ),
            ),
          ),
        ),
        actions: MediaQuery.of(context).size.width >= 980
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
              icon: const Icon(Icons.file_download),
              label: const Text('Resume'),
            ),
          ),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round),
          ),
          PopupMenuButton<String>(
            tooltip: 'Language',
            icon: const Icon(Icons.language),
            onSelected: (lang) => setState(() { I18n.current = lang; }),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'fr', child: Text('Français')),
              PopupMenuItem(value: 'ar', child: Text('العربية')),
            ],
          ),
        ]
            : null,
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
                onPressed: () => _scroll.animateTo(0, duration: const Duration(milliseconds: 450), curve: Curves.easeOut),
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
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(ProfileConfig.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            _drawerItem('About', _aboutKey),
            _drawerItem('Skills', _skillsKey),
            _drawerItem('Projects', _projectsKey),
            _drawerItem('Experience', _experienceKey),
            _drawerItem('Education', _educationKey),
            _drawerItem('Certs', _certsKey),
            _drawerItem('Contact', _contactKey),
            _drawerItem('Testimonials', _testimonialsKey),
            _drawerItem('Blog', _blogKey),
            ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Resume'),
            onTap: _downloadResume,
        ),
            const Divider(),
            const ListTile(title: Text('Language')),
            ListTile(title: const Text('English'),  onTap: () { setState(() { I18n.current = 'en'; }); Navigator.pop(context); }),
            ListTile(title: const Text('Français'), onTap: () { setState(() { I18n.current = 'fr'; }); Navigator.pop(context); }),
            ListTile(title: const Text('العربية'),  onTap: () { I18n.current = 'ar'; setState(() {}); Navigator.pop(context); }),
          ],
        ),
      ),
      body: Stack(
        children: [

          ParallaxOrbs(controller: _scroll, isDark: widget.isDark),


      Scrollbar(
        controller: _scroll,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Section(key: _homeKey, child: const HeroSection(), altBackground: false),
                Section(key: _aboutKey, child: const AboutSection(), altBackground: true),
                Section(key: _skillsKey, child: const SkillsSection(), altBackground: false),
                Section(key: _projectsKey, child: const ProjectsSection(), altBackground: true),
                Section(key: _experienceKey, child: const ExperienceSection(), altBackground: false),
                Section(key: _educationKey, child: EducationSection(educationList: ProfileConfig.educationList), altBackground: true,),
                Section(key: _certsKey, child: const CertsSection(), altBackground: false),
                Section(key: _testimonialsKey, child: const TestimonialsSection(), altBackground: true),
                Section(key: _blogKey, child: const BlogSection(), altBackground: false),
                Section(key: _contactKey, child: const ContactSection(), altBackground: true),
                const Footer(),
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

  Widget _navItemButton({required String label, required VoidCallback onTap, required bool active}) {
    final theme = Theme.of(context);
    final bg = active
        ? theme.colorScheme.primary.withOpacity(0.16)
        : Colors.transparent;
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: bg,
        ),
        child: Row(
          children: [
            Text(label),
            if (active)
              Container(
                margin: const EdgeInsets.only(left: 8),
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.0),
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

          ],
        ),
      ),
    );
  }


  Widget _navBtn(String label, VoidCallback onTap) => TextButton(
    onPressed: onTap,
    child: Text(label),
  );

  Widget _drawerItem(String label, GlobalKey key) => ListTile(
    title: Text(label),
    onTap: () {
      Navigator.of(context).maybePop();
      Future.delayed(const Duration(milliseconds: 180), () => _scrollTo(key));
    },
  );

  Widget _glow(double size, Color color) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    ),
  );
}

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
    final bg = altBackground
        ? Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.02)
        : Colors.black.withOpacity(0.03)
        : Colors.transparent;

    return Container(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Center(child: child),
              if (showDivider) ...[
                const SizedBox(height: 28),
                const _GradientDivider(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientDivider extends StatefulWidget {
  const _GradientDivider();

  @override
  State<_GradientDivider> createState() => _GradientDividerState();
}

class _GradientDividerState extends State<_GradientDivider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

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
        return Container(
          height: 1.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _c.value * 2, 0),
              end: Alignment(1.0 + _c.value * 2, 0),
              colors: const [
                Colors.transparent,
                Color(0x66FFFFFF),
                Colors.transparent,
              ],
              stops: const [0.2, 0.5, 0.8],
            ),
          ),
        );
      },
    );
  }
}




class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurfaceMuted = Theme.of(context).colorScheme.onSurface.withOpacity(.70);
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (context, c) {
      final isWide = c.maxWidth > 900;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isWide ? 6 : 10,
            child: Column(
              crossAxisAlignment:
              isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
            Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: DS.divider),
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(DS.pill),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, size: 16),
            SizedBox(width: 6),
            Text('Open to Work', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .2,)),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: .15).scale(begin: const Offset(.98,.98)),
                const SizedBox(height: 18),
                Text(
                  ProfileConfig.name,
                  textAlign: isWide ? TextAlign.start : TextAlign.center,
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fadeIn(duration: 700.ms).slideY(begin: .15),
                const SizedBox(height: 6),
                Text(
                  ProfileConfig.title,
                  textAlign: isWide ? TextAlign.start : TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(.70),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ProfileConfig.tagline,
                  textAlign: isWide ? TextAlign.start : TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(.70),
                  ),
                ).animate().fadeIn(duration: 800.ms),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment:
                  isWide ? WrapAlignment.start : WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _launch('mailto:${ProfileConfig.email}'),
                      icon: const Icon(Icons.mail_outline),
                      label: const Text('Contact'),
                      // a11y:
                      autofocus: true,
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _launch(ProfileConfig.github),
                      icon: const Icon(Icons.code),
                      label: const Text('GitHub'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _launch(ProfileConfig.linkedin),
                      icon: const Icon(Icons.link),
                      label: const Text('LinkedIn'),
                    ),
                  ],
                ).animate().fadeIn(duration: 900.ms),
                const SizedBox(height: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place, size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(ProfileConfig.location,
                      style: theme.textTheme.titleMedium?.copyWith(color: onSurfaceMuted),),
                    const SizedBox(width: 18),
                    const Icon(Icons.phone, size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(ProfileConfig.phone,
                      style: theme.textTheme.titleMedium?.copyWith(color: onSurfaceMuted),),
                  ],
                ),
              ],
            ),
          ),
          if (isWide) const SizedBox(width: 28),
          if (isWide)
            Expanded(
              flex: 5,
              child: _HeroVisual().animate().fadeIn(duration: 800.ms),
            ),
        ],
      );
    });
  }
}

class _HeroVisual extends StatefulWidget {
  @override
  State<_HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<_HeroVisual> with TickerProviderStateMixin {
  late final AnimationController _c =
  AnimationController(vsync: this, duration: const Duration(seconds: 6))
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
      builder: (context, _) {
        final t = (_c.value - .5) * 2;
        return AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            children: [
              _tile(icon: Icons.smartphone, x: .05 + .02 * t, y: .06),
              _tile(icon: Icons.security, x: .62, y: .02 + .02 * -t),
              _tile(icon: Icons.code, x: .82 + .02 * -t, y: .24),
              _tile(icon: Icons.developer_mode, x: .12, y: .58 + .02 * t),
              _tile(icon: Icons.speed, x: .56 + .02 * t, y: .62),
              _tile(icon: Icons.network_check, x: .78, y: .72 + .02 * -t),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(.06),
                        Colors.white.withOpacity(.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Combining Mobile Development Expertise with Cybersecurity Skills',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Where Mobile Innovation Meets Cyber Defense',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tile({required IconData icon, required double x, required double y}) {
    return Positioned(
      left: x * 600,
      top: y * 450,
      child: Transform.scale(
        scale: 1.0,
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 34, color: Colors.white),
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}


class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurfaceMuted = Theme.of(context).colorScheme.onSurface.withOpacity(.70);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('about_title')),
        const SizedBox(height: 8),
        Text(
          "Motivated Mobile Developer and SOC Analyst passionate about Blue Team cybersecurity and building secure, user-friendly mobile applications. Skilled in mobile app development and security fundamentals, with a strong interest in defending networks against threats. Actively seeking a job opportunity to apply my skills and grow in both development and cybersecurity fields.",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _Pill(icon: Icons.integration_instructions, text: 'Clean, testable app architectures'),
            _Pill(icon: Icons.dataset, text: 'Data‑driven detections & dashboards'),
            _Pill(icon: Icons.device_hub, text: 'Network & endpoint triage'),
            _Pill(icon: Icons.lock_outline, text: 'Privacy by Design / Secure SDLC'),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}


class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(.3),
            ]),
          ),
        ),
      ],
    );
  }
}



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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('skills_title')),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            ChoiceChip(
              label: const Text('Mobile'),
              selected: _index == 0,
              onSelected: (_) => setState(() => _index = 0),
            ),
            ChoiceChip(
              label: const Text('SOC'),
              selected: _index == 1,
              onSelected: (_) => setState(() => _index = 1),
            ),
            ChoiceChip(
              label: const Text('Tools'),
              selected: _index == 2,
              onSelected: (_) => setState(() => _index = 2),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(
                sizeFactor: anim,
                axisAlignment: -1.0,
                child: child,
              ),
            ),
            child: _buildChips(_index),
          ),
        ),
      ],
    );
  }

  Widget _buildChips(int i) {
    final list = [
      ProfileConfig.mobileSkills,
      ProfileConfig.socSkills,
      ProfileConfig.toolSkills,
    ][i];
    return Wrap(
      key: ValueKey(i),
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        for (final s in list)
          Chip(
            label: Text(s),
          )
      ],
    );
  }
}


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
      final cross = w >= 1200 ? 3 : w >= 800 ? 2 : 1;
      final ratio = w >= 1200 ? 1.05 : w >= 800 ? 0.90 : 0.78;

      final projects = _filter == 'all'
          ? ProfileConfig.projects
          : ProfileConfig.projects.where((p) => p.category == _filter).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(I18n.t('projects_title')),
          const SizedBox(height: 8),
          Text('A mix of mobile apps and blue-team security work. More on my GitHub.',
             style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(label: const Text('All'), selected: _filter == 'all',
                onSelected: (_) => setState(() => _filter = 'all')),
              ChoiceChip(label: const Text('Mobile'), selected: _filter == 'mobile',
                onSelected: (_) => setState(() => _filter = 'mobile')),
              ChoiceChip(label: const Text('Security'), selected: _filter == 'security',
                onSelected: (_) => setState(() => _filter = 'security')),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cross,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AspectRatio(
          aspectRatio: 16 / 9,

          child: Stack(
            fit: StackFit.expand,
            children: [
              _netImage(widget.project.imageUrl, fit: BoxFit.cover),
              Positioned(
                left: 0, right: 0, bottom: 0,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.55),
                        borderRadius: BorderRadius.circular(DS.pill),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility, size: 16, color: Colors.white70),
                          SizedBox(width: 6),
                          Text('View', style: TextStyle(color: Colors.white70)),
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
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.06),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(widget.project.kind, style: const TextStyle(fontSize: 12)),
                  ),
                  const Spacer(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.project.tags.take(3).map((t) => Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Chip(
                          label: Text(t),
                          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                        ),
                      )).toList(),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Text(
                  widget.project.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.project.summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                Row(children: [
                  if (widget.project.github.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _launch(widget.project.github),
                      icon: const Icon(Icons.code),
                      label: const Text('Code'),
                    ),
                  if (widget.project.demo.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _launch(widget.project.demo),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Live'),
                    ),
                ]),
              ],
            ),
          ),
        ),
      ],
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
    ).then((_) {

            web.clearHash();
    });
  }
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('experience_title')),
        const SizedBox(height: 12),
        Column(
          children: [
            for (final e in ProfileConfig.experience) _ExperienceTile(item: e),
          ],
        )
      ],
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  final ExperienceItem item;
  const _ExperienceTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TimelineDot(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('${item.role} — ',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Text(item.period, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(item.org, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final b in item.bullets)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(child: Text(b)),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.indigo,
          ),
        ),
        Container(
          width: 2,
          height: 80,
          color: Colors.white12,
        )
      ],
    );
  }
}


class CertsSection extends StatelessWidget {
  const CertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final certs = ProfileConfig.certs;
    final w = MediaQuery.of(context).size.width;
    final cross = w > 1000 ? 3 : w > 700 ? 2 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('certs_title')),
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
  const _CertCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.indigo),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${c.issuer} · ${c.year}', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
              builder: (context, c) {
            final isWide = c.maxWidth > 880;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(I18n.t('contact_title')),
                const SizedBox(height: 8),
                Text('Email me or send a message — I’ll respond quickly.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 16),
                Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _ContactForm(),
                    ),
                    SizedBox(width: isWide ? 20 : 0, height: isWide ? 0 : 20),
                    Expanded(
                      child: _ContactSidebar(),
                    ),
                  ],
                ),
              ],
            );
          },
        );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
          Text('© ${DateTime.now().year} ${ProfileConfig.name}. All rights reserved.',
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}


Future<void> _launch(String url) async {
  final parsed = Uri.tryParse(url);
  if (parsed == null) return;

  if (!await launchUrl(parsed, mode: LaunchMode.externalApplication)) {
    await launchUrl(parsed, mode: LaunchMode.inAppWebView);
  }
}


class _ContactSidebar extends StatelessWidget {
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
            Row(
              children: [
                const Icon(Icons.place, size: 18, color: Colors.white70),
                const SizedBox(width: 6),
                Expanded(child: Text(ProfileConfig.location, style: const TextStyle(color: Colors.white70))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.white70),
                const SizedBox(width: 6),
                Expanded(child: Text(ProfileConfig.phone, style: const TextStyle(color: Colors.white70))),
              ],
            ),
          ],
        ),
      );
    }
}

class _ContactForm extends StatefulWidget {
    @override
    State<_ContactForm> createState() => _ContactFormState();
  }

class _ContactFormState extends State<_ContactForm> {
    final _formKey = GlobalKey<FormState>();
    final _name = TextEditingController();
    final _email = TextEditingController();
    final _subject = TextEditingController();
    final _message = TextEditingController();
    bool _sending = false;
    final _website = TextEditingController();

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
      if (_website.text.trim().isNotEmpty) {
        return;
      }
      if (ProfileConfig.contactEndpoint.contains('REPLACE_ME')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Set ProfileConfig.contactEndpoint to your Formspree URL.')),
        );
        return;
      }
      setState(() => _sending = true);
      try {
        final resp = await http.post(Uri.parse(ProfileConfig.contactEndpoint), headers: {
         'Accept': 'application/json',
        }, body: {
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'subject': _subject.text.trim(),
          'message': _message.text.trim(),
        });
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          _formKey.currentState?.reset();
          _name.clear(); _email.clear(); _subject.clear(); _message.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent ✅')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Send failed (${resp.statusCode})')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                  decoration: const InputDecoration(labelText: 'Website'),
                ),
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Your name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Your email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Valid email required',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subject,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _message,
                decoration: const InputDecoration(labelText: 'Message'),
                maxLines: 5,
                validator: (v) => v == null || v.trim().length < 10 ? 'Write a bit more (10+ chars)' : null,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: _sending ? null : _submit,
                  icon: _sending ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : const Icon(Icons.send),
                  label: Text(_sending ? 'Sending…' : 'Send Message'),
                ),
              )
            ],
          ),
        ),
      );
    }
}

class I18n {
  static String current = 'en';
  bool get isRTL => current == 'ar';
  static Locale get locale => Locale(current);

  static const Map<String, Map<String, String>> texts = {
    'en': {
      'about_title': 'About Me',
      'projects_title': 'Featured Projects',
      'skills_title': 'Skills',
      'experience_title': 'Experience',
      'education_title': 'Education',
      'certs_title': 'Certifications',
      'contact_title': 'Contact',
      'testimonials_title': 'Testimonials',
      'blog_title': 'Blog & Notes',
    },
    'fr': {
      'about_title': 'À propos de moi',
      'projects_title': 'Projets en vedette',
      'skills_title': 'Compétences',
      'experience_title': 'Expérience',
      'education_title': 'Éducation',
      'certs_title': 'Certifications',
      'contact_title': 'Contact',
      'testimonials_title': 'Témoignages',
      'blog_title': 'Articles & Notes',
    },
    'ar': {
      'about_title': 'نبذة عني',
      'projects_title': 'المشاريع',
      'skills_title': 'المهارات',
      'experience_title': 'الخبرات',
      'education_title': 'التعليم',
      'certs_title': 'الشهادات',
      'contact_title': 'تواصل معي',
      'testimonials_title': 'آراء العملاء',
      'blog_title': 'مقالات وملاحظات',
    }
  };

  static String t(String key) {
    return texts[current]?[key] ?? key;
  }
}

class _ProjectDetails extends StatefulWidget {
  final Project project;
  const _ProjectDetails({required this.project});

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
    analytics.trackEvent('Lightbox Open', {'project': widget.project.id, 'index': '$startIndex'});
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) => _ImageLightbox(
        images: images,
        initialIndex: startIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final images = (p.images.isNotEmpty) ? p.images : [p.imageUrl];

    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth > 860;
      final gallery = Column(
        children: [
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
          // page dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final active = i == _index;
              return InkWell(
                  onTap: () {
                    _page.animateToPage(i,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut);
                  },
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
        ],
      );

      final content = SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    p.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.06),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(p.kind, style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                  spacing: 10,
                  runSpacing: 2,
                  children: p.tags.take(10).map((t) =>
                      Chip(
                        label: Text(t),
                        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                      ),
                  ).toList(),
                ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(p.detail.isNotEmpty ? p.detail : p.summary,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
            const SizedBox(height: 12),
            if (p.highlights.isNotEmpty) ...[
              Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: p.highlights.map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(h)),
                    ],
                  ),
                )).toList(),
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 10,
              children: [
                if (p.github.isNotEmpty)
                  FilledButton.icon(
                    onPressed: () => _launch(p.github),
                    icon: const Icon(Icons.code),
                    label: const Text('Code'),
                  ),
                if (p.demo.isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: () => _launch(p.demo),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Live Demo'),
                  ),
              ],
            ),
          ],
        ),
      );

      return SizedBox(
        width: c.maxWidth,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: wide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: gallery)),
              const SizedBox(width: 16),
              Expanded(flex: 5, child: content),
            ],
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: gallery),
              content,
            ],
          ),
        ),
      );
    });
  }
}
class _ImageLightbox extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const _ImageLightbox({required this.images, this.initialIndex = 0});

  @override
  State<_ImageLightbox> createState() => _ImageLightboxState();
}

class _ImageLightboxState extends State<_ImageLightbox> {
  late final PageController _controller =
  PageController(initialPage: widget.initialIndex);
  int _index = 0;
  double _scale = 1.0;

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
      body: Stack(
        children: [
          // Images
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() { _index = i; _scale = 1.0; }),
            itemCount: imgs.length,
            itemBuilder: (_, i) => Center(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(40),
                minScale: 1,
                maxScale: 4,
                onInteractionEnd: (_) => setState(() {}),
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
              tooltip: 'Close',
            ),
          ),

          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      final p = (_index - 1).clamp(0, imgs.length - 1);
                      _controller.animateToPage(p,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      final n = (_index + 1).clamp(0, imgs.length - 1);
                      _controller.animateToPage(n,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Dots
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
        ],
      ),
    );
  }
}
Widget _netImage(String url, {BoxFit fit = BoxFit.cover, bool big = false}) {
  if (kIsWeb) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => const _ImgError(),
    );
  }
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (_, __) => Center(
      child: SizedBox(
        width: big ? 36 : 24,
        height: big ? 36 : 24,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
    errorWidget: (_, __, ___) => const _ImgError(),
  );
}

class _ImgError extends StatelessWidget {
  const _ImgError();
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black26,
    alignment: Alignment.center,
    child: const Icon(Icons.broken_image, size: 40, color: Colors.white54),
  );
}

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});
  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final _ctrl = PageController(viewportFraction: .86);
  int _index = 0;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final items = ProfileConfig.testimonials;
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('testimonials_title')),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 16/6,
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
                color: active ? Theme.of(context).colorScheme.primary : Colors.white24,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        )
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Testimonial t;
  const _TestimonialCard({required this.t});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(DS.radius),
        border: Border.all(color: DS.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(radius: 36, backgroundColor: Colors.white10),
              CircleAvatar(radius: 33, backgroundImage: NetworkImage(t.avatar)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.format_quote, color: theme.colorScheme.primary.withOpacity(.8), size: 20),
                    const SizedBox(width: 4),
                    Text('Testimonial', style: theme.textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(.70),
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('“${t.quote}”', style: theme.textTheme.titleMedium?.copyWith(height: 1.35)),
                const SizedBox(height: 8),
                Text('${t.name} · ${t.role}', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
    return card.animate().fadeIn(duration: 300.ms).slideY(begin: .1);
  }
}

class Testimonial {
  final String quote;
  final String name;
  final String role;
  final String avatar;
  const Testimonial({required this.quote, required this.name, required this.role, required this.avatar});
}

class BlogPost {
  final String title;
  final String summary;
  final String date;
  final String url;
  const BlogPost({
    required this.title,
    required this.summary,
    required this.date,
    required this.url,
  });
}

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = ProfileConfig.posts;
    if (posts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(I18n.t('blog_title')),
        const SizedBox(height: 16),
        Column(
          children: posts.map((p) => _BlogCard(post: p)).toList(),
        ),
      ],
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogPost post;
  const _BlogCard({required this.post});
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {}, onExit: (_) {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DS.radius),
          border: Border.all(color: DS.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.06),
                    borderRadius: BorderRadius.circular(DS.pill),
                  ),
                  child: Text(post.date, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(post.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(post.summary, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => launchUrl(Uri.parse(post.url)),
                icon: const Icon(Icons.north_east, size: 16),
                label: const Text("Read"),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 250.ms).slideY(begin: .1),
    );
  }
}

class DS {
  static const radius = 16.0;
  static const pill = 999.0;


  static const surfaceGlass = Color(0x0FFFFFFF);
  static const divider = Color(0x1AFFFFFF);

  static List<BoxShadow> shadowSoft(BuildContext c) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 18,
      spreadRadius: 0,
      offset: const Offset(0, 10),
    ),
  ];
}


class ParallaxOrbs extends StatelessWidget {
  final ScrollController controller;
  final bool isDark;
  const ParallaxOrbs({super.key, required this.controller, required this.isDark});

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


            final a = o * 0.06;
            final b = o * 0.03;
            final c = o * 0.045;

            return Stack(
              children: [
                _orb(
                  left: -140 + b,
                  top: -120 + b * 0.5,
                  size: 360,
                  color: baseA.withOpacity(0.22),
                ),
                _orb(
                  right: -120 - a,
                  top: 220 - a * 0.8,
                  size: 300,
                  color: baseB.withOpacity(0.18),
                ),
                _orb(
                  left: -80 + c * 0.6,
                  bottom: -100 + c,
                  size: 420,
                  color: baseC.withOpacity(0.16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _orb({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
  }) {
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

          gradient: RadialGradient(
            colors: [color, color.withOpacity(0.0)],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}

class EducationSection extends StatelessWidget {
  final List<Education> educationList;

  const EducationSection({super.key, required this.educationList});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(I18n.t('education_title')),
            const SizedBox(height: 24),
            Column(
              children: educationList.map((e) => _EducationTile(e)).toList(),
            ),
            const SizedBox(height: 24),
            const Divider(color: DS.divider, height: 1),
          ],
    );
  }
}

class _EducationTile extends StatelessWidget {
  final Education edu;
  const _EducationTile(this.edu);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Icon(Icons.school, color: Colors.white70, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu.degree,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${edu.institution} • ${edu.years}",
                  style: const TextStyle(color: Colors.white70),
                ),
                if (edu.details != null)
                  Text(
                    edu.details!,
                    style: const TextStyle(color: Colors.white54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Education {
  final String degree;
  final String institution;
  final String years;
  final String? details;

  Education({
    required this.degree,
    required this.institution,
    required this.years,
    this.details,
  });
}
