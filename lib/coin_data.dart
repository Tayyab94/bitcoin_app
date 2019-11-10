import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const bitcoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future getCoinData1() async {

    //4. Create a url combining the bitcoinAverageURl with the currencies we're interested, BTC to USD.
    String requestURL='$bitcoinAverageURL/BTCUSD';

    //5. Make a GET request to the URL and wait for the response.
    http.Response response= await http.get(requestURL);

    //6. Check that the request was successful.

    if(response.statusCode==200)
      {
        //7. Use the 'dart:convert' package to decode the JSON data that comes back from BitcoinAverage.

        var decodeData=convert.jsonDecode(response.body);

        //8. Get the last price of bitcoin with the key 'last'.

        var lastPrice=decodeData['last'];

        //9. Output the lastPrice from the method.

        return lastPrice;
      }
    else
      {
        //10. Handle any errors that occur during the request
        
        print(response.statusCode);
        //Optional: throw an error if our request fails.
        throw 'Problem With the get request';
      }
  }


  //3: Update getCoinData to take the selectedCurrency as an input
  Future getCoinData2(String selectedCurrency) async {

    //4: Update the URL to use the selectedCurrency input.
    String requestURL='$bitcoinAverageURL/BTC$selectedCurrency';

    //5. Make a GET request to the URL and wait for the response.
    http.Response response= await http.get(requestURL);

    //6. Check that the request was successful.

    if(response.statusCode==200)
    {
      //7. Use the 'dart:convert' package to decode the JSON data that comes back from BitcoinAverage.


      var decodeData=convert.jsonDecode(response.body);

      //8. Get the last price of bitcoin with the key 'last'.

      var lastPrice=decodeData['last'];

      //9. Output the lastPrice from the method.

      return lastPrice;
    }
    else
    {
      //10. Handle any errors that occur during the request

      print(response.statusCode);
      //Optional: throw an error if our request fails.
      throw 'Problem With the get request';
    }
  }

  //3: Update getCoinData to take the selectedCurrency as an input
  Future getCoinData(String selectedCurrency) async {
    //4: Use a for loop here to loop through the cryptoList and request the data for each of them in turn.
    //5: Return a Map of the results instead of a single value.

    Map<String,String>cryptoPrice={};

    for(String crypto in cryptoList)
      {
        //Update the URL to use the crypto symbol from the cryptoList

        String requestURL='$bitcoinAverageURL/$crypto$selectedCurrency';
        //5. Make a GET request to the URL and wait for the response.
        http.Response response= await http.get(requestURL);

        //6. Check that the request was successful.


        if(response.statusCode==200)
        {
          //7. Use the 'dart:convert' package to decode the JSON data that comes back from BitcoinAverage.


          var decodeData=convert.jsonDecode(response.body);

          //8. Get the last price of bitcoin with the key 'last'.

          var lastPrice=decodeData['last'];

          //9. Output the lastPrice from the method.

       //   return lastPrice;

          //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
          cryptoPrice[crypto] = lastPrice.toStringAsFixed(0);

        }
        else
        {
          //10. Handle any errors that occur during the request

          print(response.statusCode);
          //Optional: throw an error if our request fails.
          throw 'Problem With the get request';
        }
        return cryptoPrice;
      }
  }
}

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];
