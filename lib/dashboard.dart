import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'know_your_soil.dart'; // Import SoilAnalysisPage
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';

class CarouselItem {
  final String imageUrl;
  final String caption;

  CarouselItem({required this.imageUrl, required this.caption});
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Location Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                Position position = await _locationService.getCurrentLocation();
                print(position); // Use the position or show it on your UI
              } catch (e) {
                print(e); // Handle the error
              }
            },
            child: Text('Get Location'),
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final List<CarouselItem> carouselItems = [
    CarouselItem(
      imageUrl: 'https://picsum.photos/id/237/200/300',
      caption: 'Curremt Plantations',
    ),
    CarouselItem(
      imageUrl: '',
      caption: 'Irrigation Cycle',
    ),
    // Add more items as needed
  ];

  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fetchAndShowCurrentLocation(context));

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
            SizedBox(height: 20.0),
            Text(
              'Welcome back!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Almanac Section

            CarouselSlider.builder(
              itemCount: carouselItems.length,
              itemBuilder:
                  (BuildContext context, int index, int pageViewIndex) {
                if (carouselItems[index].imageUrl.isEmpty) {
                  // Display a CircularProgressIndicator for this item
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber, // Background color of the container
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        // Material 3 design color and stroke width
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 4,
                      ),
                    ),
                  );
                } else {
                  // Display the image and caption for non-empty imageUrl
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.network(
                          carouselItems[index].imageUrl,
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            carouselItems[index].caption,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2.0,
                initialPage: 2,
              ),
            ),

            SizedBox(
              height: 100.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor:
                          Colors.white, // Text Color (Foreground color)
                    ),
                    onPressed: () {
                      // This is where you navigate to the WeatherScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WeatherScreen()),
                      );
                    },
                    child: Text('Check Current Weather'),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.0),
            // Current Weather Section

            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
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
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
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

  void _fetchAndShowCurrentLocation(BuildContext context) async {
    try {
      Position position = await _locationService.getCurrentLocation();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Current Location"),
          content:
              Text("Lat: ${position.latitude}, Long: ${position.longitude}"),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Failed to get current location: $e");
      // Handle error or notify the user
    }
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
