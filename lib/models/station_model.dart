import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stegmessage/constants.dart';

class StationModel {
  final String address;
  final String stationId;
  final DateTime entryDate;
  final DateTime maintenanceDate;
  final DateTime lastMaintenanceDate;
  final String voltage;
  final String current;
  final String power;

  StationModel({
    required this.stationId,
    required this.address,
    required this.entryDate,
    required this.maintenanceDate,
    required this.lastMaintenanceDate,
    required this.voltage,
    required this.current,
    required this.power,
  });

  // map
  Map<String, dynamic> toMap() {
    return {
      Constants.stationID: stationId,
      Constants.addresss: address,
      Constants.entryDate: entryDate,
      Constants.maintenanceDate: maintenanceDate,
      Constants.lastMaintenanceDate: lastMaintenanceDate,
      Constants.voltage: voltage,
      Constants.current: current,
      Constants.power: power,
    };
  }

  // from map
  factory StationModel.fromMap(Map<String, dynamic> map) {
    return StationModel(
      address: map[Constants.addresss] ?? '',
      stationId: map[Constants.stationID] ?? '',
      entryDate: (map[Constants.entryDate] as Timestamp).toDate(),
      maintenanceDate: (map[Constants.maintenanceDate] as Timestamp).toDate(),
      lastMaintenanceDate:
          (map[Constants.lastMaintenanceDate] as Timestamp).toDate(),
      voltage: map[Constants.voltage] ?? '',
      current: map[Constants.current] ?? '',
      power: map[Constants.power] ?? '',
    );
  }
}
