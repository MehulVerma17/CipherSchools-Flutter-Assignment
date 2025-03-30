import 'package:expense_tracker/controllers/user_controller.dart';
import 'package:expense_tracker/pages/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Profile Section
          _buildProfileHeader(),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _buildMenuItem(
                  Icons.person,
                  "Account",
                  Colors.purple.shade200,
                  context,
                ),
                _buildMenuItem(
                  Icons.settings,
                  "Settings",
                  Colors.purple.shade300,
                  context,
                ),
                _buildMenuItem(
                  Icons.upload,
                  "Export Data",
                  Colors.purple.shade400,
                  context,
                ),
                _buildMenuItem(
                  Icons.logout,
                  "Logout",
                  Colors.red.shade300,
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),

      child: Row(
        children: [
          // Profile Image
          Container(
            padding: const EdgeInsets.all(2), // Border padding
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purple, // Border color
                width: 2, // Border thickness
              ),
            ),
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final user = snapshot.data;

                return CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      user?.photoURL != null && user!.photoURL!.isNotEmpty
                          ? NetworkImage(user.photoURL!)
                          : const AssetImage('lib/images/default_profile.png'),
                );
              },
            ),
          ),

          SizedBox(width: 15),

          // Username and Edit
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Not Logged In");
              }
              final user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username", style: TextStyle(color: Colors.grey)),
                  Text(
                    user.displayName ?? 'No Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),

          Spacer(),

          // Edit Icon
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    Color color,
    BuildContext context,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () async {
          if (title == "Logout") {
            await UserController.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          }
        },
      ),
    );
  }
}
