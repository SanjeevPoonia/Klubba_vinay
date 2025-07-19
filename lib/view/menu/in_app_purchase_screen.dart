

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:klubba/utils/consumable_store.dart';
const List<String> _kProductIds = <String>["extramb1"];
class PurchaseScreen extends StatefulWidget
{
  PurchaseState createState()=>PurchaseState();
}
class PurchaseState extends State<PurchaseScreen> {

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
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
    });
    return;
  }

/*  if (Platform.isIOS) {
    final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    _inAppPurchase
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
  }*/

  final ProductDetailsResponse productDetailResponse =
  await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
  if (productDetailResponse.error != null) {
    setState(() {
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
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
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
    });
    return;
  }

  final List<String> consumables = await ConsumableStore.load();
  setState(() {
    _isAvailable = isAvailable;
    _products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _consumables = consumables;
    _purchasePending = false;
    _loading = false;
  });
}

@override
Widget build(BuildContext context) {
  final List<Widget> stack = <Widget>[];
  if (_queryProductError == null) {
    stack.add(
      ListView(
        children: <Widget>[
          _buildConnectionCheckTile(),
          _buildProductList(),
        ],
      ),
    );
  } else {
    stack.add(Center(
      child: Text(_queryProductError!),
    ));
  }
  if (_purchasePending) {
    stack.add(
      // TODO(goderbauer): Make this const when that's available on stable.
      // ignore: prefer_const_constructors
      Stack(
        children: const <Widget>[
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('IAP Example'),
      ),
      body: Stack(
        children: stack,
      ),
    ),
  );
}

Card _buildConnectionCheckTile() {
  if (_loading) {
    return const Card(child: ListTile(title: Text('Trying to connect...')));
  }
  final Widget storeHeader = ListTile(
    leading: Icon(_isAvailable ? Icons.check : Icons.block,
        color: _isAvailable
            ? Colors.green
            : ThemeData.light().colorScheme.error),
    title:
    Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
  );
  final List<Widget> children = <Widget>[storeHeader];

  if (!_isAvailable) {
    children.addAll(<Widget>[
      const Divider(),
      ListTile(
        title: Text('Not connected',
            style: TextStyle(color: ThemeData.light().colorScheme.error)),
        subtitle: const Text(
            'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
      ),
    ]);
  }
  return Card(child: Column(children: children));
}

Card _buildProductList() {
  if (_loading) {
    return const Card(
        child: ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Fetching products...')));
  }
  if (!_isAvailable) {
    return const Card();
  }
  const ListTile productHeader = ListTile(title: Text('Products for Sale'));
  final List<ListTile> productList = <ListTile>[];
  if (_notFoundIds.isNotEmpty) {
    productList.add(ListTile(
        title: Text('[${_notFoundIds.join(", ")}] not found',
            style: TextStyle(color: ThemeData.light().colorScheme.error)),
        subtitle: const Text(
            'This app needs special configuration to run. Please see example/README.md for instructions.')));
  }

  // This loading previous purchases code is just a demo. Please do not use this as it is.
  // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
  // We recommend that you use your own server to verify the purchase data.
  final Map<String, PurchaseDetails> purchases =
  Map<String, PurchaseDetails>.fromEntries(
      _purchases.map((PurchaseDetails purchase) {
        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      }));
  productList.addAll(_products.map(
        (ProductDetails productDetails) {
      final PurchaseParam purchaseParam =
      PurchaseParam(productDetails: productDetails);
      return ListTile(
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
      );
    },
  ));

  return Card(
      child: Column(
          children: <Widget>[productHeader, const Divider()] + productList));
}



void showPendingUI() {
  setState(() {
    _purchasePending = true;
  });
}
void handleError(IAPError error) {
  setState(() {
    _purchasePending = false;
  });
}

Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
  // IMPORTANT!! Always verify a purchase before delivering the product.
  // For the purpose of an example, we directly return true.
  return Future<bool>.value(true);
}

void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
  // handle invalid purchase here if  _verifyPurchase` failed.
}

Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList) async {
  for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
         // deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }
}
}

