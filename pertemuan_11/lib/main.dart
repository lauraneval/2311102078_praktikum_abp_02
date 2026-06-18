import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cart_cubit.dart';
import 'screens/product_list_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const AventuriaApp());

class AventuriaApp extends StatelessWidget {
  const AventuriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        title: 'Aventuria Store',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const ProductListScreen(),
      ),
    );
  }
}