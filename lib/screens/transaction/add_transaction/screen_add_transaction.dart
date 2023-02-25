import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/db/transactions/transactions_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';
import 'package:personal_money_management_app/models/transactions/transactions_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';

  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  final purposeController = TextEditingController();
  final amountController = TextEditingController();

  DateTime? selectedDate;
  CategoryType? selectedCategoryType;
  CategoryModel? selectedCategoryModel;
  String? categoryID;

  @override
  void initState() {
    selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Purpose',
                ),
                controller: purposeController,
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              TextButton.icon(
                onPressed: () async {
                  final selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      selectedDate = selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(selectedDate == null
                    ? 'Select Date'
                    : selectedDate!.day.toString()),
              ),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                          value: CategoryType.income,
                          groupValue: selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryType = CategoryType.income;
                              categoryID = null;
                            });
                          }),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                          value: CategoryType.expense,
                          groupValue: selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryType = CategoryType.expense;
                              categoryID = null;
                            });
                          }),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              DropdownButton(
                hint: const Text('Select Category'),
                value: categoryID,
                items: (selectedCategoryType == CategoryType.income
                        ? CategoryDB.instance.incomeCategoryListListner
                        : CategoryDB.instance.expenseCategoryListListner)
                    .value
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                        onTap: () {
                          selectedCategoryModel = e;
                        },
                      ),
                    )
                    .toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    categoryID = selectedValue;
                  });
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  addTransaction();
                },
                icon: const Icon(Icons.check),
                label: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final purposeText = purposeController.text;
    final amountText = amountController.text;
    if (purposeText.isEmpty ||
        amountText.isEmpty ||
        categoryID == null ||
        selectedDate == null ||
        selectedCategoryModel == null) {
      return;
    }
    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
      purpose: purposeText,
      amount: parsedAmount,
      date: selectedDate!,
      type: selectedCategoryType!,
      category: selectedCategoryModel!,
    );
    await TransactionDB.instance.addTransaction(model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
