import 'package:flutter/material.dart';
import 'package:zkrishi/edit_profile_page.dart';
import 'package:zkrishi/grown_crops_history_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFE2B358), // #e2b358
        scaffoldBackgroundColor: Color(0xFF14330A), // #14330a
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF14330A), // #14330a
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF14330A), // #14330a
            foregroundColor: Color(0xFFE2B358), // white text color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final bool isInCommittee;
  final String committeeName;

  ProfilePage({this.isInCommittee = false, this.committeeName = ''});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedPlant;
  List<String> grownPlants = ['Tomato', 'Cucumber', 'Lettuce', 'Carrot'];
  int currentPlantIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Profile Image using NetworkImage
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://picsum.photos/seed/picsum/200/300'),
                ),
                SizedBox(height: 20),
                Text(
                  'John Doe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF14330A)),
                ),
                SizedBox(height: 10),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(fontSize: 18, color: Color(0xFF14330A),), // Change email text color to #14330a
                ),
                SizedBox(height: 20),
                if (widget.isInCommittee)
                  Text(
                    'Committee: ${widget.committeeName}',
                    style: TextStyle(fontSize: 18, color: Color(0xFF14330A),), // Change text color to #14330a
                  ),
                SizedBox(height: 20),
                Text(
                  'Bio: This is a short bio about John Doe.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF14330A),), // Change bio text color to #14330a
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GrownCropsHistoryPage()),
                        );
                      },
                      child: Text('Grown Crops History', style: TextStyle(color: Color(0xFF14330A))), // Change button text color to #14330a
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE2B358), // Change button color to #e2b358
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showCurrentPlantPhoto();
                      },
                      child: Text('Current Growing Plant', style: TextStyle(color: Color(0xFF14330A))), // Change button text color to #14330a
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE2B358), // Change button color to #e2b358
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                  child: Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF14330A), // #14330a
                    foregroundColor: Color(0xFFE2B358),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9, // Assuming you have 9 posts
              itemBuilder: (BuildContext context, int index) {
                String imageUrl = 'https://picsum.photos/200?random=$index';
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 8.0),
                      Text('Post ${index + 1}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrentPlantPhoto() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Current Growing Plant Photo using Image.network
                Image.network(
                  'https://picsum.photos/200?random=${currentPlantIndex}',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8.0),
                Text(grownPlants[currentPlantIndex]),
              ],
            ),
          ),
        );
      },
    );
  }
}
