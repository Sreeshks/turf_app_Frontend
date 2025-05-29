import 'package:flutter/material.dart';
import 'package:turf2/screens/SlotBooking.dart';

class SportSelectionScreen extends StatefulWidget {
  const SportSelectionScreen({super.key});

  @override
  _SportSelectionScreenState createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedSport; // Single sport selection
  String _searchQuery = '';

  final List<List<String>> _sportRows = [
    ['Cycling', 'Football'],
    ['Tennis', 'Running', 'Badminton'],
    ['Volleyball', 'Cricket', 'Basketball', 'Table Tennis'],
    ['Hockey', 'Yoga', 'Swimming'],
    ['Workout', 'Boxing'],
  ];

  final Map<String, IconData> _sportIcons = {
    'Football': Icons.sports_soccer,
    'Cricket': Icons.sports_cricket,
    'Basketball': Icons.sports_basketball,
    'Tennis': Icons.sports_tennis,
    'Badminton': Icons.sports_tennis,
    'Table Tennis': Icons.sports_tennis,
    'Volleyball': Icons.sports_volleyball,
    'Hockey': Icons.sports_hockey,
    'Swimming': Icons.pool,
    'Running': Icons.directions_run,
    'Cycling': Icons.directions_bike,
    'Yoga': Icons.self_improvement,
    'Workout': Icons.fitness_center,
    'Boxing': Icons.sports_mma,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Color(0xFF121212),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'Select your sport',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Search bar
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Ex: Football, Cricket',
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 10),
                            prefixIcon: Icon(Icons.search, color: Colors.white54, size: 16),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),

                      // Sports grid
                      Expanded(
                        child: Center(
                          child: _buildFilteredSportsGrid(),
                        ),
                      ),

                      // Bottom button
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedSport == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a sport'),
                                    backgroundColor: Color(0xFF00854A),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                // Custom page transition animation
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => SlotBookingScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      // Fade transition
                                      var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
                                      
                                      // Scale transition
                                      var scaleAnimation = Tween<double>(begin: 0.9, end: 1.0)
                                          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                                      
                                      // Slide transition
                                      var slideAnimation = Tween<Offset>(begin: Offset(0.0, 0.1), end: Offset.zero)
                                          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                                      
                                      return FadeTransition(
                                        opacity: fadeAnimation,
                                        child: ScaleTransition(
                                          scale: scaleAnimation,
                                          child: SlideTransition(
                                            position: slideAnimation,
                                            child: child,
                                          ),
                                        ),
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 600),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00854A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              shadowColor: Color(0xFF00854A).withOpacity(0.4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedSport == null ? 'SELECT A SPORT' : 'CONTINUE WITH $_selectedSport',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilteredSportsGrid() {
    // Flatten the sports list and filter based on search query
    final allSports = _sportRows.expand((row) => row).toList();
    final filteredSports = _searchQuery.isEmpty
        ? _sportRows
        : [
            allSports
                .where((sport) => sport.toLowerCase().contains(_searchQuery))
                .toList()
          ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filteredSports.isEmpty
          ? [
              const Text(
                'No sports found',
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ]
          : filteredSports.map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((sport) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildSportBubble(sport),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
    );
  }

  Widget _buildSportBubble(String sport) {
    final bool isSelected = _selectedSport == sport;

    return GestureDetector(
      onTap: () => _toggleSport(sport),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF1E1E1E),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          border: isSelected ? Border.all(color: Color(0xFF00854A), width: 1.5) : Border.all(color: Colors.white10, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _sportIcons[sport] ?? Icons.sports,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              sport,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSport(String sport) {
    setState(() {
      _selectedSport = sport;
    });
  }
}