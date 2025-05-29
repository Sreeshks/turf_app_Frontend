import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:turf2/screens/profile.dart';
import 'package:turf2/screens/promotional_banner.dart';
import 'package:turf2/widgets/placeholder_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentBannerIndex = 0;
  bool _showSlots = true;
  final String _currentAddress = 'Koramangala, Bengaluru';
  bool _showLocationDialog = true; // Controls whether to show the location permission dialog

  final List<Map<String, dynamic>> _sportCategories = [
    {'name': 'Football', 'image': 'assets/football.jpg'},
    {'name': 'Cricket', 'image': 'assets/cricket.jpg'},
    {'name': 'Hockey', 'image': 'assets/hockey.jpg'},
    {'name': 'Badminton', 'image': 'assets/badminton.jpg'},
    {'name': 'Basketball', 'image': 'assets/basketball.jpg'},
    {'name': 'Tennis', 'image': 'assets/tennis.jpg'},
  ];
  
  final List<Map<String, dynamic>> _promotions = [
    {
      'title': 'Games Drops',
      'subtitle': 'Discount games for you to join now →',
      'image': 'assets/123.jpg',
    },
    {
      'title': 'Weekend Special',
      'subtitle': 'Book now and get 20% off on weekends →',
      'image': 'assets/BG.jpg',
    },
    {
      'title': 'Group Bookings',
      'subtitle': 'Special rates for team bookings →',
      'image': 'assets/BG.jpg',
    },
  ];
  
  final List<Map<String, dynamic>> _turfList = [
    {
      'name': 'The Sport Habitat',
      'distance': '7.5 km',
      'location': '1548 Stiger Dr, Mesa',
      'sport': 'Basketball',
      'rating': 4.2,
      'reviews': 1333,
      'image': 'assets/1.jpg',
    },
    {
      'name': 'Coolulu TurfPark',
      'distance': '5.2 km',
      'location': '3rd Cross Rd, Jakkasandra',
      'sport': 'Football',
      'rating': 4.5,
      'reviews': 987,
      'image': 'assets/2.jpg',
    },
    {
      'name': 'Kiara Sports World',
      'distance': '3.8 km',
      'location': '8th Block, Bengaluru',
      'sport': 'Cricket',
      'rating': 4.7,
      'reviews': 1156,
      'image': 'assets/3.jpg',
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        Scaffold(
          backgroundColor: const Color(0xFF1C1C1E),
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildSportsCategories(),
                      const SizedBox(height: 24),
                      _buildPromotionalBanner(),
                      const SizedBox(height: 24),
                      _buildNearbyTurfsHeader(),
                      const SizedBox(height: 16),
                      _buildToggleButtons(),
                      const SizedBox(height: 16),
                      ..._buildTurfList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Location permission dialog with transparent background
        if (_showLocationDialog)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: _buildLocationPermissionDialog(),
              ),
            ),
          ),
      ],
    );
  }
  
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: const Color(0xFF00854A),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _currentAddress,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(), // Replace with your ProfileScreen class
      ),
    );
  },
  child: Icon(
    Icons.person_2_outlined,
    color: Colors.white,
    size: 22,
  ),
)

          ),
        ],
      ),
    );
  }

  // Build the location permission dialog
  Widget _buildLocationPermissionDialog() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Color(0xFF2A2A2A),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on,
            color: Color(0xFF00854A),
            size: 48,
          ),
           SizedBox(height: 16),
           Text(
            'Location Permission',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,

            ),
          ),
           SizedBox(height: 12),
           Text(
            'Turf needs access to your location to find nearby venues. Please grant location permission.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
                          decoration: TextDecoration.none,

            ),
          ),
           SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showLocationDialog = false;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white54,
                ),
                child:  Text('Not Now'),
              ),
              ElevatedButton(
                onPressed: _requestLocationPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00854A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Grant Access'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyTurfsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Nearby turfs',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    return PromotionalBanner(promotions: _promotions);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/search.jpg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Text(
              'Search',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportsCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: Text(
            'Sports',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 130, // Increased height to accommodate larger circles
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _sportCategories.length,
            itemBuilder: (context, index) {
              final sport = _sportCategories[index];
              return Container(
                // color: Colors.amber,
                width: 65, // Increased width for the container
                margin: const EdgeInsets.symmetric(horizontal: 8), // Increased margin
                child: Column(
                  children: [
                    Container(
                      width: 70, // Increased circle width
                      height: 70, // Increased circle height to make it perfectly round
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // White outer border
                          width: 1.5, // Slightly thicker border
                        ),
                        image: DecorationImage(
                          image: AssetImage(sport['image']),
                          fit: BoxFit.cover, // Changed to cover for better image display
                          onError: (exception, stackTrace) => const Icon(Icons.sports_soccer, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Increased spacing
                    Text(
                      sport['name'],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2, // Allow two lines for longer sport names
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Center(
      child: Container(
        width: 380, // Custom width here
        height: 36, // Custom height here
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showSlots = true;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _showSlots ? const Color(0xFF00854A) : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Text(
                    'Slots',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showSlots = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !_showSlots ? const Color(0xFF00854A) : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Text(
                    'Courts',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTurfList() {
    return _turfList.map((turf) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/venue_detail', arguments: turf);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background
            borderRadius: BorderRadius.circular(12),
          ),
          height: 85, // Increased height to prevent overflow
          child: Row(
            children: [
              // Left side - Turf image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
              ),
              child: turf['image'].startsWith('assets/') && turf['image'].endsWith('.jpg')
                ? Image.asset(
                    turf['image'], // Use the image path from the turf data
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                : PlaceholderImage(
                    width: 80,
                    height: 80,
                    label: turf['sport'],
                    color: const Color(0xFF00854A),
                  ),
            ),
            // Right side - Turf details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Turf name
                    Text(
                      turf['name'],
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    // Location info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: const Color(0xFF00854A),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${turf['distance']} | ${turf['location']}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Sport type and rating
                    Row(
                      children: [
                        // Sport icon and name
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                turf['sport'] == 'Basketball'
                                    ? Icons.sports_basketball
                                    : Icons.sports_soccer,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                turf['sport'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Rating with black background
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                turf['rating'].toString(),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${turf['reviews']})',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }).toList();
  }
  // Check if location permission is granted
  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      setState(() {
        _showLocationDialog = false;
      });
    }
  }


  // Request location permission
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _showLocationDialog = false;
      });
    }
  }
}
