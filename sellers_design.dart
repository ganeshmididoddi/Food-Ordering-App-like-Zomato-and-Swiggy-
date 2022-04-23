import 'package:flutter/material.dart';
import 'package:foodexpress_user/mainScreens/menus_screen.dart';
import 'package:foodexpress_user/models/sellers.dart';

class SellersDesignWidget extends StatefulWidget {
  Seller? model;
  BuildContext? context;

  SellersDesignWidget({this.model,this.context});

  @override
  _SellersDesignWidgetState createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MenusScreen(model:widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Divider(
                height: 4,
                thickness: 2,
                color: Colors.grey,
              ),
              Image.network(
                widget.model!.sellerAvatarUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),
              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "TrainOne"
                ),
              ),
              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                ),
              ),
              const Divider(
                height: 4,
                thickness: 2,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
