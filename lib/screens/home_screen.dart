import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
import 'people_screen.dart';
import 'nearby_screen.dart';
import 'profile_screen.dart';

class _ChatNestColors {
  static const Color green = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F5E9);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  bool isSearching = false;

  final TextEditingController searchController =
      TextEditingController();

  // 25 sample chats
  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Rahul',
      'message': 'Hey! How are you?',
      'time': '10:30 AM',
      'online': true,
      'unread': 2,
    },
    {
      'name': 'Priya',
      'message': 'See you tomorrow!',
      'time': '9:45 AM',
      'online': true,
      'unread': 0,
    },
    {
      'name': 'Aman',
      'message': 'Did you complete the project?',
      'time': 'Yesterday',
      'online': false,
      'unread': 4,
    },
    {
      'name': 'Neha',
      'message': 'Okay, no problem.',
      'time': 'Yesterday',
      'online': false,
      'unread': 0,
    },
    {
      'name': 'Rohan',
      'message': 'Let me know when you are free.',
      'time': 'Monday',
      'online': true,
      'unread': 1,
    },
    {
      'name': 'Ananya',
      'message': 'Good morning 😊',
      'time': 'Monday',
      'online': true,
      'unread': 0,
    },
    {
      'name': 'Arjun',
      'message': 'Where are you?',
      'time': 'Sunday',
      'online': false,
      'unread': 3,
    },
    {
      'name': 'Sneha',
      'message': 'Thank you so much!',
      'time': 'Sunday',
      'online': true,
      'unread': 0,
    },
    {
      'name': 'Karan',
      'message': 'Are you coming to college?',
      'time': 'Saturday',
      'online': true,
      'unread': 2,
    },
    {
      'name': 'Pooja',
      'message': 'I will call you later.',
      'time': 'Saturday',
      'online': false,
      'unread': 0,
    },
    {
      'name': 'Aditya',
      'message': 'The class starts at 10.',
      'time': 'Friday',
      'online': true,
      'unread': 5,
    },
    {
      'name': 'Simran',
      'message': 'That sounds great!',
      'time': 'Friday',
      'online': false,
      'unread': 0,
    },
    {
      'name': 'Vikash',
      'message': 'Did you finish the assignment?',
      'time': 'Thursday',
      'online': true,
      'unread': 1,
    },
    {
      'name': 'Kriti',
      'message': 'See you in the lab.',
      'time': 'Thursday',
      'online': false,
      'unread': 0,
    },
    {
      'name': 'Sahil',
      'message': 'Can you help me?',
      'time': 'Wednesday',
      'online': true,
      'unread': 3,
    },
    {
      'name': 'Isha',
      'message': 'Good night! 🌙',
      'time': 'Wednesday',
      'online': false,
      'unread': 0,
    },
    {
      'name': 'Nikhil',
      'message': 'Let us work on the project.',
      'time': 'Tuesday',
      'online': true,
      'unread': 2,
    },
    {
      'name': 'Riya',
      'message': 'Okay, I understand.',
      'time': 'Tuesday',
      'online': true,
      'unread': 0,
    },
    {
      'name': 'Varun',
      'message': 'What are you doing?',
      'time': 'Monday',
      'online': false,
      'unread': 4,
    },
    {
      'name': 'Megha',
      'message': 'I am on my way.',
      'time': 'Monday',
      'online': true,
      'unread': 0,
    },
    {
      'name': 'Abhishek',
      'message': 'Have you seen the notice?',
      'time': 'Sunday',
      'online': false,
      'unread': 1,
    },
    {
      'name': 'Shreya',
      'message': 'Yes, I will be there.',
      'time': 'Sunday',
      'online': true,
      'unread': 0,
    },
    {
      'name': 'Manish',
      'message': 'Let us meet tomorrow.',
      'time': 'Saturday',
      'online': false,
      'unread': 2,
    },
    {
      'name': 'Tanya',
      'message': 'Hey! Are you free?',
      'time': 'Saturday',
      'online': true,
      'unread': 3,
    },
    {
      'name': 'Dev',
      'message': 'Okay, talk to you later.',
      'time': 'Friday',
      'online': false,
      'unread': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadNewContacts();
  }

  // Load contacts that were added by the user
  Future<void> loadNewContacts() async {
    final prefs = await SharedPreferences.getInstance();

    final savedContacts =
        prefs.getStringList('newContacts') ?? [];

    for (final contact in savedContacts) {
      final parts = contact.split('|');

      if (parts.length >= 3) {
        final name = parts[0];
        final phone = parts[1];
        final email = parts[2];

        // Avoid duplicate contacts
        final alreadyExists = chats.any(
          (chat) => chat['name'] == name,
        );

        if (!alreadyExists) {
          chats.add({
            'name': name,
            'message': 'New contact',
            'time': 'Now',
            'online': false,
            'unread': 0,
            'phone': phone,
            'email': email,
            'newContact': true,
          });
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // Add new contact
  Future<void> addNewContact() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Contact',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon:
                        const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon:
                        const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _ChatNestColors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final name =
                    nameController.text.trim();
                final phone =
                    phoneController.text.trim();
                final email =
                    emailController.text.trim();

                if (name.isEmpty ||
                    phone.isEmpty ||
                    email.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all fields',
                      ),
                    ),
                  );
                  return;
                }

                if (!email.contains('@')) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a valid email',
                      ),
                    ),
                  );
                  return;
                }

                // Check duplicate
                final alreadyExists = chats.any(
                  (chat) =>
                      chat['name']
                          .toString()
                          .toLowerCase() ==
                      name.toLowerCase(),
                );

                if (alreadyExists) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This contact already exists',
                      ),
                    ),
                  );
                  return;
                }

                final prefs =
                    await SharedPreferences
                        .getInstance();

                final savedContacts =
                    prefs.getStringList(
                          'newContacts',
                        ) ??
                        [];

                savedContacts.add(
                  '$name|$phone|$email',
                );

                await prefs.setStringList(
                  'newContacts',
                  savedContacts,
                );

                // Add to current Chats list
                setState(() {
                  chats.add({
                    'name': name,
                    'message': 'New contact',
                    'time': 'Now',
                    'online': false,
                    'unread': 0,
                    'phone': phone,
                    'email': email,
                    'newContact': true,
                  });
                });

                if (mounted) {
                  Navigator.pop(context, true);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        '$name added successfully',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Add Contact',
              ),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();

    if (result == true) {
      // Contact has been added successfully.
    }
  }

  // Search chats
  List<Map<String, dynamic>> get filteredChats {
    final query =
        searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return chats;
    }

    return chats.where((chat) {
      final name =
          chat['name'].toString().toLowerCase();

      final message =
          chat['message'].toString().toLowerCase();

      return name.contains(query) ||
          message.contains(query);
    }).toList();
  }

  // Total unread messages
  int get totalUnreadMessages {
    int total = 0;

    for (final chat in chats) {
      total += chat['unread'] as int;
    }

    return total;
  }

  // Open chat
  void openChat(String userName) {
    final selectedChat = chats.firstWhere(
      (chat) => chat['name'] == userName,
    );

    // Opening the chat marks it as read.
    setState(() {
      selectedChat['unread'] = 0;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userName: userName,
        ),
      ),
    );
  }

  // New chat
  void startNewChat() {
    setState(() {
      selectedIndex = 1;
    });
  }

  // Start search
  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  // Stop search
  void stopSearch() {
    searchController.clear();

    setState(() {
      isSearching = false;
    });
  }

  // More menu
  void showMoreMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.mark_chat_read,
                ),
                title: const Text(
                  'Mark all as read',
                ),
                onTap: () {
                  setState(() {
                    for (final chat in chats) {
                      chat['unread'] = 0;
                    }
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'All chats marked as read',
                      ),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.refresh,
                ),
                title: const Text(
                  'Refresh chats',
                ),
                onTap: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Chats refreshed',
                      ),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                ),
                title: const Text(
                  'About ChatNest',
                ),
                onTap: () {
                  Navigator.pop(context);

                  showAboutDialog(
                    context: context,
                    applicationName: 'ChatNest',
                    applicationVersion: '1.0.0',
                    applicationIcon:
                        const Icon(
                      Icons.chat_bubble,
                    ),
                    children: const [
                      Text(
                        'ChatNest is a simple and friendly chat application.',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Chat list
  Widget buildChatList() {
    final visibleChats = filteredChats;

    if (visibleChats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 60,
                color: Colors.grey.shade400,
              ),

              const SizedBox(height: 15),

              const Text(
                'No chats found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Try searching with another name or message.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 90,
      ),
      itemCount: visibleChats.length,
      itemBuilder: (context, index) {
        final chat = visibleChats[index];

        final String name = chat['name'];
        final String message = chat['message'];
        final String time = chat['time'];
        final bool online = chat['online'];
        final int unread = chat['unread'];

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),

          // Profile picture
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor:
                    _ChatNestColors.lightGreen,
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _ChatNestColors.green,
                  ),
                ),
              ),

              if (online)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration:
                        BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Name + time
          title: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                    color: unread > 0
                        ? _ChatNestColors.green
                        : null,
                  ),
                ),
              ),

              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: unread > 0
                      ? _ChatNestColors.green
                      : Colors.grey,
                  fontWeight: unread > 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),

          // Message + unread count
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: unread > 0
                        ? null
                        : Colors.grey,
                    fontWeight: unread > 0
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),

              if (unread > 0) ...[
                const SizedBox(width: 8),

                Container(
                  constraints:
                      const BoxConstraints(
                    minWidth: 22,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration:
                      BoxDecoration(
                    color: _ChatNestColors.green,
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Text(
                    unread > 99
                        ? '99+'
                        : '$unread',
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),

          onTap: () {
            openChat(name);
          },
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
    String pageTitle;

    if (selectedIndex == 0) {
      pageTitle = 'Chats';
    } else if (selectedIndex == 1) {
      pageTitle = 'People';
    } else if (selectedIndex == 2) {
      pageTitle = 'Nearby';
    } else {
      pageTitle = 'Profile';
    }

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(
              primary: _ChatNestColors.green,
            ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              _ChatNestColors.green,
          foregroundColor: Colors.white,
          titleSpacing: 16,

          // Title / search
          title: isSearching &&
                  selectedIndex == 0
              ? TextField(
                  controller:
                      searchController,
                  autofocus: true,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Search chats...',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                    ),
                    border:
                        InputBorder.none,
                  ),
                )
              : Row(
                  children: [
                    Text(
                      pageTitle,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    if (selectedIndex == 0 &&
                        totalUnreadMessages > 0) ...[
                      const SizedBox(width: 8),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Text(
                          '$totalUnreadMessages',
                          style:
                              const TextStyle(
                            color:
                                _ChatNestColors.green,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

          // Actions
          actions: [
            // Add Contact button
            if (selectedIndex == 0 &&
                !isSearching)
              IconButton(
                onPressed: addNewContact,
                icon: const Icon(
                  Icons.person_add,
                ),
                tooltip: 'Add Contact',
              ),

            if (selectedIndex == 0)
              IconButton(
                onPressed: isSearching
                    ? stopSearch
                    : startSearch,
                icon: Icon(
                  isSearching
                      ? Icons.close
                      : Icons.search,
                ),
                tooltip: isSearching
                    ? 'Close search'
                    : 'Search',
              ),

            if (selectedIndex == 0 &&
                !isSearching)
              IconButton(
                onPressed: showMoreMenu,
                icon: const Icon(
                  Icons.more_vert,
                ),
                tooltip: 'More options',
              ),
          ],
        ),

        // Body
        body: selectedIndex == 0
            ? buildChatList()
            : selectedIndex == 1
                ? const PeopleScreen()
                : selectedIndex == 2
                    ? const NearbyScreen()
                    : const ProfileScreen(),

        // New chat button
        floatingActionButton:
            selectedIndex == 0
                ? FloatingActionButton(
                    backgroundColor:
                        _ChatNestColors.green,
                    foregroundColor:
                        Colors.white,
                    onPressed: startNewChat,
                    tooltip: 'New chat',
                    child: const Icon(
                      Icons.chat,
                    ),
                  )
                : null,

        // Bottom navigation
        bottomNavigationBar:
            NavigationBar(
          selectedIndex:
              selectedIndex,

          indicatorColor:
              _ChatNestColors.lightGreen,

          onDestinationSelected:
              (index) {
            setState(() {
              selectedIndex = index;

              if (index != 0 &&
                  isSearching) {
                searchController.clear();
                isSearching = false;
              }
            });
          },

          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              selectedIcon: Icon(
                Icons.chat_bubble,
                color:
                    _ChatNestColors.green,
              ),
              label: 'Chats',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.people_outline,
              ),
              selectedIcon: Icon(
                Icons.people,
                color:
                    _ChatNestColors.green,
              ),
              label: 'People',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.location_on_outlined,
              ),
              selectedIcon: Icon(
                Icons.location_on,
                color:
                    _ChatNestColors.green,
              ),
              label: 'Nearby',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
              ),
              selectedIcon: Icon(
                Icons.person,
                color:
                    _ChatNestColors.green,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}