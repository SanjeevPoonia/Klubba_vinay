

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/utils/consumable_store.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';
import 'cart_screen.dart';
const List<String> _kProductIds = <String>["extramb1"];
class addOnPackagesIOS extends StatefulWidget{
  _addOnPackages createState()=>_addOnPackages();
}
class _addOnPackages extends State<addOnPackagesIOS>{
  List<dynamic> packagesList = [];
  bool isLoading = true;
  bool _fromTop = true;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppTheme.themeColor,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Add On ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Package',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body:_queryProductError==null?
      Column(
        children: [

         _buildProductList()


        ],
      ):Container()

    );
  }
  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
          _subscription.cancel();
        }, onError: (Object error) {
          // handle error here.
        });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }



  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }
  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            Toast.show('Package purchased successfully!!',
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.green);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingScreen()));
          }
            // deliverProduct(purchaseDetails);
          } else {
          Toast.show('Something went wrong!!',
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);

          //  _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }

  Container _buildProductList() {
    if (_loading) {
      return Container(
          child: Center(
            child: ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Fetching products...'))
          ));
    }
    final List<Container> productList = <Container>[];
    if (_notFoundIds.isNotEmpty) {
      Center(
        child: Text('No Add On Package Available'),
      );
    }
    productList.addAll(_products.map(
          (ProductDetails productDetails) {
        final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.35,
                height: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppTheme.gratitudeBg
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppTheme.greenColor
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                        child: const Text("Best Plan",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Text("Price",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.blueColor
                      ),),
                    const SizedBox(height: 5,),
                    Text(productDetails.price.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,

                      ),),
                    const SizedBox(height: 5,),



                  ],
                ),


              ),

             Expanded(child:  Container(
               height: 75,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(7),
                   color: AppTheme.gratitudeBg
               ),
               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(productDetails.title,
                       style: const TextStyle(
                         fontWeight: FontWeight.w500,
                         fontSize: 14,
                         color: Colors.black,
                       ),),
                     SizedBox(height: 10,),
                     Row(
                       children: [
                         Expanded(flex: 1,child: InkWell(
                           onTap: (){
                             _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                           },
                           child: const Text("View Details",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 color: AppTheme.blueColor,
                                 decoration: TextDecoration
                                     .underline,
                                 fontSize: 12
                             ),),
                         ),),
                         Expanded(flex: 1,child: InkWell(
                           onTap: (){
                             _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                           },
                           child: Container(
                             height: 25,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                               color: Colors.black,
                               borderRadius: BorderRadius.circular(2),
                             ),
                             child: const Text("Buy Now",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white
                               ),),
                           ),
                         ))
                       ],
                     )

                   ],
                 ),
               ),
             ))
            ],

          ),);



          /*ListTile(
          title: GestureDetector(
            onTap: (){
              _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
            },
            child: Text(
              productDetails.title,
            ),
          ),
          subtitle: Text(
            productDetails.description,
          ),
        )*/;
      },
    ));
    return Container(
        child: Column(
            children: <Widget>[Container(), const Divider()] + productList));
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }
  }





