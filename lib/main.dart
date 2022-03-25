import 'package:flutter/material.dart';
import 'package:peliculas/screens/screens.dart';


import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false,)
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 243, 236, 236),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.redAccent
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: 'home',
      routes: {
        'home' : (_) => const HomeScreen(),
        'details' : (_) => const DetailsScreen(),
      },
    );
  }
}
