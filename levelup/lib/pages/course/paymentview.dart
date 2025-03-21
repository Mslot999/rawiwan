import 'package:LevelUp/components/choice_card.dart';
import 'package:LevelUp/models/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Paymentview extends StatefulWidget {
  @override
  State<Paymentview> createState() => _PaymentviewState();
}

class _PaymentviewState extends State<Paymentview> {
  bool needTaxInvoice = false;
  int paymethod = -1;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController taxIdController = TextEditingController();

  String? nameError;
  String? taxIdError;
  String? paymentMethodError;

  @override
  Widget build(BuildContext context) {
    final List<CourseItem> items =
        ModalRoute.of(context)?.settings.arguments as List<CourseItem>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        foregroundColor: Color(0xFF295F98),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Text('Your cart is empty.'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              item.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Price: ฿${item.price.toStringAsFixed(2)}'),
                                Text('Tutor: ${item.tutorName}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SwitchListTile(
                    activeColor: Theme.of(context).colorScheme.primary,
                    title: Text('Tax Invoice'),
                    value: needTaxInvoice,
                    onChanged: (bool value) {
                      setState(() {
                        needTaxInvoice = value;
                        nameError = null;
                        taxIdError = null;
                        if (!needTaxInvoice) {
                          nameController.clear();
                          taxIdController.clear();
                        }
                      });
                    },
                  ),
                  if (needTaxInvoice) ...[
                    Container(
                      width: 380,
                      child: TextField(
                        controller: nameController,
                        enabled: needTaxInvoice,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          errorText: nameError,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 380,
                      child: TextField(
                        controller: taxIdController,
                        enabled: needTaxInvoice,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                          labelText: 'Tax ID Number',
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          errorText: taxIdError,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  ChoiceCard(
                    choiceData: ChoiceData(
                      title: 'Payment Method',
                      choices: [
                        'Mobile Banking',
                        'QR PromtPay',
                        'Credit/Debit Card',
                      ],
                      groupValue: paymethod,
                      onChanged: (int newValue) {
                        setState(() {
                          paymethod = newValue;
                          paymentMethodError = null;
                        });
                      },
                    ),
                  ),
                  if (paymentMethodError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        paymentMethodError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items: ${items.length} pcs',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '฿${NumberFormat("#,##0.00").format(items.fold(0.0, (sum, item) => sum + item.price))}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF295F98)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (needTaxInvoice) {
                          nameError = nameController.text.isEmpty
                              ? 'Please enter your name'
                              : null;
                          taxIdError = taxIdController.text.isEmpty
                              ? 'Please enter your Tax ID Number'
                              : null;
                        } else {
                          nameError = null;
                          taxIdError = null;
                        }

                        paymentMethodError = paymethod == -1
                            ? 'Please select a payment method'
                            : null;
                      });

                      if (items.isNotEmpty &&
                          (needTaxInvoice == false ||
                              (nameError == null && taxIdError == null)) &&
                          paymentMethodError == null) {
                        final courseProvider =
                            Provider.of<CourseProvider>(context, listen: false);
                        for (var item in items) {
                          courseProvider.isPurchased(item.course_id);
                          courseProvider.removeItemFromCart(item.course_id);
                          courseProvider.purchaseAllCourses(
                              items.map((item) => item.course_id).toList());
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment successful!')),
                        );
                        courseProvider.confirmPurchase;
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please fill in all required fields.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF295F98),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Confirm Payment'),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    taxIdController.dispose();
    super.dispose();
  }
}
