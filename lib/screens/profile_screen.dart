import 'package:permission_handler/permission_handler.dart'; // Import permission handler
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import 'credit_card_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required String name, required String email, required String phone, required String address});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  File? _profileImage; // Variable to store the profile image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
      address = prefs.getString('address') ?? '';
      // Load profile picture if available
      String? profileImagePath = prefs.getString('profileImage');
      _profileImage = File(profileImagePath!);
        });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  // Show the profile image in a larger dialog when tapped
  void _viewProfileImage() {
    if (_profileImage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Image.file(_profileImage!), // Show the image in full screen
          );
        },
      );
    }
  }

  // Request permissions for camera and storage
  Future<void> _requestPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final photosPermission = await Permission.photos.request();

    if (cameraPermission.isGranted && photosPermission.isGranted) {
      _showImageSourceDialog(context);
    } else {
      // Permissions are denied, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions are required to pick an image")),
      );
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _saveProfileImage(pickedFile.path);
    }
  }

  // Take a photo with the camera
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _saveProfileImage(pickedFile.path);
    }
  }

  // Delete the profile picture
  void _deleteProfileImage() async {
    setState(() {
      _profileImage = null;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImage'); // Remove image path from SharedPreferences
  }

  // Save the selected profile image to SharedPreferences
  Future<void> _saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', path); // Save the image path
  }

  // Edit the user's profile data
  Future<void> _editProfile() async {
    final updatedData = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: name,
          email: email,
          phone: phone,
          address: address,
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        name = updatedData['name'] ?? name;
        email = updatedData['email'] ?? email;
        phone = updatedData['phone'] ?? phone;
        address = updatedData['address'] ?? address;
      });

      // Save the updated data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('phone', phone);
      await prefs.setString('address', address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // black icon in app bar
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture and Name Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _viewProfileImage, // Handle the tap to view the full image
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Profile Picture in a Circular Avatar
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!) // Use profile image if available
                                : AssetImage('assets/images/default_profile.png') as ImageProvider,
                            backgroundColor: Colors.grey, // Set a placeholder color if no image
                          ),
                          // Camera Icon for changing profile picture
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.blueGrey),
                            onPressed: () {
                              _requestPermissions(); // Request permissions before showing options
                            },
                            padding: EdgeInsets.zero,
                            iconSize: 32,
                            splashRadius: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // User's Name
                    Text(
                      name,  // Display the user's name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Black color for the text
                      ),
                    ),
                  ],
                ),
              ),

              // User Details Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileDetail(title: "Email", value: email),
                    _ProfileDetail(title: "Phone", value: phone),
                    _ProfileDetail(title: "Address", value: address),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Profile Options Section (Order History, Credit Card, Logout, Edit Profile)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _ProfileOption(
                      icon: Icons.edit,
                      title: "Edit Profile",
                      onTap: _editProfile, // Navigate to edit profile screen
                    ),
                    const Divider(color: Color.fromARGB(217, 214, 191, 175),),
                    _ProfileOption(
                      icon: Icons.history,
                      title: "Order History",
                      onTap: () {
                        // Navigate to order history page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Navigating to Order History")),
                        );
                      },
                    ),
                    const Divider(color: Color.fromARGB(217, 214, 191, 175),),
                    _ProfileOption(
                      icon: Icons.credit_card,
                      title: "Credit Card Information",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreditCardScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Color.fromARGB(217, 214, 191, 175),),
                    _ProfileOption(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: _logout, // Call logout function
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to choose between gallery, camera, or delete profile picture
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_album, color: Color.fromARGB(217, 214, 191, 175)),
                title: Text('Upload from Gallery', style: TextStyle(color: Colors.black)),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color.fromARGB(217, 214, 191, 175)),
                title: Text('Capture with Camera', style: TextStyle(color: Colors.black)),
                onTap: () {
                  _takePhoto();
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Color.fromARGB(217, 214, 191, 175)),
                title: Text('Delete Profile Picture', style: TextStyle(color: Colors.black)),
                onTap: () {
                  _deleteProfileImage();
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Profile Detail Widget
class _ProfileDetail extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileDetail({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

// Profile Option Widget (for actions like changing profile picture, etc.)
class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(217, 214, 191, 175)), // Beige icons
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, color: Colors.black), // Black text
      ),
      onTap: onTap,
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
    };

    Navigator.pop(context, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Centers the entire column
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 350),
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(217, 214, 191, 175)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 350),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(217, 214, 191, 175)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Phone
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 350),
                  labelText: 'Phone',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(217, 214, 191, 175)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Address
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 350),
                  labelText: 'Address',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(217, 214, 191, 175)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save Changes Button
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color.fromARGB(217, 214, 191, 175),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
