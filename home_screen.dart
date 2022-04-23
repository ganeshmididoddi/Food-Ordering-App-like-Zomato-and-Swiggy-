import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodexpress_user/assistantMethods/assistant_mehods.dart';
import 'package:foodexpress_user/authentication/login.dart';
import 'package:foodexpress_user/global/global.dart';
import 'package:foodexpress_user/models/sellers.dart';
import 'package:foodexpress_user/splashScreen/splash_screen.dart';
import 'package:foodexpress_user/widgets/sellers_design.dart';
import 'package:foodexpress_user/widgets/my_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodexpress_user/widgets/progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final items= [
    "images/slider/0.jpg",
    "images/slider/1.jpg",
    "images/slider/2.jpg",
    "images/slider/3.jpg",
    "images/slider/4.jpg",
    "images/slider/5.jpg",
    "images/slider/6.jpg",
    "images/slider/7.jpg",
    "images/slider/8.jpg",
    "images/slider/9.jpg",
    "images/slider/10.jpg",
    "images/slider/11.jpg",
    "images/slider/12.jpg",
    "images/slider/13.jpg",
    "images/slider/14.jpg",
    "images/slider/15.jpg",
    "images/slider/16.jpg",
    "images/slider/17.jpg",
    "images/slider/18.jpg",
    "images/slider/19.jpg",
    "images/slider/20.jpg",
  ];

  restrictBlockedUsersFromUsingApp() async
  {
    await FirebaseFirestore.instance.collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot){
      if(snapshot.data()!["status"]!="approved")
      {
        Fluttertoast.showToast(msg: "Admin has blocked your account. \nMail here admin@gmail.com");
        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      }
      else{
        clearCartNow(context);
      }
    });
  }


  @override

  void initState(){
    super.initState();
    restrictBlockedUsersFromUsingApp();

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
              ),
          ),
        ),
        title: const Text(
          "FoodExpress",
          style: TextStyle(fontFamily: "Signatra",fontSize: 45),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height*.3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  items: items.map((index){
                    return Builder(builder:(BuildContext context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Image.asset(index,
                          fit: BoxFit.fill,),
                        ),
                      );
                    });
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*.3,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .snapshots(),
            builder: (context,snapshot){
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1, 
                  staggeredTileBuilder: (C) => StaggeredTile.fit(1),
                  itemBuilder: (context,index)
                  {
                    Seller model = Seller.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String, dynamic>
                    );
                    //design for display sellers
                    return SellersDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      )
    );
  }
}
