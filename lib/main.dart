import 'package:flutter/material.dart';
import 'package:price_calculate/presentation/car_selection/car_selection.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: Typography.blackCupertino
              .copyWith(
            titleLarge: Typography.blackCupertino
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          )
              .apply(

          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0
          )
      ),
      home: CarSelectionScreen(),
    );
  }
}
