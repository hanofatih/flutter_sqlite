import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_sqlite/Data/database_helper.dart';
import 'package:flutter_sqlite/Models/loan.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RxList<Loan> loans = RxList<Loan>();
  RxBool loading = RxBool(false);

  getLoans() async {
    try {
      loading.value = true;
      await Future.delayed(Duration(seconds: 1));
      loans.value = await DatabaseHelper().getLoans();
    } catch (e) {
    } finally {
      loading.value = false;
    }
  }

  Future<void> _deleteLoan(int id) async {
    await DatabaseHelper().deleteLoan(id);
    getLoans();
  }

  @override
  Widget build(BuildContext context) {
    getLoans();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        backgroundColor: Colors.purple.withOpacity(0.7),
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.people, size: 30),
        ],
        onTap: (index) {
          if (index == 1) {
            Get.offNamed("/borrowers");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/add_loan");
        },
        child: Icon(Icons.add),
      ),
      body: Obx(
        () => loading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      return Container(
                        // padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              )
                            ]),
                        child: ListTile(
                          leading: Icon(Icons.note),
                          title: Text(
                              'Amount: ${loans[index].amount.toStringAsFixed(0)} IQD'),
                          subtitle: Text(
                              'Borrower: ${loans[index].borrowerName}\nDate: ${loans[index].date}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.redAccent[700]),
                            onPressed: () => _deleteLoan(loans[index].id!),
                          ),
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
