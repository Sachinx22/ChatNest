import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  Position? currentPosition;

  bool isLoading = false;
  String locationMessage = 'Location not detected yet';

  // Get current location
  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
      locationMessage = 'Getting your location...';
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          isLoading = false;
          locationMessage =
              'Please turn ON your location service.';
        });

        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          isLoading = false;
          locationMessage =
              'Location permission was denied.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isLoading = false;
          locationMessage =
              'Location permission is permanently denied.';
        });

        await Geolocator.openAppSettings();
        return;
      }

      Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        currentPosition = position;
        isLoading = false;
        locationMessage =
            'Your current location has been detected.';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        locationMessage =
            'Unable to get your location.';
      });
    }
  }

  // Open Google Maps search
  Future<void> openGoogleMapsSearch(
    String searchText,
  ) async {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please get your location first.',
          ),
        ),
      );
      return;
    }

    final latitude = currentPosition!.latitude;
    final longitude = currentPosition!.longitude;

    final encodedSearch =
        Uri.encodeComponent(searchText);

    final Uri mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/'
      '?api=1'
      '&query=$encodedSearch'
      '&center=$latitude,$longitude',
    );

    try {
      final bool opened = await launchUrl(
        mapsUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        throw Exception(
          'Unable to open Google Maps',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open Google Maps.',
          ),
        ),
      );
    }
  }

  // Open category search screen
  void openCategory(String category) {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please get your location first.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySearchScreen(
          category: category,
          currentPosition: currentPosition!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearby',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: Column(
                children: [
                  Container(
                    height: 85,
                    width: 85,

                    decoration:
                        const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Explore Nearby',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Find hospitals, colleges, '
                    'food shops and other places near you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Location status
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),

                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: Row(
                children: [
                  Icon(
                    currentPosition != null
                        ? Icons.check_circle
                        : Icons.location_searching,
                    color:
                        currentPosition != null
                            ? Colors.green
                            : Colors.orange,
                    size: 30,
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      locationMessage,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Get location button
            SizedBox(
              height: 55,

              child: ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : getCurrentLocation,

                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.my_location,
                      ),

                label: Text(
                  isLoading
                      ? 'Getting Location...'
                      : currentPosition == null
                          ? 'Get My Location'
                          : 'Update My Location',
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'What are you looking for?',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Select a category to search nearby places.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            // Hospitals
            categoryCard(
              icon: Icons.local_hospital,
              title: 'Hospitals',
              subtitle: 'Search nearby hospitals',
              color: Colors.red,
              onTap: () {
                openCategory('Hospitals');
              },
            ),

            const SizedBox(height: 12),

            // Colleges
            categoryCard(
              icon: Icons.school,
              title: 'Colleges',
              subtitle: 'Search nearby colleges',
              color: Colors.blue,
              onTap: () {
                openCategory('Colleges');
              },
            ),

            const SizedBox(height: 12),

            // Food
            categoryCard(
              icon: Icons.restaurant,
              title: 'Food Shops',
              subtitle: 'Search restaurants and food',
              color: Colors.orange,
              onTap: () {
                openCategory('Food Shops');
              },
            ),

            const SizedBox(height: 12),

            // KIIT
            categoryCard(
              icon: Icons.location_city,
              title: 'KIIT Campuses',
              subtitle: 'Search KIIT campuses',
              color: Colors.purple,
              onTap: () {
                openCategory('KIIT Campuses');
              },
            ),

            const SizedBox(height: 12),

            // All places
            categoryCard(
              icon: Icons.explore,
              title: 'All Places',
              subtitle: 'Search places near you',
              color: Colors.green,
              onTap: () {
                openCategory('All Places');
              },
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Your current location is used '
                      'to search nearby places. '
                      'Google Maps will handle the '
                      'actual route and navigation.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category card
  Widget categoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,

              decoration: BoxDecoration(
                color:
                    color.withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// CATEGORY SEARCH SCREEN
// =====================================================

class CategorySearchScreen extends StatefulWidget {
  final String category;
  final Position currentPosition;

  const CategorySearchScreen({
    super.key,
    required this.category,
    required this.currentPosition,
  });

  @override
  State<CategorySearchScreen> createState() =>
      _CategorySearchScreenState();
}

class _CategorySearchScreenState
    extends State<CategorySearchScreen> {
  late TextEditingController searchController;

  late String hintText;

  @override
  void initState() {
    super.initState();

    searchController =
        TextEditingController();

    if (widget.category == 'Hospitals') {
      hintText =
          'Search hospital name...';
    } else if (widget.category == 'Colleges') {
      hintText =
          'Search college name...';
    } else if (widget.category == 'Food Shops') {
      hintText =
          'Search restaurant or food shop...';
    } else if (widget.category ==
        'KIIT Campuses') {
      hintText =
          'Search KIIT campus...';
    } else {
      hintText =
          'Search any place...';
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Search in Google Maps
  Future<void> searchPlace() async {
    String searchText =
        searchController.text.trim();

    if (searchText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a place name.',
          ),
        ),
      );
      return;
    }

    final latitude =
        widget.currentPosition.latitude;

    final longitude =
        widget.currentPosition.longitude;

    final encodedSearch =
        Uri.encodeComponent(searchText);

    final Uri mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/'
      '?api=1'
      '&query=$encodedSearch'
      '&center=$latitude,$longitude',
    );

    try {
      final bool opened = await launchUrl(
        mapsUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        throw Exception(
          'Could not open Google Maps',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open Google Maps.',
          ),
        ),
      );
    }
  }

  // Search nearby category
  Future<void> searchNearbyCategory() async {
    String categorySearch;

    if (widget.category == 'Hospitals') {
      categorySearch =
          'hospitals near me';
    } else if (widget.category == 'Colleges') {
      categorySearch =
          'colleges near me';
    } else if (widget.category == 'Food Shops') {
      categorySearch =
          'restaurants near me';
    } else if (widget.category ==
        'KIIT Campuses') {
      categorySearch =
          'KIIT campuses Bhubaneswar';
    } else {
      categorySearch =
          'places near me';
    }

    searchController.text =
        categorySearch;

    await searchPlace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            // Search title
            Text(
              'Search ${widget.category}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Enter the name of the place you want '
              'to find.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            // Search box
            TextField(
              controller: searchController,

              textInputAction:
                  TextInputAction.search,

              onSubmitted: (_) {
                searchPlace();
              },

              decoration: InputDecoration(
                hintText: hintText,

                prefixIcon: const Icon(
                  Icons.search,
                ),

                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),

                  onPressed: () {
                    searchController.clear();
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color:
                        Colors.grey.shade300,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Search button
            SizedBox(
              height: 55,

              child: ElevatedButton.icon(
                onPressed: searchPlace,

                icon: const Icon(
                  Icons.search,
                ),

                label: const Text(
                  'Search Place',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Nearby category button
            SizedBox(
              height: 55,

              child: OutlinedButton.icon(
                onPressed:
                    searchNearbyCategory,

                icon: const Icon(
                  Icons.my_location,
                ),

                label: Text(
                  'Find Nearby ${widget.category}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),

                style:
                    OutlinedButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Location information
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Searching around your current '
                      'location:\n'
                      '${widget.currentPosition.latitude.toStringAsFixed(5)}, '
                      '${widget.currentPosition.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Information
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    'How it works',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    '1. Enter a place name.\n'
                    '2. ChatNest uses your current location.\n'
                    '3. Google Maps shows the matching place.\n'
                    '4. Google Maps can then show the route.',
                    style: TextStyle(
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}