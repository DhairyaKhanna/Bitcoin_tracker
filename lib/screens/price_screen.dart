import 'dart:convert';
import 'package:bitcointracker/Networking/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../Networking/networking.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  PriceScreen(this.basequote, this.currencydata);
  final currencydata;
  final basequote;

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  int currency_rate;
  String currency_name = 'AUD';
  int rate;
  int rate1;
  int rate2;
  String selectedCurrency = 'AUD';

  Network network = Network();

  updateUI(String name, dynamic result) {
    if (result == null) {
      rate = 0;
      rate1 = 0;
      rate2 = 0;
      return;
    }

    setState(() {
      double currency = jsonDecode(result)['rate'];
      if (name == cryptoList[0]) {
        rate = currency.toInt();
      } else if (name == cryptoList[1]) {
        rate1 = currency.toInt();
      } else if (name == cryptoList[2]) {
        rate2 = currency.toInt();
      }
    });
  }

  void onChanged(String selectedvalue) async {
    Network network = Network();
    for (int i = 0; i < cryptoList.length; i++) {
      var result = await network.data(cryptoList[i], selectedvalue);
      updateUI(cryptoList[i], result);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.basequote, widget.currencydata);
    onChanged('AUD');
  }

  DropdownButton android() {
    List<DropdownMenuItem<String>> dropdownitems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];

      var newitem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownitems.add(newitem);
    }

    return DropdownButton<String>(
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.indigo, size: 40),
      iconDisabledColor: Colors.grey,
      value: selectedCurrency,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.indigo,
      ),
      items: dropdownitems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        onChanged(selectedCurrency);
      },
    );
  }

  CupertinoPicker ios() {
    List<Widget> getItems = [];

    for (String item in currenciesList) {
      getItems.add(Text(item));
    }

    return CupertinoPicker(
        itemExtent: 40,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            currency_name = currenciesList[selectedIndex];
            onChanged(currency_name);
          });
        },
        children: getItems);
  }

  Widget platform() {
    if (Platform.isIOS == true) {
      return ios();
    } else if (Platform.isAndroid == true) {
      return android();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Crypto_card(rate, currency_name, cryptoList[0]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
            child: Crypto_card(rate1, currency_name, cryptoList[1]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
            child: Crypto_card(rate2, currency_name, cryptoList[2]),
          ),
          SizedBox(
            height: 252,
          ),
          Container(
              height: 150.0,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: ios()),
        ],
      ),
    );
  }
}

class Crypto_card extends StatelessWidget {
  Crypto_card(
      this.rateofselectedCurrency, this.currency, this.cryptocurrencyname);

  final int rateofselectedCurrency;
  final String currency;
  final String cryptocurrencyname;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptocurrencyname = $rateofselectedCurrency $currency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
