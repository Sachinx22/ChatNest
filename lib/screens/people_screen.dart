import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final TextEditingController searchController =
      TextEditingController();

  // Same 25 contacts used in ChatNest Chats
  final List<Map<String, dynamic>> users = [
    {'name': 'Rahul', 'online': true, 'status': 'Available'},
    {'name': 'Priya', 'online': true, 'status': 'Online'},
    {'name': 'Aman', 'online': false, 'status': 'Offline'},
    {'name': 'Neha', 'online': true, 'status': 'Available'},
    {'name': 'Rohan', 'online': false, 'status': 'Last seen recently'},
    {'name': 'Ananya', 'online': true, 'status': 'Available'},
    {'name': 'Arjun', 'online': true, 'status': 'Online'},
    {'name': 'Sneha', 'online': false, 'status': 'Offline'},
    {'name': 'Karan', 'online': true, 'status': 'Busy'},
    {'name': 'Pooja', 'online': true, 'status': 'Available'},
    {'name': 'Aditya', 'online': false, 'status': 'Offline'},
    {'name': 'Simran', 'online': true, 'status': 'Online'},
    {'name': 'Vikash', 'online': false, 'status': 'Last seen recently'},
    {'name': 'Kriti', 'online': true, 'status': 'Available'},
    {'name': 'Sahil', 'online': true, 'status': 'Online'},
    {'name': 'Isha', 'online': false, 'status': 'Offline'},
    {'name': 'Nikhil', 'online': true, 'status': 'Available'},
    {'name': 'Riya', 'online': true, 'status': 'Online'},
    {'name': 'Varun', 'online': false, 'status': 'Last seen recently'},
    {'name': 'Megha', 'online': true, 'status': 'Available'},
    {'name': 'Abhishek', 'online': false, 'status': 'Offline'},
    {'name': 'Shreya', 'online': true, 'status': 'Busy'},
    {'name': 'Manish', 'online': true, 'status': 'Available'},
    {'name': 'Tanya', 'online': true, 'status': 'Online'},
    {'name': 'Dev', 'online': false, 'status': 'Offline'},
  ];

  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();

    filteredUsers = users;

    loadNewContacts();
  }

  // Load contacts added from the Chats section
  Future<void> loadNewContacts() async {
    final prefs = await SharedPreferences.getInstance();

    final savedContacts =
        prefs.getStringList('newContacts') ?? [];

    for (final contact in savedContacts) {
      final parts = contact.split('|');

      if (parts.isEmpty) {
        continue;
      }

      final name = parts[0].trim();

      if (name.isEmpty) {
        continue;
      }

      // Prevent duplicate contacts
      final alreadyExists = users.any(
        (user) =>
            user['name'].toString().toLowerCase() ==
            name.toLowerCase(),
      );

      if (!alreadyExists) {
        users.add({
          'name': name,
          'online': false,
          'status': 'New contact',
          'phone': parts.length > 1 ? parts[1] : '',
          'email': parts.length > 2 ? parts[2] : '',
          'newContact': true,
        });
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      filteredUsers = users;
    });
  }

  void searchUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final name =
            user['name'].toString().toLowerCase();

        return name.contains(
          query.toLowerCase(),
        );
      }).toList();
    });
  }

  void openChat(String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userName: userName,
        ),
      ),
    );
  }

  // Voice call UI
  void startVoiceCall(String userName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Calling...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text('End Call'),
            ],
          ),
        );
      },
    );
  }

  // Video call UI
  void startVideoCall(String userName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Starting video call...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text('End Call'),
            ],
          ),
        );
      },
    );
  }

  void showUserDetails(
    Map<String, dynamic> user,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    user['name'][0],
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  user['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  user['status'],
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                if (user['phone'] != null &&
                    user['phone']
                        .toString()
                        .isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    user['phone'],
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],

                if (user['email'] != null &&
                    user['email']
                        .toString()
                        .isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user['email'],
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Start Chat
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      openChat(user['name']);
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text(
                      'Start Chat',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Call and Video Call
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          startVoiceCall(user['name']);
                        },
                        icon: const Icon(Icons.call),
                        label: const Text('Call'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          startVideoCall(user['name']);
                        },
                        icon: const Icon(Icons.videocam),
                        label: const Text('Video'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'People',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: searchUsers,
              decoration: InputDecoration(
                hintText: 'Search people...',

                prefixIcon: const Icon(
                  Icons.search,
                ),

                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              searchUsers('');
                            },
                            icon: const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
              ),
            ),
          ),

          // People list
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 60,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'No people found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Try searching another name',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        filteredUsers.length,
                    itemBuilder:
                        (context, index) {
                      final user =
                          filteredUsers[index];

                      return ListTile(
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),

                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 27,
                              child: Text(
                                user['name'][0],
                                style:
                                    const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            if (user['online'])
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    color:
                                        Colors.green,
                                    border:
                                        Border.all(
                                      color: Theme.of(
                                        context,
                                      )
                                          .scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        title: Text(
                          user['name'],
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          user['status'],
                        ),

                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Call',
                              icon: const Icon(
                                Icons.call,
                              ),
                              onPressed: () {
                                startVoiceCall(
                                  user['name'],
                                );
                              },
                            ),

                            IconButton(
                              tooltip: 'Video Call',
                              icon: const Icon(
                                Icons.videocam,
                              ),
                              onPressed: () {
                                startVideoCall(
                                  user['name'],
                                );
                              },
                            ),

                            IconButton(
                              tooltip: 'Chat',
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                              ),
                              onPressed: () {
                                openChat(
                                  user['name'],
                                );
                              },
                            ),
                          ],
                        ),

                        onTap: () {
                          showUserDetails(user);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}