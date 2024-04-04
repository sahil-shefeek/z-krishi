import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'know_your_soil.dart'; // Import SoilAnalysisPage
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back user!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showNotificationsPopover(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 220, // Set a fixed height for the carousel
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

            FutureBuilder<Weather>(
              future: fetchWeather(context), // Pass the context here
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      child: Center(
                        child: Text(
                            'Current Weather: ${snapshot.data!.temperature}°C, ${snapshot.data!.description}'),
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

            // User's Current Plants Section
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Number of current plants
                itemBuilder: (BuildContext context, int index) {
                  // Replace this with your card for each current plant
                  return Card(
                    child: Center(
                      child: Text('Current Plant $index'),
                    ),
                  );
                },
              ),
            ),
            // Placeholder for other sections
            Text(
              'More sections can be added here...',
              style: TextStyle(fontSize: 18.0),
            ),
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
