import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    SemanticsBinding.instance.ensureSemantics();
  }
  runApp(const IgrejaEmCelulaApp());
}

class AppTheme {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color contrastingTextColor(Color bg) {
    return bg.computeLuminance() > 0.42
        ? const Color(0xFF111827)
        : const Color(0xFFFFFFFF);
  }

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
      );
}

class IgrejaEmCelulaApp extends StatefulWidget {
  const IgrejaEmCelulaApp({super.key});

  @override
  State<IgrejaEmCelulaApp> createState() => _IgrejaEmCelulaAppState();
}

class _IgrejaEmCelulaAppState extends State<IgrejaEmCelulaApp> {
  bool _isLinkedToChurch = false;
  ThemeMode _themeMode = ThemeMode.dark;
  String _selectedChurchName = 'Igreja Batista em Células';

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igreja em Célula',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      builder: (context, child) {
        return Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF000000)
              : const Color(0xFFF3F4F6),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
      home: _isLinkedToChurch
          ? MainShellScreen(
              churchName: _selectedChurchName,
              onToggleTheme: _toggleTheme,
              onSwitchChurch: () => setState(() => _isLinkedToChurch = false),
            )
          : ChurchLinkScreen(
              onLinkCompleted: (churchName) {
                setState(() {
                  _selectedChurchName = churchName;
                  _isLinkedToChurch = true;
                });
              },
            ),
    );
  }
}

class ChurchLinkScreen extends StatefulWidget {
  final ValueChanged<String> onLinkCompleted;

  const ChurchLinkScreen({super.key, required this.onLinkCompleted});

  @override
  State<ChurchLinkScreen> createState() => _ChurchLinkScreenState();
}

