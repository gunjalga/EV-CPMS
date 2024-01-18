import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_cpms/main.dart';
import 'package:ev_cpms/route/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List locations = [];
  List<Map<String, dynamic>> locationListWithDistance = [];
  Position? mylocation;

  getData() async {
    await FirebaseFirestore.instance.collection('Chargers').get().then((value) {
      locations.addAll(value.docs);
    });

    sortByDistance(locations);
  }

  Future<double> distanceFromMyLocation(GeoPoint location) async {
    double distance = Geolocator.distanceBetween(mylocation!.longitude,
            mylocation!.latitude, location.longitude, location.latitude) /
        1000;
    return distance;
  }

  Future<List<Map<String, dynamic>>> sortByDistance(List locationlist) async {
    for (var location in locationlist) {
      double distance = await distanceFromMyLocation(location['coordinates']);
      locationListWithDistance.add({
        'location': location,
        'distance': distance,
      });
    }

    locationListWithDistance.sort((a, b) {
      double d1 = a['distance'];
      double d2 = b['distance'];
      if (d1 > d2) {
        return 1;
      } else if (d1 < d2) {
        return -1;
      } else {
        return 0;
      }
    });

    setState(() {});
    return locationListWithDistance;
  }

  Future<void> _handleLocationPermission() async {
    final isLocationGranted = await Permission.location.isGranted;

    if (!isLocationGranted) {
      final status = await Permission.location.request();
      if (status == PermissionStatus.denied) {
        _handleLocationPermission();
      } else {
        Geolocator.openAppSettings();
      }
    }

    mylocation = await Geolocator.getCurrentPosition();
  }

  Future<void> init() async {
    await _handleLocationPermission();
    getData();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EV-CPMS'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DrawerHeader(
                child: Icon(
              Icons.person,
              size: 80,
              color: Colors.green.shade300,
            )),
            Text(
              FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              title: const Text(
                'My Bookings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pop(context);
                appRouter.push(OrderPageRoute());
              },
            ),
            const Divider(),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                appRouter.pushAndPopUntil(const LoginPageRoute(),
                    predicate: (_) => false);
              },
              label: const Text('Logout'),
              icon: Icon(
                Icons.logout,
                color: Colors.green.shade300,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            itemCount: locationListWithDistance.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  appRouter.push(ChargerDetailsRoute(
                      chargerDetails: locationListWithDistance[index]
                          ['location'],
                      distance: locationListWithDistance[index]['distance']));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    color: Colors.grey.shade100,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locationListWithDistance[index]['location']
                                    ['name'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                locationListWithDistance[index]['distance']
                                        .toStringAsFixed(2) +
                                    ' km',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
