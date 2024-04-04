import 'package:flutter/material.dart';
import 'home_page.dart';
import 'posts_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'know_your_soil.dart'; // Import SoilAnalysisPage
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'almanac_page.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';

class CarouselItem {
  final String imageUrl;
  final String caption;
  final String nextWateringTime;

  CarouselItem({
    required this.imageUrl,
    required this.caption,
    required this.nextWateringTime,
  });
}

class Weather {
  final String temperature;
  final String description;

  Weather({required this.temperature, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toString(),
      description: json['weather'][0]['description'],
    );
  }
}

Future<Weather> fetchWeather(BuildContext context) async {
  // Request location permission
  await requestLocationPermission(context);

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  final response = await http.get(Uri.parse(
      'http://api.weatherapi.com/v1/current.json?q=${position.latitude},${position.longitude}&aqi=no&key=0f1509fb217b4f759bc15224240404'));

  if (response.statusCode == 200) {
    var results = jsonDecode(response.body);
    return Weather(
      temperature: results['current']['temp_c'].toString(),
      description: results['current']['condition']['text'],
    );
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<void> requestLocationPermission(BuildContext context) async {
  final permission = Permission.location;

  if (await permission.isDenied) {
    // We didn't ask for permission yet or the permission was denied before but not permanently.
    final result = await permission.request();

    if (result.isGranted) {
      // Permission granted
    } else if (result.isDenied) {
      // Permission denied
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permission Denied"),
            content: Text(
                "This app needs location permission to fetch weather data."),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (result.isPermanentlyDenied) {
      // Permission permanently denied, open app settings.
      openAppSettings();
    }
  }
}

class InteractableCard extends StatelessWidget {
  final CarouselItem item;

  InteractableCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event, e.g., navigate to a detailed view
      },
      child: Card(
        child: Column(
          children: [
            Image.network(item.imageUrl),
            Text(item.caption),
            Text('Next Watering Time: ${item.nextWateringTime}'),
          ],
        ),
      ),
    );
  }
}

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled; don't continue
      // accessing the position and request users to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied; don't continue accessing the position.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever; handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFE2B358), // #e2b358
        scaffoldBackgroundColor: Color(0xFFFFFFFF), // white
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF14330A), // #14330a
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE2B358), // #e2b358
            foregroundColor: Color(0xFF14330A), // #14330a
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFF14330A)), // #14330a
          bodyText2: TextStyle(color: Color(0xFF14330A)), // #14330a
        ),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  final List<CarouselItem> carouselItems = [
    CarouselItem(
      imageUrl:
          'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQQ1Sf_OtY4eWd9_Sjrrj1voNE6dlgCuZ7Vyh5yqxPPXopsMk71',
      caption: 'Tulsi',
      nextWateringTime: 'Tomorrow at 10 AM',
    ),
    CarouselItem(
      imageUrl:
          'https://m.media-amazon.com/images/I/61ubgWjZ44L._AC_UF1000,1000_QL80_.jpg',
      caption: 'Neem',
      nextWateringTime: 'In 3 days at 2 PM',
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF14330A), // #14330a
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              'Welcome back user!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE2B358), // #e2b358
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    _showNotificationsPopover(context);
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFE2B358), // #e2b358
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Color(0xFFE2B358), // #e2b358
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: CarouselSlider.builder(
                itemCount: carouselItems.length,
                itemBuilder:
                    (BuildContext context, int index, int pageViewIndex) {
                  return InteractableCard(item: carouselItems[index]);
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 1.0,
                  initialPage: 2,
                ),
              ),
            ),

            SizedBox(height: 20), // Add gap here

            FutureBuilder<Weather>(
              future: fetchWeather(context), // Pass the context here
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF033704), // #033704
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0, // Remove elevation to maintain a flat appearance
                        child: Center(
                          child: Text(
                            'Current Weather: ${snapshot.data!.temperature}°C, ${snapshot.data!.description}',
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),

            SizedBox(height: 20), // Add gap here

            // User's Current Plants Section
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: carouselItems.map((item) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.4, // Adjust the width as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFF033704), // #033704
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: 0.3, // 30% opacity
                          child: Image.network(
                            item.imageUrl,
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.caption,
                          style: TextStyle(
                            color: Color(0xFF033704), // #033704
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            // Placeholder for other sections
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostsPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.storefront),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarketplacePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.nature),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SoilAnalysisPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsPopover(BuildContext context) {
    // Logic to show notifications popover
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notifications"),
          content: Text(
              "No new notifications"), // Replace with actual notifications logic
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
