import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_cpms/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> orderStream =
      FirebaseFirestore.instance.collection('Orders').snapshots();
  final client = http.Client();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = {
                'id': document.id,
                ...document.data()! as Map<String, dynamic>
              };

              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 3.0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0E9E0B)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['id'],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                data['orderStatus'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').add_jm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    data['slotTime'])),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: const Color(0xFF616161)),
                          ),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Text(
                          //     "Track your Professional",
                          //     style: K14_text_style.copyWith(
                          //         color: Color(0xFF0D176E),
                          //         decoration: TextDecoration.underline),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                      '${data['chargerName']}: ${data['chargerAddress']}')),
                              if (data['orderStatus'] == 'OnGoing' ||
                                  data['orderStatus'] == 'Reserved')
                                TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.red.shade400,
                                        padding: const EdgeInsets.all(8.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0))),
                                    onPressed: () async {
                                      var url = Uri.parse(
                                          "http://192.168.165.205:3000/stopCharging?chargerid=${data['chargerId']}&txId=1234");
                                      var response = await client.get(url);
                                      log(response.body);
                                      await FirebaseFirestore.instance
                                          .collection('Orders')
                                          .doc(data['id'])
                                          .update({
                                        'orderStatus': 'Completed',
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('Chargers')
                                          .doc(data['chargerId'])
                                          .update({
                                        "connectors.${data['connectorId']}.status":
                                            'Available'
                                      });
                                      appRouter.pop();
                                    },
                                    child: Text(
                                      "Stop Charging",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.white),
                                    )),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  )
                  // Card(
                  //     shape: RoundedRectangleBorder(
                  //       side: const BorderSide(color: Colors.grey),
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //     child: ListTile(
                  //       title: Wrap(
                  //         children: [
                  //           Text(data['id']),
                  //           SizedBox(
                  //             width: 10,
                  //           ),
                  //           Text(data['chargerName'] ?? "")
                  //         ],
                  //       ),
                  //       subtitle: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //               'Slot Time : ${DateFormat('dd-MM-yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(data['slotTime']))}'),
                  //           Divider(),
                  //           Text(data['chargerAddress'] ?? "")
                  //         ],
                  //       ),
                  //       trailing: Text(data['orderStatus']),
                  //     )),
                  );
            }).toList(),
          );
        },
      ),
    );
  }
}
