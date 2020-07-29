import 'package:http/http.dart' as http;

const apikey = 'DC1073A2-25D7-4C19-A3CD-E433B8AE4FE8';

class Network {
  Future<dynamic> data(String crypto_type, String nameOfCurrency) async {
    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/$crypto_type/$nameOfCurrency?apikey=$apikey');

    try {
      if (response.statusCode == 200) {
        dynamic body = response.body;
        return body;
      } else if (response.statusCode == 429) {
        print(
            'Too many requests -- You have exceeded your API key rate limits');
        return;
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    } catch (e) {}
  }
}
