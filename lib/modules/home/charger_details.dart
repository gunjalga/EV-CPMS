import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_cpms/main.dart';
import 'package:ev_cpms/route/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';

import 'widgets/key_value_widget.dart';

class ChargerDetails extends StatefulWidget {
  const ChargerDetails(
      {super.key, required this.chargerDetails, required this.distance});
  final DocumentSnapshot chargerDetails;
  final double distance;

  @override
  State<ChargerDetails> createState() => _ChargerDetailsState();
}

class _ChargerDetailsState extends State<ChargerDetails> {
  final client = http.Client();
  String selectedRadio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charger Details'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          MapsLauncher.launchCoordinates(
              widget.chargerDetails['coordinates'].latitude,
              widget.chargerDetails['coordinates'].longitude);
        },
        backgroundColor: Colors.green.shade100,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.pin_drop,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            widget.chargerDetails['photo'] != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.chargerDetails['photo'],
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.charging_station_outlined,
                    size: 100,
                  ),
            KeyValueWidget(
              name: 'Name : ',
              value: widget.chargerDetails['name'],
            ),
            KeyValueWidget(
              name: 'Address : ',
              value: widget.chargerDetails['address'],
            ),
            KeyValueWidget(
              name: 'Distance : ',
              value: '${widget.distance.toStringAsFixed(2)} km',
            ),
            KeyValueWidget(
              name: 'Charger Type : ',
              value: widget.chargerDetails['chargerType'],
            ),
            KeyValueWidget(
              name: 'Wattage : ',
              value: widget.chargerDetails['wattage'].toString(),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Chargers')
                  .doc(widget.chargerDetails['chargerId'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                Map chargerDetail = snapshot.data!['connectors'];

                return Column(
                  children: [
                    KeyValueWidget(
                      name: 'Charger Status : ',
                      value: snapshot.data!['chargerStatus'],
                    ),
                    Card(
                      color: Colors.green.shade100,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(width: 1),
                      ),
                      child: Column(
                        children: [
                          ...chargerDetail.entries.map((e) => RadioListTile(
                                groupValue: e.value['status'] == 'Available'
                                    ? selectedRadio
                                    : '-1',
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
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedRadio != '') {
                            var url = Uri.parse(
                                "http://192.168.165.205:3000/startCharging?chargerid=${snapshot.data!['chargerId']}");
                            var response = await client.get(url);
                            await FirebaseFirestore.instance
                                .collection('Chargers')
                                .doc(snapshot.data!.id)
                                .update({
                              "connectors.${selectedRadio}.status": 'off'
                            });
                            await FirebaseFirestore.instance
                                .collection('Orders')
                                .add({
                              'slotTime': DateTime.now().millisecondsSinceEpoch,
                              'bookTime': DateTime.now().millisecondsSinceEpoch,
                              'userId': FirebaseAuth.instance.currentUser?.uid,
                              'orderStatus': 'OnGoing',
                              'connectorId': selectedRadio,
                              'chargerId': snapshot.data?['chargerId'],
                              'chargerAddress': snapshot.data?['address'],
                              'chargerName': snapshot.data?['name'],
                              'chargerCoordinates':
                                  snapshot.data?['coordinates'],
                              'phoneNumber': FirebaseAuth
                                      .instance.currentUser?.phoneNumber ??
                                  '',
                            });
                            appRouter.pop();
                            log(response.body);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select connector'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade200,
                            elevation: 10,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 13)),
                        child: const Text(
                          "Start Charging",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       var url = Uri.parse(
                    //           "http://192.168.236.205:3000/stopCharging?chargerid=${snapshot.data!['chargerId']}&txId=1234");
                    //       var response = await client.get(url);
                    //       log(response.body);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.green.shade200,
                    //         elevation: 10,
                    //         shape: const StadiumBorder(),
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 50, vertical: 13)),
                    //     child: const Text(
                    //       "Stop Charging",
                    //       style: TextStyle(color: Colors.black, fontSize: 16),
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () => appRouter
                            .push(ReservePageRoute(data: snapshot.data)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade200,
                            elevation: 10,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 13)),
                        child: const Text(
                          "Reserve Charger",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