class _ChurchLinkScreenState extends State<ChurchLinkScreen> {
  final _usernameController = TextEditingController(text: 'lider_lucas');
  String _selectedChurch = 'Igreja Batista em Células (@ibcelulas)';
  String? _selectedNetwork = 'net-jovens';
  String? _selectedCell = 'cell-betel';
  bool _hasNoCellYet = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(header: true, child: const Text('Entrar • Igreja em Célula')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.church_outlined, size: 52, color: Color(0xFF3B82F6)),
            const SizedBox(height: 12),
            Text(
              'Conecte-se à sua Igreja',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'O aplicativo é aberto, mas você verá apenas as publicações, redes e células da igreja em que estiver vinculado.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Seu @username (Estilo Instagram)',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedChurch,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: '1. Escolha sua Igreja (Isolamento Multi-Tenant)',
                prefixIcon: Icon(Icons.church),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Igreja Batista em Células (@ibcelulas)',
                  child: Text('Igreja Batista em Células (@ibcelulas)'),
                ),
                DropdownMenuItem(
                  value: 'Comunidade Videira (@videiracelulas)',
                  child: Text('Comunidade Videira (@videiracelulas)'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedChurch = val);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedNetwork,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: '2. Qual é a sua Rede?',
                prefixIcon: Icon(Icons.hub_outlined),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'net-jovens', child: Text('Rede Jovem (Azul)')),
                DropdownMenuItem(value: 'net-casais', child: Text('Rede de Casais (Verde)')),
                DropdownMenuItem(value: 'net-mulheres', child: Text('Rede de Mulheres (Rosa)')),
              ],
              onChanged: (val) => setState(() => _selectedNetwork = val),
            ),
            const SizedBox(height: 16),
            if (!_hasNoCellYet)
              DropdownButtonFormField<String>(
                value: _selectedCell,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: '3. Qual é a sua Célula?',
                  prefixIcon: Icon(Icons.groups_outlined),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'cell-betel', child: Text('Célula Betel (Quarta 20h)')),
                  DropdownMenuItem(value: 'cell-koinonia', child: Text('Célula Koinonia (Quinta 19h30)')),
                ],
                onChanged: (val) => setState(() => _selectedCell = val),
              ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sou visitante / Ainda não tenho célula'),
              value: _hasNoCellYet,
              onChanged: (val) => setState(() => _hasNoCellYet = val ?? false),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              onPressed: () => widget.onLinkCompleted(_selectedChurch.split(' (').first),
              icon: const Icon(Icons.login),
              label: const Text('Acessar Feed da Minha Igreja'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  final String churchName;
  final VoidCallback onToggleTheme;
  final VoidCallback onSwitchChurch;

  const MainShellScreen({
    super.key,
    required this.churchName,
    required this.onToggleTheme,
    required this.onSwitchChurch,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'lider_lucas',
      'networkName': 'Rede Jovem',
      'networkColor': '#2563EB',
      'cellName': 'Célula Betel',
      'caption': 'Que noite incrível na Célula Betel! Tivemos 3 visitantes e estudamos sobre Comunhão em Atos 2. 🔥🙌',
      'likes': 42,
      'comments': 8,
      'liked': true,
      'isCellReport': true,
      'timeAgo': 'Há 2 horas',
    },
    {
      'username': 'casal_rocha',
      'networkName': 'Rede Casais',
      'networkColor': '#059669',
      'cellName': 'Célula Aliança',
      'caption': 'Comunhão dos casais hoje após a palavra! Família é projeto de Deus.',
      'likes': 67,
      'comments': 14,
      'liked': false,
      'isCellReport': true,
      'timeAgo': 'Há 5 horas',
    },
  ];

  void _addNewPostFromCellReport(String caption, int visitors) {
    setState(() {
      _posts.insert(0, {
        'username': 'lider_lucas',
        'networkName': 'Rede Jovem',
        'networkColor': '#2563EB',
        'cellName': 'Célula Betel',
        'caption': '$caption (Visitantes hoje: $visitors)',
        'likes': 1,
        'comments': 0,
        'liked': true,
        'isCellReport': true,
        'timeAgo': 'Agora mesmo',
      });
      _currentIndex = 0;
    });
  }

  void _openReportModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CellReportSheet(
        onPublishReport: _addNewPostFromCellReport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeedView(
        churchName: widget.churchName,
        posts: _posts,
        onToggleTheme: widget.onToggleTheme,
        onLikeToggle: (index) {
          setState(() {
            final liked = _posts[index]['liked'] as bool;
            _posts[index]['liked'] = !liked;
            _posts[index]['likes'] += liked ? -1 : 1;
          });
        },
      ),
      const ExploreCellsView(),
      const SizedBox.shrink(),
      MyCellView(onOpenReport: _openReportModal),
      MemberProfileView(
        churchName: widget.churchName,
        onSwitchChurch: widget.onSwitchChurch,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            _openReportModal();
            return;
          }
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), label: 'Postar'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Célula'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class HomeFeedView extends StatefulWidget {
  final String churchName;
  final List<Map<String, dynamic>> posts;
  final VoidCallback onToggleTheme;
  final ValueChanged<int> onLikeToggle;

  const HomeFeedView({
    super.key,
    required this.churchName,
    required this.posts,
    required this.onToggleTheme,
    required this.onLikeToggle,
  });

  @override
  State<HomeFeedView> createState() => _HomeFeedViewState();
}

class _HomeFeedViewState extends State<HomeFeedView> {
  String _scope = 'ALL';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final stories = [
      {'title': 'Igreja', 'color': '#D97706', 'icon': Icons.church},
      {'title': 'Rede Jovem', 'color': '#2563EB', 'icon': Icons.bolt},
      {'title': 'Célula Betel', 'color': '#2563EB', 'icon': Icons.groups},
      {'title': 'Rede Casais', 'color': '#059669', 'icon': Icons.favorite},
      {'title': 'Rede Mulheres', 'color': '#DB2777', 'icon': Icons.auto_awesome},
    ];

