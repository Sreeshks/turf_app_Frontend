import 'package:flutter/material.dart';
import 'package:turf2/config/theme.dart';
import 'package:turf2/screens/Sportselection.dart';
import 'package:turf2/screens/slotbooking.dart'; // Import the SlotBookingScreen
import 'package:turf2/widgets/animated%20_venue.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({super.key});

  @override
  _VenueDetailScreenState createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VenueBackground(),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVenueHeader(),
                        _buildInfoSection(),
                        _buildTimeAndPriceSection(),
                        _buildAboutSection(),
                        _buildFacilitiesSection(),
                        _buildAvailableSportsSection(),
                        _buildBookingButton(context), // Pass context to navigate
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  Widget _buildAboutSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity, // Make sure the container takes full width
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black,
                    Color(0xFF1E1E1E),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT',
                  style: TextStyle(
                    color: const Color(0xFF00854A), // Bright neon green
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'The Sports Habitat is a premium sports complex offering state-of-the-art facilities for various sports activities. Our facility is designed to provide the best experience for athletes and sports enthusiasts alike.',
                  style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 16),
                _buildFeaturePoint('Professional-grade synthetic turf fields'),
                _buildFeaturePoint('High-quality LED lighting for night matches'),
                _buildFeaturePoint('Temperature-controlled indoor facilities'),
                _buildFeaturePoint('Premium locker rooms and shower facilities'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSportsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'AVAILABLE SPORTS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 30, // Horizontal spacing between items
            runSpacing: 20, // Vertical spacing between lines
            children: [
              _buildSportIcon(Icons.sports_soccer, 'Football'),
              _buildSportIcon(Icons.sports_cricket, 'Cricket'),
              _buildSportIcon(Icons.sports_volleyball, 'Volleyball'),
              _buildSportIcon(Icons.sports_tennis, 'Tennis'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SportSelectionScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF00854A), // Consistent green color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00854A).withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BOOK NOW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      width: double.infinity, // Make sure the container takes full width
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A), // Very light shade of black
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FACILITIES',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the column contents
            children: [
              // First row - 3 facilities
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
                children: [
                  _buildFacilityChip('Washroom'),
                  SizedBox(width: 10),
                  _buildFacilityChip('Locker'),
                  SizedBox(width: 10),
                  _buildFacilityChip('Changing Room'),
                ],
              ),
              SizedBox(height: 10),
              // Second row - 3 facilities
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
                children: [
                  _buildFacilityChip('First Aid'),
                  SizedBox(width: 10),
                  _buildFacilityChip('Shower'),
                  SizedBox(width: 10),
                  _buildFacilityChip('Food Zone'),
                ],
              ),
              // Removed Footlights to have 6 facilities total (3 per row)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00854A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF00854A), size: 14),
          SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFeaturePoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: const Color(0xFF00854A), shape: BoxShape.circle),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white70, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: const Color(0xFF00854A), size: 18),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 1.0),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E), // Very dark gray, almost black
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(Icons.local_offer, color: const Color(0xFF00854A), size: 20),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREMIUM OFFER',
                  style: TextStyle(
                    color: const Color(0xFF00854A),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Book 2 hours and get 30 minutes free!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black,
                        Color(0xFF1E1E1E),
                      ],
                    ),
                  ),
                ),
                // Icon
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00854A).withOpacity(0.2),
                    ),
                    child: Icon(icon, color: const Color(0xFF00854A), size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTimeAndPriceSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.access_time,
                title: 'OPENING HOURS',
                subtitle: '6:30 AM - 12:30 AM',
              ),
            ),
            Container(margin: EdgeInsets.symmetric(horizontal: 12), width: 1, color: Colors.white10),
            Expanded(
              child: _buildInfoItem(
                icon: Icons.attach_money,
                title: 'STARTING FROM',
                subtitle: '₹450 / hour',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueHeader() {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    AppTheme.primaryDark.withOpacity(0.8),
                    AppTheme.primaryDark,
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.darken,
              child: Image.network(
                'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=1000',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.cardGrey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: AppTheme.accentAmber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(124 reviews)',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The Sports Habitat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color.fromARGB(255, 58, 234, 27), size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Hwadaridong Sport Fields, Pankrati, Patirkarti',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}