import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nicstore/cart_page.dart';
import 'package:nicstore/cart_model.dart';
import 'package:nicstore/models/ItemModel.dart';
import 'package:nicstore/utils/hexcolor.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = true;
  List<ItemModel> _todos = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await context.read<CartModel>().configureAmplify();
    await _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    List<ItemModel> todofromDB = await context.read<CartModel>().fetchAllToDo();
    setState(() {
      _isLoading = false;
      _todos = todofromDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        ),
        backgroundColor: Colors.black,
        child: const Icon(Icons.shopping_bag),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Good morning'),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Let's order fresh items for you",
                      style: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(thickness: 4),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Fresh items",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Consumer<CartModel>(
                      builder: (context, value, child) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.3,
                          ),
                          itemCount: _todos.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (BuildContext context, int index) {
                            return GroceryItemTile(
                              itemName: _todos[index].name,
                              itemPrice: _todos[index].price.toString(),
                              imagePath: _todos[index].image.toString(),
                              hexColor: _todos[index].color.toString(),
                              onPressed: () {
                                Provider.of<CartModel>(context, listen: false)
                                    .addItemToChart(index);
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class GroceryItemTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final String hexColor;
  final Function()? onPressed;

  const GroceryItemTile({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.hexColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: HexColor(hexColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(imagePath, height: 64),
            Text(itemName),
            MaterialButton(
              onPressed: onPressed,
              color: HexColor(hexColor).withOpacity(0.8),
              child: Text(
                '\$ $itemPrice',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
