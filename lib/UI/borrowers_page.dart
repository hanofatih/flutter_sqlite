import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/Data/database_helper.dart';
import 'package:flutter_sqlite/Models/borrower.dart';
import 'package:get/get.dart';

class BorrowersPage extends StatefulWidget {
  const BorrowersPage({super.key});

  @override
  State<BorrowersPage> createState() => _BorrowersPageState();
}

class _BorrowersPageState extends State<BorrowersPage> {
  RxList<Borrower> borrowers = RxList<Borrower>();
  RxBool loading = RxBool(false);

  getBorrowers() async {
    try {
      loading.value = true;
      await Future.delayed(Duration(seconds: 1));
      borrowers.value = await DatabaseHelper().getBorrowers();
    } catch (e) {
    } finally {
      loading.value = false;
    }
  }

  Future<void> _deleteBorrower(int id) async {
    await DatabaseHelper().deleteBorrower(id);
    getBorrowers();
  }

  @override
  Widget build(BuildContext context) {
    getBorrowers();
    return Scaffold(
      appBar: AppBar(
        title: Text("Borrowers"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        backgroundColor: Colors.purple.withOpacity(0.7),
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.people, size: 30),
        ],
        onTap: (index) {
          if (index == 0) {
            Get.offNamed("/home");
          }
        },
      ),
      body: Obx(
        () => loading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: borrowers.length,
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
                          leading: Icon(Icons.people),
                          title: Text(borrowers[index].fullname),
                          subtitle: Text('Phone: ${borrowers[index].phone}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.redAccent[700]),
                            onPressed: () =>
                                _deleteBorrower(borrowers[index].id!),
                          ),
                        ),
                      );
                    }),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/add_borrower");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
