import 'dart:convert';
import "package:http/http.dart" as http;
import 'dart:convert' as convert;
import 'package:transfer_news/Model/transfer.dart';

class TransferList {
  List<TransferModel> allTransfers = [];
  Future<void> getLatestTransfers() async {
    String url = "https://apitmindia.herokuapp.com/tran/transfers/?format=json";
    var response = await http.get(url);
    var jsonData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      jsonData.forEach(
        (element) {
          TransferModel transferModel = TransferModel(
            id: element["id"],
            name: element["names"],
            age: element["age"],
            playerImage: element["playerImage"],
            playerLink: element["playerLink"],
            fromTeam: element["fromTeam"],
            fromTeamImage: element["fromTeamImage"],
            toTeam: element["toTeam"],
            toTeamImage: element["toTeamImage"],
            position: element["position"],
            fee: element["fee"],
            date: element["date"],
          );
          allTransfers.add(transferModel);
        },
      );
    }
  }
}
