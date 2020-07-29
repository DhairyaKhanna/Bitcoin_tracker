import 'package:flutter/material.dart';
import '../Networking/networking.dart';
import 'price_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    getCurrencyData();
    return Container(
      color: Colors.white,
      child: SpinKitFadingCircle(
        color: Colors.lightBlue,
        size: 100,
      ),
    );
  }

  void getCurrencyData() async {
    Network network = Network();

    var currencyData = await network.data('BTC', 'AUD');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PriceScreen('BTC', currencyData);
    }));
  }
}
