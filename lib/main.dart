import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_riverpod/pages/home.dart';
import 'package:pokemon_riverpod/services/database_service.dart';

import 'services/http_service.dart';

void main() async {
  await setUpService();
  runApp(const MainApp());
}

Future<void> setUpService() async {
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'PokeDex',
        theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.quattrocentoSansTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen)),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: HomePage(),
        ),
      ),
    );
  }
}
