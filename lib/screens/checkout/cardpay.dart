import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import '../basket/cart_appbar.dart';
import '../checkout/componet/card_input_formatter.dart';
import '../checkout/componet/card_month_input_formatter.dart';
import '../checkout/componet/mastercard.dart';
import '../checkout/componet/my_painter.dart';
import '../checkout/constants.dart';
class CardPayScreen extends StatefulWidget {
  const CardPayScreen({Key? key}) : super(key: key);

  @override
  State<CardPayScreen> createState() => _CardPayScreenState();
}

class _CardPayScreenState extends State<CardPayScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderNameController = TextEditingController();
  final TextEditingController cardExpiryDateController = TextEditingController();
  final TextEditingController cardCvvController = TextEditingController();

  final FlipCardController flipCardController = FlipCardController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PaymentCard _paymentCard = PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
  var publicKey = 'sk_test_09dabdef043ee15ad1760940adce194ca3422dc3';
  final plugin = PaystackPlugin();
  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CartAppBar(heading: 'Pay with Card'),
              const SizedBox(height: 10),
              Text('Payment on test mode so your card wont be charged'),
              const SizedBox(height: 10),
              FlipCard(
                  fill: Fill.fillFront,
                  direction: FlipDirection.HORIZONTAL,
                  controller: flipCardController,
                  onFlip: () {
                    print('Flip');
                  },
                  flipOnTouch: false,
                  onFlipDone: (isFront) {
                    print('isFront: $isFront');
                  },
                  front: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: buildCreditCard(
                      color: kDarkBlue,
                      cardExpiration: cardExpiryDateController.text.isEmpty
                          ? "08/2022"
                          : cardExpiryDateController.text,
                      cardHolder: cardHolderNameController.text.isEmpty
                          ? "Card Holder"
                          : cardHolderNameController.text.toUpperCase(),
                      cardNumber: cardNumberController.text.isEmpty
                          ? "XXXX XXXX XXXX XXXX"
                          : cardNumberController.text,
                    ),
                  ),
                  back: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 4.0,
                      color: kDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Container(
                        height: 230,
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 0),
                            const Text(
                              'Test Payment',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                            Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            CustomPaint(
                              painter: MyPainter(),
                              child: SizedBox(
                                height: 35,
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      cardCvvController.text.isEmpty
                                          ? "322"
                                          : cardCvvController.text,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 21,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 40),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width / 1.12,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    hintText: 'Card Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.credit_card,
                      color: Colors.grey,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardInputFormatter(),
                  ],
                  onChanged: (value) {
                    var text = value.replaceAll(RegExp(r'\s+\b|\b\s'), ' ');
                    setState(() {
                      cardNumberController.value = cardNumberController.value
                          .copyWith(
                          text: text,
                          selection:
                          TextSelection.collapsed(offset: text.length),
                          composing: TextRange.empty);
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width / 1.12,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: cardHolderNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    hintText: 'Full Name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      cardHolderNameController.value =
                          cardHolderNameController.value.copyWith(
                              text: value,
                              selection:
                              TextSelection.collapsed(offset: value.length),
                              composing: TextRange.empty);
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 2.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: cardExpiryDateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: 'MM/YY',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardDateInputFormatter(),
                      ],
                      onChanged: (value) {
                        var text = value.replaceAll(RegExp(r'\s+\b|\b\s'), ' ');
                        setState(() {
                          cardExpiryDateController.value =
                              cardExpiryDateController.value.copyWith(
                                  text: text,
                                  selection: TextSelection.collapsed(
                                      offset: text.length),
                                  composing: TextRange.empty);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 2.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: cardCvvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: 'CVV',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onTap: () {
                        setState(() {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            flipCardController.toggleCard();
                          });
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          int length = value.length;
                          if (length == 4 || length == 9 || length == 14) {
                            cardNumberController.text = '$value ';
                            cardNumberController.selection =
                                TextSelection.fromPosition(
                                    TextPosition(offset: value.length + 1));
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20 * 9),
              InkWell(
                onTap: _chargeCard,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.yellow, Colors.orange],
                      ),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed:
                        _chargeCard,
                      child: Text(
                        'Pay',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ).animate().slideX(delay: 900.ms, duration: 800.ms).saturate(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String? accessCode;
  Future<String> getAccessCode() async {
    var publicKey = 'sk_test_09dabdef043ee15ad1760940adce194ca3422dc3';
    var url = 'https://api.paystack.co/transaction/initialize';

    var headers = {
      'Authorization': 'Bearer $publicKey',
      'Content-Type': 'application/json',
    };

    var body = {
      'amount': 2000, // Specify the amount for the payment
      'email': 'leowhiskey9@gmail.com', // Specify the customer's email
      'reference': _getReference(), // Generate a unique reference for the payment
    };

    var response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var accessCode = jsonResponse['data']['access_code'];
      print('access code dey');
      print('access code: $accessCode');
      return accessCode;

    } else {
      print('Failed to obtain access code');
      throw Exception('Failed to obtain access code');
    }
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: cardNumberController.text,
      cvc: cardCvvController.text,
      expiryMonth: int.parse(cardExpiryDateController.text.substring(0, 2)),
      expiryYear: int.parse(cardExpiryDateController.text.substring(cardExpiryDateController.text.length - 2)),
    );
  }

  String _getReference() {
    // Generate a unique reference for the payment
    // You can use a UUID package or any other method to generate the reference
    // For example:
    return 'payment-${DateTime.now().millisecondsSinceEpoch}';
  }

  _chargeCard() async {
    await getAccessCode();
    if (accessCode != null) {
    var charge = Charge()
      ..accessCode = accessCode!
      ..card = _getCardFromUI();
    charge
      ..amount = 2000 // Set the payment amount
      ..email = 'leowhiskey9@gmail.com'
      ..reference = _getReference()
      ..putCustomField('Charged From', 'Flutter PLUGIN');

    final paystackPlugin = PaystackPlugin();
    final response = await paystackPlugin.checkout(
      context,
      charge: charge,
      method: CheckoutMethod.card,
    );
    print('Response = $response');
    // Handle the payment response
    print('e no reach');
    if (response.status == true) {
      // Payment successful
      print('Success');
    } else {
      print('Failuire transact');
      // Payment failed
    }}else {

      // Handle the case when accessCode is null
    }
  }


}
