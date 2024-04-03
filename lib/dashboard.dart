import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'know_your_soil.dart'; // Import SoilAnalysisPage
import 'package:carousel_slider/carousel_slider.dart';

class CarouselItem {
  final String imageUrl;
  final String caption;

  CarouselItem({required this.imageUrl, required this.caption});
}

class Dashboard extends StatelessWidget {
  final List<CarouselItem> carouselItems = [
    CarouselItem(
      imageUrl:
          'data:image/jpeg;base64,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',
      caption: 'Curremt Plantations',
    ),
    CarouselItem(
      imageUrl: '',
      caption: 'Irrigation Cycle',
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
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

            Container(
              height: 100.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                child: Center(
                  child: Text('Current Weather'),
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
