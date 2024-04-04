import 'package:flutter/material.dart';

class GrownCropsHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grown Crops History',
          style: TextStyle(color: Color(0xFFE2B358)), // Change title color to Color(0xFFE2B358)
        ),
        backgroundColor: Color(0xFF14330A), // Customize the AppBar color
        iconTheme: IconThemeData(color: Color(0xFFE2B358)), // Change back button color to Color(0xFFE2B358)
      ),
      backgroundColor: Color(0xFFE2B358), // Set the background color of the page to Color(0xFFE2B358)
      body: ListView.builder(
        itemCount: 4, // Replace with the actual number of crops
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _showEnlargedPhoto(context, index);
            },
            child: ListTile(
              title: Text(
                'Crop ${index + 1}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Customize text style
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'), // Replace with actual image URL
                radius: 30, // Increase the size of the avatar
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF14330A)), // Add an arrow icon
            ),
          );
        },
      ),
    );
  }

  void _showEnlargedPhoto(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners for the dialog
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: Color(0xFFE2B358), // Set the background color of the dialog to Color(0xFFE2B358)
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enlarged Photo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Customize text style
                ),
                SizedBox(height: 20),
                Image.network(
                  'https://picsum.photos/200', // Replace with actual image URL
                  height: 200, // Adjust the height as needed
                  width: 200, // Adjust the width as needed
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF14330A), // #14330a
                    foregroundColor: Color(0xFFE2B358), // Text color
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
