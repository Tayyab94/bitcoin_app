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


  //11. Create an async method here await the coin data from coin_data.dart

  void getData()async{
    try{
          double data=await CoinData().getCoinData(SelectedCurrency);
      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        bitcoinValueInUSD=data.toStringAsFixed(0);
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
          Padding(
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
                  '1 BTC = $bitcoinValueInUSD USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30),
            color: Colors.lightBlue,
            child:getPicker(),
          ),
        ],
      ),
    );
  }
}


// this code is use to make dropdwon in Android PHoen AppBa, In replace of it we have added cupertinoPicker (Fluter's Package)

