import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category Name',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                RadioButton(
                    title: 'Income',
                    type: CategoryType.income,
                    selectedCategoryType: CategoryType.income),
                RadioButton(
                    title: 'Expense',
                    type: CategoryType.expense,
                    selectedCategoryType: CategoryType.income)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text.trim();
                if (_name.isEmpty) {
                  return;
                }
                final _type = selectedCategoryNotifier.value;
                final _category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _name,
                  type: _type,
                );

                CategoryDB().insertCategory(_category);
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  final CategoryType selectedCategoryType;
  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
    required this.selectedCategoryType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (
            BuildContext ctx,
            CategoryType newCategory,
            Widget? _,
          ) {
            return Radio<CategoryType>(
              value: type,
              groupValue: selectedCategoryNotifier.value,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
