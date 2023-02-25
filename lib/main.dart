import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';
import 'package:personal_money_management_app/screens/home/widgets/screen_home.dart';
import 'package:personal_money_management_app/screens/transaction/add_transaction/screen_add_transaction.dart';

import 'models/transactions/transactions_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        //colorScheme:
        // ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 184, 10, 42)),
        //useMaterial3: true,
      ),
      home: const ScreenHome(),
      routes: {
        ScreenAddTransaction.routeName: (ctx) => const ScreenAddTransaction(),
      },
    );
  }
}
