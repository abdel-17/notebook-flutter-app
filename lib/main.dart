import 'package:flutter/material.dart';
import 'package:notebook/data/model.dart';
import 'package:notebook/ui/home/main.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => NoteModel(), child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = /* note app yellow color */ Color(0xffF9C80E);
    final colorScheme = ColorScheme.fromSeed(seedColor: seedColor);
    return MaterialApp(
      title: 'Notebook',
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.inversePrimary),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
