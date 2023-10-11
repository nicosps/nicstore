import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nicstore/amplifyconfiguration.dart';
import 'package:nicstore/models/ModelProvider.dart';

class CartModel extends ChangeNotifier {
  List<ItemModel> posts = <ItemModel>[];
  List<ItemModel> cartItems = <ItemModel>[];

  configureAmplify() async {
    final dataStorePlugin = AmplifyDataStore(
      modelProvider: ModelProvider.instance,
    );
    final AmplifyAPI apiPlugin = AmplifyAPI();

    await Amplify.addPlugins([dataStorePlugin, apiPlugin]);
    await Amplify.configure(amplifyconfig);

    print('amplify configured');
  }

  Future fetchAllToDo() async {
    try {
      posts = await Amplify.DataStore.query(ItemModel.classType);
      return posts;
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  // get cartItems => _cartItems;

  void addItemToChart(int index) {
    cartItems.add(posts[index]);
    notifyListeners();
  }

  void removeItemToChart(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i].price.toString());
    }

    return totalPrice.toStringAsFixed(2);
  }
}
