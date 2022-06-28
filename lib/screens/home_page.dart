import 'package:expense_tracker/constant.dart';
import 'package:expense_tracker/screens/new_transaction.dart';
import '../models/transactions.dart';
import 'package:flutter/material.dart';
import '../widgets/amount_box.dart';
import '../widgets/app_bar.dart';
//firebase
import '../models/usermodel.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
 var originalDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   loggedInUser = UserModel.fromMap(value.data());
    //   setState(() {});
    //   if(loggedInUser.username != null){
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // });
    _refreshLocalGallery();
  }


  Future<Null> _refreshLocalGallery() async{
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      if(loggedInUser.username != null){
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void _addNewTransaction(
      String category,
      String Amount,
      String note,
      DateTime date,
      ) {
    final newTransaction = Transactions(category, Amount, date, note);
    setState(() {
    //  userTransactions.add(newTransaction);
    });
  }

  bool showAllTransactions = false;
  @override
  Widget build(BuildContext context) {


    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final deviceHeight = MediaQuery.of(context).size.height;

    final List<String> entries = <String>['Entertainment', 'Food' , 'Travel' , 'Shopping'];
    final List<String> colorCodes = <String>[loggedInUser.entertainment.toString(), loggedInUser.food.toString()
      , loggedInUser.travel.toString() , loggedInUser.shopping.toString()];
    // categories
    final List<String> images_url = <String> ["assets/images/party.jpg",
      "assets/images/food.jpeg",
      "assets/images/travel.jpg",
       "assets/images/shopping.jpg"];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white, size: 25.0),
        onPressed: () => setState(() {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return NewTransaction(
                addNewTransaction: _addNewTransaction,
              );
            },
          );
        }),
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child:  (isLoading)
            ? Center(
          child:
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
              backgroundColor: Colors.blueAccent,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              strokeWidth: 3,
            ),
          ),
        )
            :SingleChildScrollView(
          child: RefreshIndicator(
            backgroundColor: Colors.teal,
            color: Colors.white,
            displacement: 200,
            strokeWidth: 3,
    onRefresh: _refreshLocalGallery,

            child: Column(
              children: [
                Container(
                  height: 70.0,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  decoration: const BoxDecoration(
                    color: Color(0xfff5f5f5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25.0,
                            backgroundImage: AssetImage('assets/images/user.jpg'), // ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome!",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                loggedInUser.username.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),







                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: IconButton(
                            color: Colors.black,
                            icon:
                            const Icon(Icons.settings, color: Colors.grey, size: 25.0),
                            onPressed: () {
                              //Do this when clicked....
                            }),
                      ),
                    ],
                  ),
                ),

        Container(
            margin: const EdgeInsets.symmetric(vertical: 15.0),
            height: height * 0.19,
            width: width * 0.92,
            decoration: BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Total Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23.0,
                  ),
                ),
                Text(
                  "KES  ${loggedInUser.tt_income.toString()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AmounBox(
                          icon: Icons.arrow_downward_rounded,
                          iconColor: Colors.green,
                          title: 'Income',
                          amount: loggedInUser.tt_income.toString()),
                      AmounBox(
                          icon: Icons.arrow_upward_rounded,
                          iconColor: Colors.red,
                          title: 'Expense',
                          amount: loggedInUser.tt_expense.toString()),
                    ],
                  ),
                ),
              ],
            ),
        ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllTransactions = false;
                        });
                      },
                      child: Text(
                        "Categories",
                        style: showAllTransactions
                            ? kInactiveTextStyle
                            : kActiveTextStyle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllTransactions = true;
                        });
                      },
                      child: Text(
                        "Show All",
                        style: showAllTransactions
                            ? kActiveTextStyle
                            : kInactiveTextStyle,
                      ),
                    ),
                  ],
                ),

                // Categories transactions
                if (!showAllTransactions)
                // ignore: sized_box_for_whitespace
                  Container(
                    height: deviceHeight * 0.9,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:entries.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 1.0,
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                              right: 20.0,
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:

                              Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage:
                                      AssetImage("${images_url[index]}"),
                                    ),
                                    title: Text(
                                      entries[index],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: Text("KES ${colorCodes[index]}" ,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    minVerticalPadding: 20,
                                  ),
                                ],
                              ),


                            ),
                          );
                        }
                        ),
                  ),



                // all the transactions
                if (showAllTransactions)
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom +
                            100),
                    height: deviceHeight * 0.55,
                    child:
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('expenses')
                          .doc(loggedInUser.uid)
                          .collection('user_expenses')
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasError)
                          return Text('Error = ${snapshot.error}');

                        if (snapshot.hasData) {
                          final docs = snapshot.data!.docs;
                          return docs.length == 0
                              ? Text(
                            "No Records Found",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          )
                              : ListView.builder(
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (_, i) {
                              final data = docs[i].data();
                              return Card(
                                elevation: 1.0,
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child:

                                  Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage:
                                          AssetImage("${data['img_url'].toString()}"),
                                        ),
                                        title: Text(
                                          data['product']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Made on  ${data['date']}  ( "+ data['type']
                                              .toString().toUpperCase() + " ) " ,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        trailing: Text("KES ${data['amount'].toString()}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        else
                          return Center(child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                            strokeWidth: 2,
                          ));
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

