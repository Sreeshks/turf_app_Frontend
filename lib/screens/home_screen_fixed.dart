import 'package:flutter/material.dart';
import 'package:turf2/widgets/placeholder_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  bool _showSlots = true;

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
      'image': 'assets/1.jpg',
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
      'name': 'One center basketball turf',
      'distance': '7.5 km',
      'location': '1548 Stiger Dr, Mesa',
      'sport': 'Basketball',
      'rating': 4.2,
      'reviews': 1333,
      'image': 'assets/turf1.jpg',
    },
    {
      'name': 'United king football turf',
      'distance': '5.2 km',
      'location': '2356 Green Valley, Phoenix',
      'sport': 'Football',
      'rating': 4.5,
      'reviews': 987,
      'image': 'assets/turf2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
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
                const Text(
                  '4517 Ave, Manchester',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
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
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
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
            Icon(
              Icons.search,
              color: Colors.grey.shade400,
              size: 20,
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
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 16),
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
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // padding: const EdgeInsets.symmetric(horizontal: 2), // Minimal padding
            itemCount: _sportCategories.length,
            itemBuilder: (context, index) {
              final sport = _sportCategories[index];
              return Container(
                color: Colors.red,
                width: 50, // Further reduced width
                margin: EdgeInsets.zero, // Zero margin
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // White outer border
                          width: 1, // Border width
                        ),
                        image: DecorationImage(
                          image: AssetImage(sport['image']),
                          fit: BoxFit.fill, // Ensure the image covers the circle
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sport['name'],
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildPromotionalBanner() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            itemCount: _promotions.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final promo = _promotions[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Base image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        promo['image'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Green overlay with gradient that fades from left to right
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.center, // Fade out by the middle
                            colors: [
                              const Color(0xFF0E9F6E).withOpacity(0.7),  // Stronger green on left
                              const Color(0xFF00854A).withOpacity(0.0),  // Completely transparent in middle
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            promo['title'],
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            promo['subtitle'],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promotions.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == index
                    ? const Color(0xFF00854A)
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyTurfsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: turf['image'].startsWith('assets/') && turf['image'].endsWith('.jpg')
                ? Image.asset(
                    'assets/BG.jpg', // Fallback to existing background image
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : PlaceholderImage(
                    width: double.infinity,
                    height: 120,
                    label: turf['sport'],
                    color: const Color(0xFF00854A),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: const Color(0xFF00854A),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        turf['distance'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        turf['location'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    turf['name'],
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              turf['sport'] == 'Basketball'
                                  ? Icons.sports_basketball
                                  : Icons.sports_soccer,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              turf['sport'],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        turf['rating'].toString(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${turf['reviews']})',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
