import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/models/station_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  late Future<List<StationModel>> future;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController entryDateController = TextEditingController();
  final TextEditingController voltageController = TextEditingController();
  final TextEditingController currentController = TextEditingController();
  final TextEditingController powerController = TextEditingController();

  late AuthenticationProvider stationProvider;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    stationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    future = stationProvider.getAllStations();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      controller.text = _dateFormat.format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StationModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          } else {
            final stations = snapshot.data!;
            return ListView.builder(
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                return ListTile(
                  title: Text(station.address),
                  subtitle: Text('Voltage: ${station.voltage}'),
                  onTap: () {},
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: 'Enter Address',
                              labelStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 47, 95, 196)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: entryDateController,
                            decoration: InputDecoration(
                              labelText: 'Enter Entry Date',
                              labelStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 47, 95, 196)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await _selectDate(context, entryDateController);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: voltageController,
                            decoration: InputDecoration(
                              labelText: 'Enter Voltage',
                              labelStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 47, 95, 196)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: currentController,
                            decoration: InputDecoration(
                              labelText: 'Enter Current',
                              labelStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 47, 95, 196)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: powerController,
                            decoration: InputDecoration(
                              labelText: 'Enter Power',
                              labelStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 47, 95, 196)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final stationModel = StationModel(
                                stationId: DateTime.now().toString(),
                                address: addressController.text,
                                entryDate:
                                    DateTime.parse(entryDateController.text),
                                maintenanceDate: DateTime.now(),
                                lastMaintenanceDate: DateTime.now(),
                                voltage: voltageController.text,
                                current: currentController.text,
                                power: powerController.text,
                              );

                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);

                              await stationProvider.addStation(
                                stationModel: stationModel,
                                onSuccess: () {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Station Added Successfully'),
                                    ),
                                  );
                                  _clearControllers();
                                  Navigator.of(context).pop();
                                },
                                onFail: (error) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Failed to add Station: $error'),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  void _clearControllers() {
    addressController.clear();
    entryDateController.clear();
    voltageController.clear();
    currentController.clear();
    powerController.clear();
  }
}
