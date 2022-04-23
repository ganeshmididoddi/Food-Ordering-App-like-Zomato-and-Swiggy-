import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodexpress_user/assistantMethods/assistant_mehods.dart';
import 'package:foodexpress_user/assistantMethods/cart_item_counter.dart';
import 'package:foodexpress_user/assistantMethods/total_amount.dart';
import 'package:foodexpress_user/mainScreens/address_screen.dart';
import 'package:foodexpress_user/models/items.dart';
import 'package:foodexpress_user/splashScreen/splash_screen.dart';
import 'package:foodexpress_user/widgets/cart_item_design.dart';
import 'package:foodexpress_user/widgets/progress_bar.dart';
import 'package:foodexpress_user/widgets/simple_app_bar.dart';
import 'package:foodexpress_user/widgets/text_widget_header.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatefulWidget
{
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}




class _CartScreenState extends State<CartScreen>
{
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "My Cart",),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text("Clear Cart", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: ()
              {
                clearCartNow(context);

                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text("Check Out", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(
                    builder: (c)=> AddressScreen(
                      totalAmount:totalAmount.toDouble(),
                      sellerUID:widget.sellerUID
                ),
                ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [

          //overall total amount
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List")
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                    "Total Price: ₹ " + amountProvider.tAmount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight:  FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),

          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data!.docs.length == 0
                  ? //startBuildingCart()
              Container()
                  : SliverList(
                delegate: SliverChildBuilderDelegate((context, index)
                {
                  Items model = Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );

                  if(index == 0)
                  {
                    totalAmount = 0;
                    totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                  }
                  else
                  {
                    totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                  }

                  if(snapshot.data!.docs.length - 1 == index)
                  {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
                    {
                      Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                    });
                  }

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber: separateItemQuantityList![index],
                  );
                },
                  childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}