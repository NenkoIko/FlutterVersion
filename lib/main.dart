import 'package:flutter/material.dart';

void main() {
  runApp(const ChurchApp());
}

const _green = Color(0xFF168347);
const _ink = Color(0xFF17251D);
const _muted = Color(0xFF6B7B71);
const _canvas = Color(0xFFF5F8F5);

class ChurchApp extends StatelessWidget {
  const ChurchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcclSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _green,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _canvas,
          foregroundColor: _ink,
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE3EBE5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE3EBE5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _green, width: 1.5),
          ),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}

class DemoAccount {
  const DemoAccount({
    required this.name,
    required this.role,
    required this.email,
    required this.password,
  });

  final String name;
  final String role;
  final String email;
  final String password;

  SessionUser get session => SessionUser(
        id: email,
        name: name,
        email: email,
        role: role,
      );

  static const accounts = [
    DemoAccount(
      name: 'Alex Morgan',
      role: 'Admin',
      email: 'admin@ecclsync.demo',
      password: 'Admin123!',
    ),
    DemoAccount(
      name: 'Angela Cruz',
      role: 'Ministry Leader',
      email: 'leader@ecclsync.demo',
      password: 'Leader123!',
    ),
    DemoAccount(
      name: 'Maria Santos',
      role: 'Member',
      email: 'member@ecclsync.demo',
      password: 'Member123!',
    ),
  ];
}

class SessionUser {
  const SessionUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String role;
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectAccount(DemoAccount account) {
    setState(() {
      _emailController.text = account.email;
      _passwordController.text = account.password;
      _error = null;
    });
  }

