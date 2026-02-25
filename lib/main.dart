import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/library/library_bloc.dart';
import 'services/api_service.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ApiService(),
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    LibraryBloc(context.read<ApiService>()),
              ),
            ],
            child: const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: LibraryScreen(),
            ),
          );
        },
      ),
    );
  }
}