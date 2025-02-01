import 'package:flutter/material.dart';
import 'package:flutter_sqlite/UI/add_borrower_page.dart';
import 'package:flutter_sqlite/UI/add_loan_page.dart';
import 'package:flutter_sqlite/UI/borrowers_page.dart';
import 'package:get/route_manager.dart';

import 'Data/database_helper.dart';
import 'UI/home_page.dart';

void main() async {
  // AppBindings().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/borrowers', page: () => BorrowersPage()),
        GetPage(name: '/add_borrower', page: () => AddBorrowerPage()),
        GetPage(name: '/add_loan', page: () => AddLoanPage()),
      ],
      defaultTransition: Transition.fadeIn,
      transitionDuration: Durations.medium3,
    );
  }
}