    final filteredPosts = widget.posts.where((p) {
      if (_scope == 'NETWORK') return p['networkName'] == 'Rede Jovem';
      if (_scope == 'CELL') return p['cellName'] == 'Célula Betel';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.verified, color: Color(0xFF3B82F6), size: 20),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.churchName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            tooltip: 'Alternar tema Claro/Escuro',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Abrir Painel Pastoral da Igreja',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PastoralDashboardView()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: stories.map((s) {
                final color = AppTheme.fromHex(s['color'] as String);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          child: Icon(s['icon'] as IconData),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(s['title'] as String, style: textTheme.labelSmall),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Toda a Igreja'),
                  selected: _scope == 'ALL',
                  onSelected: (_) => setState(() => _scope = 'ALL'),
                ),
                ChoiceChip(
                  label: const Text('Minha Rede'),
                  selected: _scope == 'NETWORK',
                  onSelected: (_) => setState(() => _scope = 'NETWORK'),
                ),
                ChoiceChip(
                  label: const Text('Minha Célula'),
                  selected: _scope == 'CELL',
                  onSelected: (_) => setState(() => _scope = 'CELL'),
                ),
              ],
            ),
          ),
          ...List.generate(filteredPosts.length, (index) {
            final post = filteredPosts[index];
            final netColor = AppTheme.fromHex(post['networkColor'] as String);
            final badgeText = AppTheme.contrastingTextColor(netColor);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: netColor,
                        child: Text(
                          (post['username'] as String)[0].toUpperCase(),
                          style: TextStyle(color: badgeText, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('@${post['username']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                if (post['isCellReport'] == true) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, size: 16, color: Colors.blue),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: netColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    post['networkName'] as String,
                                    style: TextStyle(color: badgeText, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('• ${post['cellName']}', style: textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [netColor.withValues(alpha: 0.8), Colors.black87],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.groups, size: 64, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          '${post['cellName']} • ${post['networkName']}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post['liked'] == true ? Icons.favorite : Icons.favorite_border,
                        color: post['liked'] == true ? Colors.red : null,
                      ),
                      tooltip: 'Curtir publicação',
                      onPressed: () => widget.onLikeToggle(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined),
                      tooltip: 'Comentar',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.volunteer_activism_outlined),
                      tooltip: 'Orar pela célula',
                      onPressed: () {},
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${post['likes']} curtidas', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('@${post['username']} ${post['caption']}'),
                      const SizedBox(height: 4),
                      Text(post['timeAgo'] as String, style: textTheme.bodySmall),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class ExploreCellsView extends StatefulWidget {
  const ExploreCellsView({super.key});

  @override
  State<ExploreCellsView> createState() => _ExploreCellsViewState();
}

class _ExploreCellsViewState extends State<ExploreCellsView> {
  String? _selectedNetwork;
  final Set<String> _requestedCells = {};

  @override
  Widget build(BuildContext context) {
    final cells = [
      {'id': 'c1', 'name': 'Célula Betel', 'net': 'Rede Jovem', 'color': '#2563EB', 'dist': '0.8 km', 'day': 'Quarta às 20h • Centro'},
      {'id': 'c2', 'name': 'Célula Aliança', 'net': 'Rede Casais', 'color': '#059669', 'dist': '1.5 km', 'day': 'Quinta às 20h • Jardim'},
      {'id': 'c3', 'name': 'Célula Ester', 'net': 'Rede Mulheres', 'color': '#DB2777', 'dist': '2.3 km', 'day': 'Terça às 19h30 • Bela Vista'},
    ].where((c) => _selectedNetwork == null || c['net'] == _selectedNetwork).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar Redes e Células')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Rede Jovem', 'Rede Casais', 'Rede Mulheres'].map((net) {
              final selected = _selectedNetwork == net;
              return FilterChip(
                label: Text(net),
                selected: selected,
                onSelected: (_) => setState(() => _selectedNetwork = selected ? null : net),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ...cells.map((c) {
            final color = AppTheme.fromHex(c['color']!);
            final badgeText = AppTheme.contrastingTextColor(color);
            final requested = _requestedCells.contains(c['id']);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                          child: Text(c['net']!, style: TextStyle(color: badgeText, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Text('📍 ${c['dist']} de você', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(c['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(c['day']!),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        onPressed: requested ? null : () => setState(() => _requestedCells.add(c['id']!)),
                        icon: Icon(requested ? Icons.check : Icons.waving_hand_outlined),
                        label: Text(requested ? 'Solicitação enviada ao Líder!' : 'Quero visitar esta Célula'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class MyCellView extends StatefulWidget {
  final VoidCallback onOpenReport;

  const MyCellView({super.key, required this.onOpenReport});

  @override
  State<MyCellView> createState() => _MyCellViewState();
}

class _MyCellViewState extends State<MyCellView> {
  int _prayingCount = 12;
  bool _prayed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Célula • Betel')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onOpenReport,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Relatório + Foto no Feed'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Palavra da Semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('Tema: "O Poder da Comunhão na Igreja em Células" (Atos 2:42-47)'),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: widget.onOpenReport,
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('Fazer Chamada e Postar Foto da Célula'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Mural de Oração da Célula', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Mariana Silva'),
              subtitle: const Text('Orem pela saúde da minha família nesta semana.'),
              trailing: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _prayed = !_prayed;
                    _prayingCount += _prayed ? 1 : -1;
                  });
                },
                icon: Icon(_prayed ? Icons.favorite : Icons.volunteer_activism_outlined),
                label: Text('Orando ($_prayingCount)'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CellReportSheet extends StatefulWidget {
  final void Function(String caption, int visitors) onPublishReport;

  const CellReportSheet({super.key, required this.onPublishReport});

  @override
  State<CellReportSheet> createState() => _CellReportSheetState();
}

class _CellReportSheetState extends State<CellReportSheet> {
  final _captionCtrl = TextEditingController(text: 'Célula Betel reunida hoje! Deus falou muito aos nossos corações 🔥');
  int _visitors = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatório da Célula + Post')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text('Foto do Encontro Selecionada', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _captionCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Legenda que irá para o Feed da Igreja',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Visitantes no encontro de hoje:', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  IconButton.outlined(
                    onPressed: _visitors > 0 ? () => setState(() => _visitors--) : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('$_visitors', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  IconButton.outlined(
                    onPressed: () => setState(() => _visitors++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: () {
              widget.onPublishReport(_captionCtrl.text, _visitors);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.send),
            label: const Text('Salvar Relatório e Publicar no Feed'),
          ),
        ],
      ),
    );
  }
}

class MemberProfileView extends StatefulWidget {
  final String churchName;
  final VoidCallback onSwitchChurch;

  const MemberProfileView({
    super.key,
    required this.churchName,
    required this.onSwitchChurch,
  });

  @override
  State<MemberProfileView> createState() => _MemberProfileViewState();
}

class _MemberProfileViewState extends State<MemberProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('@lider_lucas'),
        actions: [
          TextButton.icon(
            onPressed: widget.onSwitchChurch,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Trocar Igreja'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
              SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [Text('18', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('Posts')]),
                    Column(children: [Text('Betel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('Célula')]),
                    Column(children: [Text('Jovem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('Rede')]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Lucas Andrade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('Líder de Célula • Rede Jovem • ${widget.churchName}'),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.insights),
            label: const Text('Abrir Painel Pastoral / Rede (Admin)'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PastoralDashboardView()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PastoralDashboardView extends StatelessWidget {
  const PastoralDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel Pastoral • Redes e Células')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.fact_check, color: Colors.blue),
              title: Text('Relatórios Entregues na Semana: 35 / 41 (85%)'),
              subtitle: Text('467 membros presentes • 60 visitantes • 13 decisões por Cristo'),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFF2563EB), child: Icon(Icons.bolt, color: Colors.white)),
              title: Text('Rede Jovem • Pr. Marcos'),
              subtitle: Text('13/14 células entregues (92%) • 27 visitantes'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFF059669), child: Icon(Icons.favorite, color: Colors.white)),
              title: Text('Rede Casais • Pr. André & Pra. Júlia'),
              subtitle: Text('16/18 células entregues (88%) • 19 visitantes'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFFDB2777), child: Icon(Icons.auto_awesome, color: Colors.white)),
              title: Text('Rede Mulheres • Pra. Camila'),
              subtitle: Text('6/9 células entregues (66%) • 14 visitantes'),
            ),
          ),
        ],
      ),
    );
  }
}
