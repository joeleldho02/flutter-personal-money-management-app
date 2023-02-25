// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/transactions/transactions_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<List<TransactionModel>> getTransaction();
  Future<void> addTransaction(TransactionModel obj);
  Future<void> deleteTransaction(String categoryID);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> deleteTransaction(String transactionID) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.delete(transactionID);
    refresh();
  }

  Future<void> refresh() async {
    final list = await getTransaction();
    list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return db.values.toList();
  }

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.put(obj.id, obj);
  }
}
