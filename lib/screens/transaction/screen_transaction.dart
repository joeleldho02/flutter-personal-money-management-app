import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_money_management_app/db/transactions/transactions_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';

import '../../models/transactions/transactions_model.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder:
          (BuildContext context, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, index) {
              final value = newList[index];
              return Slidable(
                key: Key(value.id!),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransaction(value.id!);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor: value.type == CategoryType.income
                          ? const Color.fromARGB(255, 8, 236, 16)
                          : const Color.fromARGB(255, 245, 24, 8),
                      child: Text(
                        parseDate(value.date),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text('Rs.${value.amount}'),
                    subtitle: Text(value.category.name),
                    trailing: IconButton(
                      onPressed: () {
                        TransactionDB.instance.deleteTransaction(value.id!);
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(height: 10);
            },
            itemCount: newList.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final splitedDate = _date.split(' ');

    return '${splitedDate.last}\n${splitedDate.first}';

    //return '${date.day}\n${date.month}';
  }
}
