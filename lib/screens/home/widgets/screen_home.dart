import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';
import 'package:personal_money_management_app/screens/category/screen_category.dart';
import 'package:personal_money_management_app/screens/home/widgets/bottom_navigation.dart';
import 'package:personal_money_management_app/screens/transaction/add_transaction/screen_add_transaction.dart';
import 'package:personal_money_management_app/screens/transaction/screen_transaction.dart';

import '../../category/category_add_popup.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final pages = const [
    ScreenTransactions(),
    ScreenCategory(),
  ];

  @override
  void initState() {
    CategoryDB().refreshUI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: ScreenHome.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (ScreenHome.selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            showCategoryAddPopup(context);
            // final _sample = CategoryModel(
            //   id: DateTime.now().millisecondsSinceEpoch.toString(),
            //   name: 'Food',
            //   type: CategoryType.expense,
            // );
            // CategoryDB().insertCategory(_sample);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
