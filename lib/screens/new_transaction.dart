// import 'package:expense_tracker/widgets/flat_container.dart';
import 'package:expense_tracker/constant.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({Key? key, required this.addNewTransaction})
      : super(key: key);
  final Function addNewTransaction;
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

   String? _product;
   String? _img_url;
  late String _note;
  late int _amount;
   DateTime? date;

  final formkey = GlobalKey<FormState>();
  final requiredValidator =
  RequiredValidator(errorText: 'This field is required');

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  bool isLoading = true;


   late String term;
   late var newProdBal;

   @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      if(loggedInUser.email != null){
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  checkFields() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submitTransaction() {
    if (checkFields()) {

      if(expenseSelected){
//  deduct senders balance
late var newTTExpense = (loggedInUser.tt_expense! + _amount);

//check image
        switch(_product) {
          case "Entertainment": {
            newProdBal = (loggedInUser.entertainment! + _amount);
            term = "entertainment";
          }
          break;

          case "Food": {
          newProdBal = (loggedInUser.food! + _amount);
            term = "food";
          }
          break;

          case "Travel": {
          newProdBal = (loggedInUser.travel! + _amount);
            term = "travel";
          }
          break;

          case "Shopping": {
            newProdBal = (loggedInUser.shopping! + _amount);
           term = "shopping";
          }
          break;

          default: {
          newProdBal = 0;
            term = "error";
          }
          break;
        }
// add users expenses
FirebaseFirestore.instance.collection("users").doc(loggedInUser.uid).update(
{
'tt_expense': newTTExpense,
'${term}': newProdBal,
}
);

//check image
switch(_product) {
case "Entertainment": {
  _img_url="assets/images/party.jpg";
}
break;

case "Food": {
  _img_url="assets/images/food.jpeg";
}
break;

case "Travel": {
  _img_url="assets/images/travel.jpg";
}
break;

case "Shopping": {
  _img_url="assets/images/shopping.jpg";
}
break;

default: {
  _img_url ="";
}
break;
}
//insert data into user_expenses >>
FirebaseFirestore.instance
.collection("expenses")
.doc(loggedInUser.uid)
.collection('user_expenses')
.add({
'amount': _amount,
'date': date,
'img_url': _img_url,
'product': _product,
'note': _note,
'type': 'EXPENSE',
});
        //snack bar
        var snackBar = SnackBar(
          content: Text("Expenses Added!"),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);


}




else if(incomeSelected){
late var newTTIncome = (loggedInUser.tt_income! + _amount);
// add users expenses
FirebaseFirestore.instance.collection("users").doc(loggedInUser.uid).update(
{
 'tt_income': newTTIncome ,
}
);
//insert data into user_income >>
FirebaseFirestore.instance
.collection("expenses")
.doc(loggedInUser.uid)
.collection('user_expenses')
.add({
'amount': _amount,
'date': date,
'note': _note,
'product': "ADDED INCOME",
'type': 'INCOME',
'img_url': 'assets/images/dollar.png',
});
//affect INCOMES
        var snackBar = SnackBar(
          content: Text("Income Added"),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    }
    }

  bool expenseSelected = true;
  bool incomeSelected = false;
   int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {


    final List<String> entries = <String>['Entertainment', 'Food' , 'Travel' , 'Shopping'];
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xff757575),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff5f5f5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.only(
              left: 20.0,
              top: 30.0,
              right: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const Text(
                  "Add New Transaction",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 21.0,
                ),
                ToggleSwitch(
                  totalSwitches: 2,
                  labels: const [
                    "Expense",
                    "Income",
                  ],
                  minWidth: 150,
                  minHeight: 60,
                  cornerRadius: 30.0,
                  activeBgColor: const [
                    Colors.deepOrange,
                  ],
                  initialLabelIndex: selectedIndex,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                  inactiveFgColor: Colors.black54,
                  fontSize: 20,
                  changeOnTap: false,
                  onToggle: (index) {
                    selectedIndex = index!;
                    setState(() {
                      if (selectedIndex == 1) {
                        expenseSelected = false;
                        incomeSelected = true;
                        return;
                      }
                      if (selectedIndex == 0) {
                        expenseSelected = true;
                        incomeSelected = false;
                        return;
                      }
                    });
                  },
                ),

                Container(
                  height: 60.0,
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20.0),
                      const Icon(Icons.add),
                      const SizedBox(width: 20.0),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 200,
                        child: TextFormField(
                          autofocus: false,
                          validator: requiredValidator,
                          onChanged: (val) =>
                          _amount =  int.parse(val),
                          decoration: const InputDecoration(
                            hintText: "Enter Amount",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



                if (expenseSelected)
                  Container(
                    height: 60.0,
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20.0),
                        const Icon(
                          Icons.category_outlined,
                          size: 25.0,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 20.0),
                        DropdownButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 30.0,
                          value: entries[selectedIndex],
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _product = newValue!;
                            });
                          },
                          items:
                          entries.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                                child: Text(value), value: value);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                Container(
                  height: 60.0,
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20.0),
                      const Icon(Icons.note_add),
                      const SizedBox(width: 20.0),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 200,
                        child: TextFormField(
                          autofocus: false,
                          validator: requiredValidator,
                          onChanged: (val) =>
                          _note = val,
                          decoration: const InputDecoration(
                            hintText: "Add Note",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime(2022, 05, 01),
                      firstDate: DateTime(2022, 05, 01),
                      lastDate: DateTime(2022, 12, 31),
                    ).then((newDate) {
                      setState(() {
                        date = newDate!;
                      });
                    });
                  },

                  child: Container(
                    height: 60.0,
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20.0),
                        const Icon(
                          Icons.calendar_today,
                          size: 25.0,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          date != null
                              ? DateFormat.yMd().format(date!)
                              : "Pick the date",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: kGradient,
                  ),
                  child: TextButton(
                    child: const Text(
                      "Add Transaction",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _submitTransaction,
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
