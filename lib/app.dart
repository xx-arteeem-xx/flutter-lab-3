import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/cart/cart_notifier.dart';
import 'features/menu/categories_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/about/about_screen.dart';
import 'widgets/theme_toggle_button.dart';

class App extends StatefulWidget {
  final SharedPreferences prefs;

  const App({super.key, required this.prefs});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ThemeNotifier _themeNotifier;
  final CartNotifier _cartNotifier = CartNotifier();

  @override
  void initState() {
    super.initState();
    _themeNotifier = ThemeNotifier(widget.prefs);
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    _cartNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: _MainScaffold(
          themeNotifier: _themeNotifier,
          cartNotifier: _cartNotifier,
        ),
      ),
    );
  }
}

class _MainScaffold extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final CartNotifier cartNotifier;

  const _MainScaffold({
    required this.themeNotifier,
    required this.cartNotifier,
  });

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _tab = 0;

  static const _titles = [AppStrings.appName, AppStrings.tabCart];

  @override
  void initState() {
    super.initState();
    widget.cartNotifier.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    widget.cartNotifier.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  void _openAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AboutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = widget.cartNotifier.totalCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'О приложении',
            onPressed: _openAbout,
          ),
          ThemeToggleButton(notifier: widget.themeNotifier),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          CategoriesScreen(cartNotifier: widget.cartNotifier),
          CartScreen(cartNotifier: widget.cartNotifier),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu_rounded),
            label: AppStrings.tabMenu,
          ),
          BottomNavigationBarItem(
            icon: cartCount > 0
                ? Badge(
                    label: Text('$cartCount'),
                    child: const Icon(Icons.shopping_cart_outlined),
                  )
                : const Icon(Icons.shopping_cart_outlined),
            activeIcon: cartCount > 0
                ? Badge(
                    label: Text('$cartCount'),
                    child: const Icon(Icons.shopping_cart_rounded),
                  )
                : const Icon(Icons.shopping_cart_rounded),
            label: AppStrings.tabCart,
          ),
        ],
      ),
    );
  }
}
