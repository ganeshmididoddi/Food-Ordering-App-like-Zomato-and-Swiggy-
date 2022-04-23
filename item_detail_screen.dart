import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodexpress_user/assistantMethods/assistant_mehods.dart';
import 'package:foodexpress_user/models/items.dart';
import 'package:foodexpress_user/widgets/app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ItemDetailScreen extends StatefulWidget {
 final Items? model;
 ItemDetailScreen({this.model});


  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController =TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: Column(
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: NumberInputPrefabbed.roundedButtons(
            controller: counterTextEditingController,
            incDecBgColor: Colors.amber,
            min: 1,
            max: 9,
            initialValue: 1,
            buttonArrangement: ButtonArrangement.incRightDecLeft,
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "₹"+widget.model!.price.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, ),
            ),
          ),
          const SizedBox(height: 20,),
          Center(
            child: InkWell(
              onTap: (){
                int itemCounter= int.parse(counterTextEditingController.text);
                // chek if item exist already in cart
                List<String> separateItemIDsList =separateItemIDs();
                separateItemIDsList.contains(widget.model!.itemID)
                    ? Fluttertoast.showToast(msg: "Item is already in Cart")
                    :

                // add to cart
                addItemToCart(widget.model!.itemID,context,itemCounter);
              },
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
                width: MediaQuery.of(context).size.width-25,
                height: 50,
                child: const Center(
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
