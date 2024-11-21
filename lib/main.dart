import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class ResponsiveNavigationBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<NavigationRailDestination> tabletBarButtons;
  final List<Widget> webBarButtons;
  final List<BottomNavigationBarItem> phoneBarButtons;

  ResponsiveNavigationBar(
      {super.key,
      required this.navigationShell,
      required List<BarItem> barButtons})
      : tabletBarButtons = barButtons
            .map((item) => NavigationRailDestination(
                icon: item.icon, label: Text(item.label)))
            .toList(),
        webBarButtons = barButtons
            .map((item) => Tab(icon: item.icon, text: item.label))
            .toList(),
        phoneBarButtons = barButtons
            .map((item) =>
                BottomNavigationBarItem(icon: item.icon, label: item.label))
            .toList();

  @override
  State<ResponsiveNavigationBar> createState() =>
      _ResponsiveNavigationBarState();
}

class _ResponsiveNavigationBarState extends State<ResponsiveNavigationBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: widget.navigationShell.currentIndex,
        length: widget.webBarButtons.length,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          items: widget.phoneBarButtons,
          onTap: (int index) => widget.navigationShell.goBranch(index),
          currentIndex: widget.navigationShell.currentIndex,
        ),
      );
    } else if (MediaQuery.of(context).size.width > 1024) {
      _tabController.index = widget.navigationShell.currentIndex;
      return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('/images/learn_it.png'),
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                TabBar(
                  tabs: widget.webBarButtons,
                  onTap: (int index) => widget.navigationShell.goBranch(index),
                  controller: _tabController,
                  tabAlignment: TabAlignment.center,
                ),
              ],
            ),
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              destinations: widget.tabletBarButtons,
              onDestinationSelected: (int index) =>
                  widget.navigationShell.goBranch(index),
              labelType: NavigationRailLabelType.all,
              selectedIndex: widget.navigationShell.currentIndex,
            ),
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    }
  }
}

// Model for data
class BarItem {
  final Widget icon;
  final String label;

  BarItem({required this.icon, required this.label});
}

// `go_router` routes
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyApp',
      themeMode: ThemeMode.system,
      routerConfig: router(context),
    );
  }

  GoRouter router(BuildContext context) {
    List<RouteBase> routes = [
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${Home.path}',
                builder: (_, __) => const Home(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${Profile.path}',
                builder: (_, __) => const Profile(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${Settings.path}',
                builder: (_, __) => const Settings(),
              ),
            ],
          ),
        ],
        builder: (_, __, navigationShell) => ResponsiveNavigationBar(
            navigationShell: navigationShell,
            barButtons: [
              BarItem(icon: const Icon(Icons.home), label: 'Home'),
              BarItem(icon: const Icon(Icons.person), label: 'Profile'),
              BarItem(icon: const Icon(Icons.settings), label: 'Settings')
            ]),
      ),
    ];

    return GoRouter(
      initialLocation: '/${Home.path}',
      routes: routes,
    );
  }
}

class Profile extends StatelessWidget {
  static String path = 'profile';

  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
    );
  }
}

class Home extends StatelessWidget {
  static String path = 'home';

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
    );
  }
}

class Settings extends StatelessWidget {
  static String path = 'settings';

  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
    );
  }
}
