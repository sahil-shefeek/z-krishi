import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _cropNameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _cropNameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _cropNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFFE2B358)),
        ),
        backgroundColor: Color(0xFF14330A), // Custom AppBar color
        iconTheme: IconThemeData(color: Color(0xFFE2B358)), // Change back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color(0xFFE2B358),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color(0xFFE2B358),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Tell us something about yourself',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color(0xFFE2B358),
                  filled: true,
                ),
                maxLines: null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cropNameController,
                decoration: InputDecoration(
                  labelText: 'Current Growing Crop',
                  hintText: 'Enter the current growing crop',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color(0xFFE2B358),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _changeCropPhoto();
                },
                icon: Icon(Icons.photo_camera), // Icon for the button
                label: Text('Change Current Crop Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF14330A), // Correct property for background color
                  foregroundColor: Color(0xFFE2B358), // Correct property for text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Align the "Save Changes" button at the bottom of the screen
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges();
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF14330A), // Correct property for background color
                    foregroundColor: Color(0xFFE2B358), // Correct property for text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    // Implementation of saving changes
    Navigator.pop(context);
  }

  void _changeCropPhoto() {
    // Implementation of changing crop photo
    print('Change Current Crop Photo');
  }
}
