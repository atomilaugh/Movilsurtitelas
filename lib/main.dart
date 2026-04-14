import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/pages/login_page.dart';
import 'package:movilsurtitela/presentation/pages/admin/admin_dashboard_screen.dart';
import 'package:movilsurtitela/presentation/pages/asesor/asesor_dashboard_screen.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/repartidor_dashboard_screen.dart';
import 'package:movilsurtitela/presentation/pages/cliente/catalogo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_CO', null);
  runApp(const SurticamisetasApp());
}

class SurticamisetasApp extends StatefulWidget {
  const SurticamisetasApp({super.key});

  @override
  State<SurticamisetasApp> createState() => _SurticamisetasAppState();
}

class _SurticamisetasAppState extends State<SurticamisetasApp> {
  bool _isDarkMode = false;
  User? _currentUser;
  bool _isLoggedIn = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _login(User user) {
    setState(() {
      _currentUser = user;
      _isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        title: 'Surticamisetas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF2D2D2D),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2D2D2D),
            secondary: Color(0xFF666666),
            surface: Color(0xFFF5F5F5),
            error: Color(0xFFEF4444),
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFD4C5B0),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFD4C5B0),
            secondary: Color(0xFFA3A3A3),
            surface: Color(0xFF1A1A1A),
            error: Color(0xFFEF4444),
          ),
          useMaterial3: true,
        ),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: _isLoggedIn && _currentUser != null
            ? _currentUser!.role == UserRole.admin
                ? AdminDashboardScreen(
                    user: _currentUser!,
                    onLogout: _logout,
                    onThemeToggle: _toggleTheme,
                    isDarkMode: _isDarkMode,
                  )
                : _currentUser!.role == UserRole.repartidor
                    ? RepartidorDashboardScreen(
                        user: _currentUser!,
                        onLogout: _logout,
                        onThemeToggle: _toggleTheme,
                        isDarkMode: _isDarkMode,
                      )
                    : _currentUser!.role == UserRole.cliente
                        ? CatalogoScreen(
                            user: _currentUser!,
                            onProductSelect: (producto) {},
                            onOpenCart: () {},
                            cartItemsCount: 0,
                          )
                        : AsesorDashboardScreen(
                            user: _currentUser!,
                            onLogout: _logout,
                            onThemeToggle: _toggleTheme,
                            isDarkMode: _isDarkMode,
                          )
            : LoginPage(
                onThemeToggle: _toggleTheme,
                isDarkMode: _isDarkMode,
                onLogin: _login,
              ),
      ),
    );
  }
}