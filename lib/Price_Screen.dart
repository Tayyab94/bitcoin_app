import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
//6: Update the default currency to AUD, the first item in the currencyList.
  String SelectedCurrency = 'AUD';

  //Dropdown for Android App
  DropdownButton<String> androidDrodown()
  {
    List<DropdownMenuItem<String>> dropdownItem = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String Currency = currenciesList[i];
      var newItems = DropdownMenuItem(
        child: Text(Currency),
        value: Currency,
      );

      dropdownItem.add(newItems);
    }
    return DropdownButton<String>(
      value: SelectedCurrency,
      items: dropdownItem,
      onChanged: (value) {
        setState(() {
          SelectedCurrency = value;
          getData();
        });
      },
    );
  }

  //Dropdown For IOS APP
  CupertinoPicker IosPicker()
  {
    List<Text> pickerItems=[];

    for(String currency in currenciesList)
    {
      pickerItems.add(Text(currency));
    }
    return  CupertinoPicker(    // Make Dropdown
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);

        setState(() {
          //1: Save the selected currency to the property selectedCurrency

          SelectedCurrency=currenciesList[selectedIndex];

          getData();
        });
      },
      children:pickerItems,
    );
  }



  Widget getPicker()
  {
    if(Platform.isIOS)
      {
        return IosPicker();
      }
    else if(Platform.isAndroid)
      {
        return androidDrodown();
      }
  }

  //12. Create a variable to hold the value and use in our Text Widget.
  //    Give the variable a starting value of '?' before the data comes back from the async methods.

  String bitcoinValueInUSD='?';



  //value had to be updated into a Map to store the values of all three cryptocurrencies.
  Map<String,String>coinValue={};

  //7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. First we have to create a variable to keep track of when we're waiting on the request to complete.
  bool isWaiting = false;

  //11. Create an async method here await the coin data from coin_data.dart
  void getData()async{
    isWaiting=true;
    try{
          var data=await CoinData().getCoinData(SelectedCurrency);

          isWaiting=false;

      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
     //   bitcoinValueInUSD=data.toStringAsFixed(0);
          coinValue=data;
      });
    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  void initState()
  {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                cryptoCurrency:'BTC',
                value: isWaiting? '?':coinValue['BTC'],
                SelectedCurrency: SelectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency:'ETH',
                value: isWaiting? '?':coinValue['ETH'],
                SelectedCurrency: SelectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency:'LTC',
                value: isWaiting? '?':coinValue['LTC'],
                SelectedCurrency: SelectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30),
            color: Colors.lightBlue,
            child:Platform.isIOS? IosPicker(): androidDrodown(),
          ),
        ],
      ),
    );
  }
}


// this code is use to make dropdwon in Android PHoen AppBa, In replace of it we have added cupertinoPicker (Fluter's Package)



//1: Refactor this Padding Widget into a separate Stateless Widget called CryptoCard,
// so we can create 3 of them, one for each cryptocurrency.

class CryptoCard extends StatelessWidget {

  const CryptoCard({this.value, this.SelectedCurrency, this .cryptoCurrency});
  final String value;
  final String SelectedCurrency;
  final String cryptoCurrency;
  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          child: Text(
            '1 $cryptoCurrency = $value $SelectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

