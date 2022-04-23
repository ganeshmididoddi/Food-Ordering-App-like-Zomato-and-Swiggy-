import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodexpress_user/assistantMethods/assistant_mehods.dart';
import 'package:foodexpress_user/global/global.dart';
import 'package:foodexpress_user/mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlacedOrderScreen({
    this.addressID,
    this.totalAmount,
    this.sellerUID,
});

  @override
  _PlacedOrderScreenState createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen>
{
  String orderId =DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      "addressID":widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails":"Cash on Delivery",
      "orderTime":orderId,
      "isSuccess":true,
      "sellerUID":widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderID": orderId,
    });

    writeOrderDetailsForSeller({
    "addressID":widget.addressID,
    "totalAmount": widget.totalAmount,
    "orderBy": sharedPreferences!.getString("uid"),
    "productIDs": sharedPreferences!.getStringList("userCart"),
    "paymentDetails":"Cash on Delivery",
    "orderTime":orderId,
    "isSuccess":true,
    "sellerUID":widget.sellerUID,
    "riderUID": "",
    "status": "normal",
    "orderID": orderId,
    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderId="";
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
        Fluttertoast.showToast(msg: "Order Placed Successfully");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }


  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/delivery.jpg"),

            const SizedBox(height: 15,),
            ElevatedButton(
              child: const Text("Place Order"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: ()
              {
               addOrderDetails();
              },
            )
          ],
        ),
      ),
    );
  }
}
