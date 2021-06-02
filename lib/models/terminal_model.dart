import 'package:intl/intl.dart';

class TerminalModel {
  int terminalId;
  String terminalName;

  TerminalModel({this.terminalId, this.terminalName});

  factory TerminalModel.fromJson(Map<String, dynamic> json) {
    return TerminalModel(
      terminalId: json['id'],
      terminalName: json['terminal_name'],
    );
  }
}

class SearchRide {
  int startTerminal;
  int endTerminal;
  String dateTime;

  SearchRide({this.startTerminal, this.endTerminal, this.dateTime});

  factory SearchRide.fromJson(Map<String, dynamic> json) {
    return SearchRide(
      startTerminal: json['start_terminal'],
      endTerminal: json['end_terminal'],
      dateTime: json['travel_date'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'start_terminal': startTerminal,
      'end_terminal': endTerminal,
      'travel_date': dateTime,
    };
    return map;
  }
}