  void _signIn() {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    DemoAccount? account;
    for (final candidate in DemoAccount.accounts) {
      if (candidate.email == email && candidate.password == password) {
        account = candidate;
        break;
      }
    }

    final signedInAccount = account;
    if (signedInAccount == null) {
      setState(
          () => _error = 'Choose a demo account or check the credentials.');
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ChurchHome(
          store: ChurchStore(),
          account: signedInAccount.session,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Image.asset(
                        'assets/church-logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Welcome to EcclSync',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in with a built-in test account to preview each role.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeading(title: 'Test accounts'),
                  const SizedBox(height: 8),
                  ...DemoAccount.accounts.map(
                    (account) => Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () => _selectAccount(account),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE5F4EA),
                          child: Icon(Icons.person_rounded, color: _green),
                        ),
                        title: Text(
                          account.role,
                          style: const TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          '${account.email}\nPassword: ${account.password}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: _muted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onSubmitted: (_) => _signIn(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _signIn,
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Sign in to demo'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _green,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'These sample accounts are for role previews only. Nothing is saved, and they do not grant real permissions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChurchItem {
  ChurchItem({
    required this.title,
    required this.subtitle,
    this.details = '',
    this.count = 0,
    this.joined = false,
    this.supported = false,
    this.read = true,
  });

  final String title;
  final String subtitle;
  final String details;
  int count;
  bool joined;
  bool supported;
  bool read;
}

class ChurchModule {
  const ChurchModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<ChurchItem> items;
}

class ChurchStore extends ChangeNotifier {
  ChurchStore()
      : modules = [
          ChurchModule(
            id: 'events',
            title: 'Events',
            description: 'Gatherings and upcoming activities',
            icon: Icons.event_rounded,
            items: [
              ChurchItem(
                title: 'Sunday Worship Service',
                subtitle: 'Sunday, 9:00 AM · Main Sanctuary',
                details: 'Join us for worship, prayer, and fellowship.',
                count: 42,
              ),
              ChurchItem(
                title: 'Community Outreach',
                subtitle: 'Saturday, 10:00 AM · Church Hall',
                details: 'Help prepare care packages for our neighbors.',
                count: 18,
              ),
              ChurchItem(
                title: 'Youth Fellowship',
                subtitle: 'Friday, 6:30 PM · Youth Center',
                details: 'An evening of music, discussion, and games.',
                count: 24,
              ),
            ],
          ),
          ChurchModule(
            id: 'prayers',
            title: 'Prayer Requests',
            description: 'Share a request and support one another',
            icon: Icons.volunteer_activism_rounded,
            items: [
              ChurchItem(
                title: 'Strength for a new season',
                subtitle: 'Shared by Maria · Today',
                details:
                    'Please pray for peace and guidance during a new season.',
                count: 12,
              ),
              ChurchItem(
                title: 'Healing and recovery',
                subtitle: 'Shared by Daniel · Yesterday',
                details: 'Prayers for a family member recovering from surgery.',
                count: 8,
              ),
            ],
          ),
          ChurchModule(
            id: 'bible',
            title: 'E-Bible',
            description: 'Scripture and a daily reflection',
            icon: Icons.menu_book_rounded,
            items: [
              ChurchItem(
                title: 'Psalm 118:24',
                subtitle: 'Today’s verse',
                details:
                    'This is the day that the Lord has made; let us rejoice and be glad in it.',
              ),
              ChurchItem(
                title: 'Proverbs 3:5–6',
                subtitle: 'Trust and guidance',
                details:
                    'Trust in the Lord with all your heart, and do not lean on your own understanding.',
              ),
              ChurchItem(
                title: 'Philippians 4:13',
                subtitle: 'Strength in Christ',
                details: 'I can do all things through him who strengthens me.',
              ),
            ],
          ),
          ChurchModule(
            id: 'members',
            title: 'Members',
            description: 'Find people in your church community',
            icon: Icons.groups_rounded,
            items: [
              ChurchItem(
                title: 'Maria Santos',
                subtitle: 'Worship Ministry · Member',
                details: 'Serving in the worship ministry.',
              ),
              ChurchItem(
                title: 'Daniel Reyes',
                subtitle: 'Community Outreach · Member',
                details: 'Serving in community outreach.',
              ),
              ChurchItem(
                title: 'Angela Cruz',
                subtitle: 'Youth Ministry · Ministry Leader',
                details: 'Youth ministry leader.',
              ),
            ],
          ),
          ChurchModule(
            id: 'ministries',
            title: 'Ministries',
            description: 'Discover ways to get involved',
            icon: Icons.favorite_rounded,
            items: [
              ChurchItem(
                title: 'Worship Ministry',
                subtitle: 'Music · 18 members',
                details: 'Serving through music and congregational worship.',
              ),
              ChurchItem(
                title: 'Community Outreach',
                subtitle: 'Service · 24 members',
                details: 'Supporting neighbors through practical care.',
              ),
              ChurchItem(
                title: 'Youth Ministry',
                subtitle: 'Next generation · 15 members',
                details: 'Helping young people grow in faith and community.',
              ),
            ],
          ),
          ChurchModule(
            id: 'announcements',
            title: 'Announcements',
            description: 'News and updates from the church',
            icon: Icons.campaign_rounded,
            items: [
              ChurchItem(
                title: 'Welcome to our new members',
                subtitle: 'Church Office · Today',
                details: 'Please join us in welcoming new members this Sunday.',
                read: false,
              ),
              ChurchItem(
                title: 'Community pantry collection',
                subtitle: 'Outreach Team · Monday',
                details: 'Non-perishable food donations are welcome this week.',
                read: false,
              ),
              ChurchItem(
                title: 'Choir practice schedule',
                subtitle: 'Worship Team · October 10',
                details: 'Choir practice will be held Wednesday at 7:00 PM.',
              ),
            ],
          ),
          ChurchModule(
            id: 'attendance',
            title: 'Attendance',
            description: 'A simple overview of recent gatherings',
            icon: Icons.fact_check_rounded,
            items: [
              ChurchItem(
                title: 'Sunday Worship',
                subtitle: 'October 11 · 86 attendees',
                details: 'Attendance recorded for the Sunday worship service.',
              ),
              ChurchItem(
                title: 'Youth Fellowship',
                subtitle: 'October 9 · 24 attendees',
                details: 'Attendance recorded for youth fellowship.',
              ),
            ],
          ),
          ChurchModule(
            id: 'finance',
            title: 'Giving',
            description: 'A sample view of community giving',
            icon: Icons.volunteer_activism_outlined,
            items: [
              ChurchItem(
                title: 'Community Care Fund',
                subtitle: 'This month · \$1,240',
                details:
                    'Local demo summary. No payment processing is enabled.',
              ),
              ChurchItem(
                title: 'Building Fund',
                subtitle: 'This month · \$860',
                details:
                    'Local demo summary. No payment processing is enabled.',
              ),
            ],
          ),
          ChurchModule(
            id: 'inventory',
            title: 'Inventory',
            description: 'Shared equipment and supplies',
            icon: Icons.inventory_2_rounded,
            items: [
              ChurchItem(
                title: 'Folding chairs',
                subtitle: 'Available · 36 units',
                details: 'Stored in the main hall.',
              ),
              ChurchItem(
                title: 'Wireless microphones',
                subtitle: 'In use · 4 units',
                details: 'Audio equipment managed by the worship team.',
              ),
            ],
          ),
          ChurchModule(
            id: 'advising',
            title: 'Ministry Advising',
            description: 'Guidance and support requests',
            icon: Icons.support_agent_rounded,
            items: [
              ChurchItem(
                title: 'Planning a neighborhood visit',
                subtitle: 'Community Outreach · Open',
                details:
                    'Request for guidance on an upcoming neighborhood visit.',
              ),
            ],
          ),
          ChurchModule(
            id: 'archives',
            title: 'Archives',
            description: 'Past events and community highlights',
            icon: Icons.archive_rounded,
            items: [
              ChurchItem(
                title: 'Harvest Thanksgiving',
                subtitle: 'September 20 · Event',
                details:
                    'Photos and notes from the community thanksgiving gathering.',
              ),
              ChurchItem(
                title: 'Summer outreach',
                subtitle: 'August 8 · Ministry',
                details: 'A look back at this summer’s outreach activities.',
              ),
            ],
          ),
          ChurchModule(
            id: 'analytics',
            title: 'Community Insights',
            description: 'Sample participation overview',
            icon: Icons.insights_rounded,
            items: [
              ChurchItem(
                title: 'Weekly gathering',
                subtitle: '86 participants',
                details: 'A sample local overview for demonstration only.',
              ),
              ChurchItem(
                title: 'Active ministries',
                subtitle: '6 groups',
                details: 'A sample local overview for demonstration only.',
              ),
            ],
          ),
          ChurchModule(
            id: 'chat',
            title: 'Church Chat',
            description: 'A local sample conversation',
            icon: Icons.chat_bubble_rounded,
            items: [
              ChurchItem(
                title: 'Worship Team',
                subtitle: 'Practice starts at 7 tonight.',
                details: 'Practice starts at 7 tonight.',
              ),
              ChurchItem(
                title: 'Community Group',
                subtitle: 'Thanks, everyone, for helping out!',
                details: 'Thanks, everyone, for helping out!',
              ),
            ],
          ),
          ChurchModule(
            id: 'notifications',
            title: 'Notifications',
            description: 'Recent community updates',
            icon: Icons.notifications_rounded,
            items: [
              ChurchItem(
                title: 'New announcement',
                subtitle: 'Welcome to our new members',
                details: 'A new church announcement is available.',
                read: false,
              ),
              ChurchItem(
                title: 'Upcoming event',
                subtitle: 'Community Outreach · Saturday',
                details: 'Community Outreach is coming up this Saturday.',
                read: false,
              ),
            ],
          ),
        ];

  final List<ChurchModule> modules;

  ChurchModule module(String id) =>
      modules.firstWhere((module) => module.id == id);

  void toggleRsvp(ChurchItem item) {
    item.joined = !item.joined;
    item.count += item.joined ? 1 : -1;
    notifyListeners();
  }

  void addPrayer(String title, String details) {
    module('prayers').items.insert(
          0,
          ChurchItem(
            title: title,
            subtitle: 'Shared by You · Just now',
            details: details,
          ),
        );
    notifyListeners();
  }

  void supportPrayer(ChurchItem item) {
    item.supported = !item.supported;
    item.count += item.supported ? 1 : -1;
    notifyListeners();
  }

  void markRead(ChurchItem item) {
    item.read = true;
    notifyListeners();
  }

  void sendMessage(String message) {
    module('chat').items.insert(
          0,
          ChurchItem(
            title: 'You',
            subtitle: message,
            details: message,
          ),
        );
    notifyListeners();
  }
}

class ChurchHome extends StatefulWidget {
  const ChurchHome({
    required this.store,
    required this.account,
    super.key,
  });

  final ChurchStore store;
  final SessionUser account;

  @override
  State<ChurchHome> createState() => _ChurchHomeState();
}

class _ChurchHomeState extends State<ChurchHome> {
  int _selectedTab = 0;

  void _openModule(ChurchModule module) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ModulePage(module: module, store: widget.store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(
        store: widget.store,
        account: widget.account,
        onOpenModule: _openModule,
      ),
      ExploreTab(store: widget.store, onOpenModule: _openModule),
      ProfileTab(account: widget.account),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedTab, children: tabs),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    required this.store,
    required this.account,
    required this.onOpenModule,
    super.key,
  });

  final ChurchStore store;
  final SessionUser account;
  final ValueChanged<ChurchModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final events = store.module('events').items;
        final prayers = store.module('prayers').items;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good day, ${account.name.split(' ').first}',
                        style: TextStyle(color: _muted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome back',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: _ink,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Notifications',
                  onPressed: () => onOpenModule(store.module('notifications')),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [_green, Color(0xFF35A968)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'VERSE OF THE DAY',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Text(
                    '“This is the day that the Lord has made; let us rejoice and be glad in it.”',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Psalm 118:24',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeading(title: 'Your community'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Upcoming events',
                    value: '${events.length}',
                    icon: Icons.event_available_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Prayer requests',
                    value: '${prayers.length}',
                    icon: Icons.favorite_border_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SectionHeading(
              title: 'Coming up',
              actionLabel: 'See all',
              onAction: () => onOpenModule(store.module('events')),
            ),
            const SizedBox(height: 10),
            ...events.take(2).map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ItemCard(
                      item: event,
                      icon: Icons.event_rounded,
                      onTap: () => _showItem(context, event),
                    ),
                  ),
                ),
            const SizedBox(height: 12),
            const SectionHeading(title: 'Quick access'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['prayers', 'bible', 'members', 'announcements']
                  .map(store.module)
                  .map(
                    (module) => ActionChip(
                      avatar: Icon(module.icon, color: _green, size: 18),
                      label: Text(module.title),
                      onPressed: () => onOpenModule(module),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE3EBE5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class ExploreTab extends StatelessWidget {
  const ExploreTab({
    required this.store,
    required this.onOpenModule,
    super.key,
  });

  final ChurchStore store;
  final ValueChanged<ChurchModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text(
          'Explore',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _ink,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Everything happening in your church community.',
          style: TextStyle(color: _muted),
        ),
        const SizedBox(height: 20),
        ...store.modules.map(
          (module) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ModuleTile(
              module: module,
              onTap: () => onOpenModule(module),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({required this.account, super.key});

  final SessionUser account;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _ink,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 20),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE5F4EA),
                  child: Icon(Icons.person_rounded, color: _green, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.role,
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                      Text(
                        account.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'About demo',
                  onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: 'EcclSync',
                    applicationVersion: '1.0.0',
                    children: const [
                      Text(
                        'This demo uses sample content stored only in memory. No account or database is connected.',
                      ),
                    ],
                  ),
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.shield_outlined, color: _green),
            title: Text('Privacy'),
            subtitle: Text('No sign-in, server, or database is used.'),
          ),
        ),
      ],
    );
  }
}

class ModulePage extends StatefulWidget {
  const ModulePage({required this.module, required this.store, super.key});

  final ChurchModule module;
  final ChurchStore store;

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  final _searchController = TextEditingController();
  final _messageController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _addPrayer() async {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Share a prayer request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Short title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: detailsController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Request details'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              final details = detailsController.text.trim();
              if (title.isNotEmpty && details.isNotEmpty) {
                Navigator.pop(dialogContext, (title, details));
              }
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
    titleController.dispose();
    detailsController.dispose();
    if (result != null) widget.store.addPrayer(result.$1, result.$2);
  }

  void _showDetails(ChurchItem item) {
    if (widget.module.id == 'notifications') widget.store.markRead(item);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(item.title),
        content: Text(item.details.isEmpty ? item.subtitle : item.details),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    final searchable = const {
      'members',
      'ministries',
      'announcements',
      'archives',
      'events',
    }.contains(module.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
        actions: [
          if (module.id == 'prayers')
            IconButton(
              tooltip: 'Add prayer request',
              onPressed: _addPrayer,
              icon: const Icon(Icons.add_rounded),
            ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) {
          final query = _query.toLowerCase();
          final items = module.items.where((item) {
            return item.title.toLowerCase().contains(query) ||
                item.subtitle.toLowerCase().contains(query);
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    module.description,
                    style: const TextStyle(color: _muted),
                  ),
                ),
              ),
              if (searchable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value.trim()),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
              if (module.id == 'bible') _VerseHighlight(module: module),
              Expanded(
                child: module.id == 'chat'
                    ? _buildChat(items)
                    : items.isEmpty
                        ? const Center(child: Text('No matching items'))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) => _moduleItem(
                              module,
                              items[index],
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _moduleItem(ChurchModule module, ChurchItem item) {
    final isEvent = module.id == 'events';
    final isPrayer = module.id == 'prayers';
    final isNotification = module.id == 'notifications';
    return ItemCard(
      item: item,
      icon: module.icon,
      onTap: () => _showDetails(item),
      trailing: isEvent
          ? TextButton(
              onPressed: () => widget.store.toggleRsvp(item),
              child: Text(item.joined ? 'Going' : 'Join'),
            )
          : isPrayer
              ? TextButton.icon(
                  onPressed: () => widget.store.supportPrayer(item),
                  icon: Icon(
                    item.supported
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 17,
                  ),
                  label: Text('${item.count}'),
                )
              : isNotification
                  ? Icon(
                      item.read
                          ? Icons.check_circle_outline_rounded
                          : Icons.circle,
                      color: item.read ? _muted : _green,
                      size: item.read ? 20 : 10,
                    )
                  : null,
    );
  }

  Widget _buildChat(List<ChurchItem> items) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isMine = item.title == 'You';
              return Align(
                alignment:
                    isMine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: isMine ? const Color(0xFFE5F4EA) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _green,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(item.subtitle, style: const TextStyle(color: _ink)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration:
                        const InputDecoration(hintText: 'Write a message'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    widget.store.sendMessage(text);
    _messageController.clear();
  }
}

class _VerseHighlight extends StatelessWidget {
  const _VerseHighlight({required this.module});

  final ChurchModule module;

  @override
  Widget build(BuildContext context) {
    final verse = module.items.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFE5F4EA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verse.title,
              style: const TextStyle(
                color: _green,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              verse.details,
              style: const TextStyle(color: _ink, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleTile extends StatelessWidget {
  const ModuleTile({required this.module, required this.onTap, super.key});

  final ChurchModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5ED),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(module.icon, color: _green),
        ),
        title: Text(
          module.title,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(module.description),
        trailing: const Icon(Icons.chevron_right_rounded, color: _muted),
        onTap: onTap,
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.icon,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final ChurchItem item;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5ED),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: _green, size: 21),
        ),
        title: Text(
          item.title,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(item.subtitle, maxLines: 2),
        ),
        trailing: trailing,
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _green, size: 21),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: _ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

void _showItem(BuildContext context, ChurchItem item) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(item.title),
      content: Text(item.details.isEmpty ? item.subtitle : item.details),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
