import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';

import '../../models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryListListner,
      builder: (
        BuildContext ctx,
        List<CategoryModel> newList,
        Widget? _,
      ) {
        return ListView.separated(
            itemBuilder: (ctx, index) {
              final category = newList[index];
              return Card(
                elevation: 1,
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                      onPressed: () {
                        CategoryDB.instance.deleteCategory(category.id);
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: newList.length);
      },
    );
  }
}
