import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_provider.dart';

class Cartview extends StatefulWidget {
  @override
  _CartviewState createState() => _CartviewState();
}

class _CartviewState extends State<Cartview> {
  bool _isDeletePressed = false;

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final cartItems = courseProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        foregroundColor: Color(0xFF295F98),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: _isDeletePressed ? Colors.red : Colors.black,
            ),
            onPressed: () {
              _showConfirmationDialog(context);
              _setDeletePressedState();
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Image.asset(
                            item.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.name),
                          subtitle:
                              Text('Price: ฿${item.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              courseProvider.removeItemFromCart(item.course_id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Total: ฿${courseProvider.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment',
                        arguments: cartItems);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF295F98),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Checkout'),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to clear the cart?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Provider.of<CourseProvider>(context, listen: false).clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('All items have been removed from your cart.')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setDeletePressedState() {
    setState(() {
      _isDeletePressed = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isDeletePressed = false;
      });
    });
  }
}
