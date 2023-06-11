import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentCardForm extends StatefulWidget {
  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
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
      appBar: AppBar(
        title: Text('Payment Card Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a card number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _paymentCard.number = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Expiration Date',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the expiration date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _paymentCard.expiryMonth = int.parse(value!.split('/')[0]);
                  _paymentCard.expiryYear = int.parse(value.split('/')[1]);
                },

              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the CVV';
                  }
                  return null;
                },
                onSaved: (value) {
                  _paymentCard.cvc = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _processPayment,
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Use _paymentCard to perform the payment process
      // e.g., call PaystackPlugin.checkout()
    }
  }



}