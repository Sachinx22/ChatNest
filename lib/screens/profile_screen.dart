import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String userName = 'ChatNest User';
  String userEmail = 'user@chatnest.com';

  String userBio =
      'Hey! I am using ChatNest';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Load data created during Sign Up
  Future<void> loadUserData() async {

    final prefs =
        await SharedPreferences.getInstance();

    final savedName =
        prefs.getString('loggedInUserName');

    final savedEmail =
        prefs.getString('loggedInUserEmail');

    final savedBio =
        prefs.getString('userBio');

    if (!mounted) return;

    setState(() {

      if (savedName != null &&
          savedName.isNotEmpty) {
        userName = savedName;
      }

      if (savedEmail != null &&
          savedEmail.isNotEmpty) {
        userEmail = savedEmail;
      }

      if (savedBio != null &&
          savedBio.isNotEmpty) {
        userBio = savedBio;
      }

    });
  }


  void showLogoutDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Logout',
          ),

          content: const Text(
            'Are you sure you want to logout?',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            TextButton(
              onPressed: () async {

                Navigator.pop(context);

                final prefs =
                    await SharedPreferences
                        .getInstance();

                await prefs.setBool(
                  'isLoggedIn',
                  false,
                );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logged out successfully',
                    ),
                  ),
                );

              },

              child: const Text(
                'Logout',
              ),
            ),

          ],
        );
      },
    );
  }


  void showEditProfile(BuildContext context) {

    final TextEditingController nameController =
        TextEditingController(
      text: userName,
    );

    final TextEditingController bioController =
        TextEditingController(
      text: userBio,
    );


    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Edit Profile',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(
                controller: nameController,

                decoration:
                    const InputDecoration(
                  labelText: 'Name',
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextField(
                controller: bioController,

                decoration:
                    const InputDecoration(
                  labelText: 'Bio',
                ),
              ),

            ],
          ),

          actions: [

            TextButton(
              onPressed: () async {

                final newName =
                    nameController.text.trim();

                final newBio =
                    bioController.text.trim();


                final prefs =
                    await SharedPreferences
                        .getInstance();


                if (newName.isNotEmpty) {

                  await prefs.setString(
                    'userName',
                    newName,
                  );

                  await prefs.setString(
                    'loggedInUserName',
                    newName,
                  );

                }


                if (newBio.isNotEmpty) {

                  await prefs.setString(
                    'userBio',
                    newBio,
                  );

                }


                setState(() {

                  if (newName.isNotEmpty) {
                    userName = newName;
                  }

                  if (newBio.isNotEmpty) {
                    userBio = newBio;
                  }

                });


                Navigator.pop(context);

              },

              child: const Text(
                'Save',
              ),
            ),

          ],
        );
      },
    );
  }


  void showShareProfile(BuildContext context) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile sharing feature coming soon',
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(
                height: 20,
              ),


              // Profile Header

              Card(

                elevation: 3,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Padding(

                  padding:
                      const EdgeInsets.all(24),

                  child: Column(

                    children: [

                      Stack(

                        children: [

                          const CircleAvatar(

                            radius: 60,

                            child: Icon(
                              Icons.person,
                              size: 65,
                            ),

                          ),


                          Positioned(

                            right: 0,
                            bottom: 0,

                            child: CircleAvatar(

                              radius: 18,

                              backgroundColor:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,

                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),

                            ),

                          ),

                        ],
                      ),


                      const SizedBox(
                        height: 20,
                      ),


                      // Signup Name

                      Text(

                        userName,

                        style:
                            const TextStyle(

                          fontSize: 25,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),


                      const SizedBox(
                        height: 6,
                      ),


                      // Signup Email

                      Text(

                        userEmail,

                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),

                      ),


                      const SizedBox(
                        height: 10,
                      ),


                      // Bio

                      Text(

                        userBio,

                        style:
                            const TextStyle(
                          fontSize: 14,
                        ),

                      ),

                    ],
                  ),
                ),
              ),


              const SizedBox(
                height: 25,
              ),


              // Edit Profile

              SizedBox(

                width: double.infinity,
                height: 50,

                child:
                    ElevatedButton.icon(

                  onPressed: () {
                    showEditProfile(context);
                  },

                  icon: const Icon(
                    Icons.edit,
                  ),

                  label: const Text(
                    'Edit Profile',
                  ),

                ),
              ),


              const SizedBox(
                height: 15,
              ),


              // Settings

              SizedBox(

                width: double.infinity,
                height: 50,

                child:
                    OutlinedButton.icon(

                  onPressed: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const SettingsScreen(),
                      ),
                    );

                  },

                  icon: const Icon(
                    Icons.settings,
                  ),

                  label: const Text(
                    'Settings',
                  ),

                ),
              ),


              const SizedBox(
                height: 20,
              ),


              // Account Information

              Card(

                child: Column(

                  children: [

                    const ListTile(

                      leading: Icon(
                        Icons.person_outline,
                      ),

                      title: Text(
                        'Account',
                      ),

                      subtitle: Text(
                        'Personal information',
                      ),

                    ),


                    const Divider(),


                    ListTile(

                      leading: const Icon(
                        Icons.email_outlined,
                      ),

                      title: const Text(
                        'Email',
                      ),

                      subtitle: Text(
                        userEmail,
                      ),

                    ),


                    const Divider(),


                    ListTile(

                      leading: const Icon(
                        Icons.share,
                      ),

                      title: const Text(
                        'Share Profile',
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),

                      onTap: () {
                        showShareProfile(context);
                      },

                    ),

                  ],
                ),
              ),


              const SizedBox(
                height: 20,
              ),


              // Logout

              SizedBox(

                width: double.infinity,
                height: 50,

                child:
                    OutlinedButton.icon(

                  onPressed: () {
                    showLogoutDialog(context);
                  },

                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),

                  label: const Text(

                    'Logout',

                    style: TextStyle(
                      color: Colors.red,
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
}