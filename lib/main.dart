import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'telas/tela_home.dart';
import 'telas/tela_login.dart';
import 'telas/tela_splash.dart';
import 'util/cores.dart';
import 'util/rotas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Falha ao inicializar Firebase: $e');
  }
  runApp(const App1Dose());
}

class App1Dose extends StatelessWidget {
  const App1Dose({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: '1 Dose',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Cores.noite,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Cores.tomate,
            brightness: Brightness.dark,
            surface: Cores.noite,
          ),
          fontFamily: 'Roboto',
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            contentTextStyle: TextStyle(color: Colors.white),
          ),
        ),
        initialRoute: Rotas.splash,
        routes: {
          Rotas.splash: (_) => const TelaSplash(),
          Rotas.login: (_) => const TelaLogin(),
          Rotas.home: (_) => const TelaHome(),
        },
      ),
    );
  }
}
