import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_cpms/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key, this.data});
  final dynamic data;

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  DateTime startDate = DateTime.now();
  DateTime _selectedDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, 0, 0, 0, 0, 0, 0);
  String? selectedRadio;
  final client = http.Client();

  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        DateFormat.yMd().add_jm().format(_selectedDateTime);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        elevation: 1.0,
        title: const Text('Reserve Charger'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "When do you need to Reserve?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1)),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              actions: [
                                Container(
                                  color: Colors.white,
                                  height: 180,
                                  child: CupertinoDatePicker(
                                      minimumYear: 1900,
                                      initialDateTime: _selectedDateTime,
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (dateTime2) =>
                                          _selectedDateTime =
                                              _selectedDateTime.copyWith(
                                                  year: dateTime2.year,
                                                  month: dateTime2.month,
                                                  day: dateTime2.day)),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Done'),
                                onPressed: () {
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                            'Selected Date: ${formattedDateTime.split(' ')[0]}',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.start),
                      ),
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "At What Time?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1),
                    ),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return child!;
                            },
                          );
                          if (selectedTime != null) {
                            _selectedDateTime = _selectedDateTime.copyWith(
                                hour: selectedTime.hour,
                                minute: selectedTime.minute);
                            setState(() {});
                          }
                        },
                        child: Text(
                            'Selected Time: ${formattedDateTime.split(' ')[1] + ' ' + formattedDateTime.split(' ')[2]}',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.start),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Colors.green.shade100,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(width: 1),
              ),
              child: Column(
                children: [
                  ...widget.data['connectors'].entries.map((e) => RadioListTile(
                        groupValue: e.value['status'] == 'Available'
                            ? selectedRadio
                            : 0,
                        title: Row(
                          children: [
                            Text(
                              e.value['name'],
                              style: e.value['status'] == 'Available'
                                  ? null
                                  : const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Text(
                              e.value['status'],
                              style: e.value['status'] == 'Available'
                                  ? null
                                  : const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        value: e.key,
                        onChanged: (val) async {
                          setState(() {
                            selectedRadio = val;
                          });
                        },
                      )),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green.shade300),
              elevation: const MaterialStatePropertyAll(10),
            ),
            onPressed: () async {
              if (selectedRadio != null) {
                if (!await checkDocumentExists()) {
                  var url = Uri.parse(
                      "http://192.168.165.205:3000/reserveCharger?chargerid=${widget.data!['chargerId']}&connectorid=${selectedRadio}&idTag=1234&reservationId=8879&dateTime=${_selectedDateTime.add(Duration(minutes: 1))}");
                  var response = await client.get(url);
                  log(response.body);

                  await FirebaseFirestore.instance.collection('Orders').add({
                    'slotTime': _selectedDateTime.millisecondsSinceEpoch,
                    'bookTime': DateTime.now().millisecondsSinceEpoch,
                    'userId': FirebaseAuth.instance.currentUser?.uid,
                    'orderStatus': 'Booked',
                    'connectorId': selectedRadio,
                    'chargerId': widget.data['chargerId'],
                    'chargerAddress': widget.data['address'],
                    'chargerName': widget.data['name'],
                    'chargerCoordinates': widget.data['coordinates'],
                    'phoneNumber':
                        FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
                  });
                  appRouter.popUntilRoot();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your reservation booked successfully!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select different slot!'),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select connector'),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Reserve",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> checkDocumentExists() async {
    final query = FirebaseFirestore.instance
        .collection('Orders')
        .where('slotTime', isEqualTo: _selectedDateTime.millisecondsSinceEpoch)
        .where(
          'connectorId',
          isEqualTo: selectedRadio,
        );

    final querySnapshot = await query.get();

    return querySnapshot.docs.isNotEmpty;
  }
}
