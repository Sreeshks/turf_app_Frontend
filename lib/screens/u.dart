import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrosshatchPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double spacing;

  CrosshatchPainter({
    required this.color,
    required this.lineWidth,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw diagonal lines in both directions
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagonalStripesPainter extends CustomPainter {
  final Color color;

  DiagonalStripesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    const spacing = 10.0;
    for (var i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble() + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Add these custom painters for the grid lines and diagonal stripes
class GridLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (var i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (var i = 0; i < size.height; i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SlotBookingPageRound extends StatefulWidget {
  final String turfName;

  const SlotBookingPageRound({
    super.key,
    required this.turfName,
  });

  @override
  State<SlotBookingPageRound> createState() => _SlotBookingPageRoundState();
}

class _SlotBookingPageRoundState extends State<SlotBookingPageRound>
    with TickerProviderStateMixin {
  // Color Constants
  static const Color primaryColor = Color(0xFF007A5E); // Turf Green
  static const Color secondaryColor = Color(0xFFFF6B35); // Vibrant Orange
  static const Color accentColor = Color(0xFF00C2D1); // Electric Blue
  static const Color backgroundColor = Color(0xFF0D0D0D); // Dark Stadium Black
  static const Color surfaceColor = Color(0xFF1A1A1A); // Carbon Fiber Gray
  static const Color textColor = Color(0xFFF0F0F0); // Stadium White
  static const Color bookedColor = Color(0xFFCC3E4A); // Steel Red

  // Multiple animation controllers for more complex animations
  late AnimationController _mainAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _rotationAnimationController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  // Selected date
  DateTime _selectedDate = DateTime.now();
  
  // Selected slots
  final Set<String> _selectedSlots = {};
  
  // Mock data - would be fetched from API in real app
  final Map<String, bool> _slotAvailability = {
    "5:00 PM - 6:00 PM": true,
    "6:00 PM - 7:00 PM": false,
    "7:00 PM - 8:00 PM": true,
    "8:00 PM - 9:00 PM": true,
    "9:00 PM - 10:00 PM": false,
    "10:00 PM - 11:00 PM": true,
    "11:00 PM - 12:00 AM": true,
    "12:00 AM - 1:00 AM": false,
    "1:00 AM - 2:00 AM": true,
    "2:00 AM - 3:00 AM": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E676).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xFF00E676),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF00E676)),
                  color: const Color(0xFF121212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: const Color(0xFF00E676).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "help",
                      child: Text("Help", style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: "settings",
                      child: Text("Settings", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onSelected: (value) {
                    // Handle menu selection
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _mainAnimationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: child,
            ),
          );
        },
        child: Stack(
          children: [
            // Background with field-like grid lines
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  image: DecorationImage(
                    image: const NetworkImage(
                      'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                    ),
                    repeat: ImageRepeat.repeat,
                    opacity: 0.05,
                  ),
                ),
                child: CustomPaint(
                  painter: GridLinesPainter(),
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Premium Title with new styling
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [primaryColor, accentColor],
                          ).createShader(bounds),
                          child: Text(
                            widget.turfName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Date Selection with new styling
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected Date",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: const Color(0xFF00E676).withOpacity(0.2),
                                highlightColor: const Color(0xFF00E676).withOpacity(0.1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        color: Color(0xFF00E676),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Change",
                                        style: TextStyle(
                                          color: Color(0xFF00E676),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Time Slots Title with new styling
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Available Time Slots",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Premium Slot Grid with new styling
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5, // 120×80px ratio
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _slotAvailability.length,
                        itemBuilder: (context, index) {
                          final slot = _slotAvailability.keys.elementAt(index);
                          final isAvailable = _slotAvailability[slot]!;
                          final isSelected = _selectedSlots.contains(slot);
                          
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 200), // Faster, more premium feel
                            curve: Curves.easeOutCubic, // Smoother animation
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: GestureDetector(
                              onTap: () => _toggleSlotSelection(slot),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121212), // Rich Black base
                                  borderRadius: BorderRadius.circular(6), // Precise rounding
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFFD700).withOpacity(0.5) // Gold trim
                                        : isAvailable
                                            ? const Color(0xFF388E3C).withOpacity(0.3) // Soft Green
                                            : const Color(0xFF424242), // Graphite
                                    width: 1, // Hairline border
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      const BoxShadow(
                                        color: Color(0xFF1B5E20), // Forest Green shadow
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Booked pattern overlay
                                    if (!isAvailable)
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: CrosshatchPainter(
                                            color: Colors.white.withOpacity(0.03),
                                            lineWidth: 1,
                                            spacing: 8,
                                          ),
                                        ),
                                      ),
                                    
                                    // Main content
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Time slot
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                slot.split(' - ')[0],
                                                style: TextStyle(
                                                  color: isSelected || isAvailable
                                                      ? const Color(0xFFF5F5F5)
                                                      : const Color(0xFF757575),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                slot.split(' - ')[1],
                                                style: TextStyle(
                                                  color: (isSelected || isAvailable
                                                      ? const Color(0xFFF5F5F5)
                                                      : const Color(0xFF757575))
                                                      .withOpacity(0.7),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          // Status badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFF1B5E20) // Forest Green
                                                  : isAvailable
                                                      ? const Color(0xFF388E3C) // Soft Green
                                                      : const Color(0xFF424242), // Graphite
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  isSelected
                                                      ? Icons.check
                                                      : isAvailable
                                                          ? Icons.sports_soccer
                                                          : Icons.block,
                                                  color: const Color(0xFFF5F5F5),
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isSelected
                                                      ? "SELECTED"
                                                      : isAvailable
                                                          ? "AVAILABLE"
                                                          : "BOOKED",
                                                  style: const TextStyle(
                                                    color: Color(0xFFF5F5F5),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Selected indicator (gold underline)
                                    if (isSelected)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 2,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFD700), // Gold
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
                      
                      const SizedBox(height: 32),
                      
                      // Slot Legend
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLegendItem(
                              "Available",
                              const Color(0xFF00E676),
                              false,
                            ),
                            _buildLegendItem(
                              "Selected",
                              const Color(0xFF00E676),
                              true,
                            ),
                            _buildLegendItem(
                              "Booked",
                              Colors.red,
                              false,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Summary and Booking
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF00E676).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E676).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.summarize_rounded,
                                    color: Color(0xFF00E676),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Booking Summary",
                                  style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Turf",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.turfName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Selected Slots",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${_selectedSlots.length} slot(s)",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Hours",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${_selectedSlots.length} hour(s)",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Price (per hour)",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  "₹800",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFF00E676).withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E676).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF00E676),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "₹${_selectedSlots.length * 800}",
                                    style: const TextStyle(
                                      color: Color(0xFF00E676),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating action button with new styling
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: _confirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              shadowColor: secondaryColor.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 24),
                const SizedBox(width: 12),
                const Text(
                  "CONFIRM BOOKING",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _pulseAnimationController.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    // Primary animation controller
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    // Pulse animation controller
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Rotation animation controller
    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20000),
    )..repeat();
    
    // Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _rotationAnimationController,
        curve: Curves.linear,
      ),
    );
    
    // Start animations
    _mainAnimationController.forward();

    // Apply immersive UI for a premium feel
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isSelected) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? color : Colors.transparent,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _confirmBooking() {
    if (_selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please select at least one time slot.",
            style: TextStyle(fontSize: 15),
          ),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return;
    }
    
    // Advanced confirmation dialog with animations
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Booking Confirmation",
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation1,
          curve: Curves.easeOutBack,
        );
        
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: AlertDialog(
              backgroundColor: const Color(0xFF121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(
                  color: Color(0xFF00E676),
                  width: 2,
                ),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF00E676)),
                  SizedBox(width: 12),
                  Text(
                    "Confirm Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You're about to book the following slots:",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF00E676).withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._selectedSlots.map(
                      (slot) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.access_time_filled,
                                color: Color(0xFF00E676),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                slot,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                  ),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Here would navigate to payment or final confirmation
                    _showSuccessOverlay();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF00E676).withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "CONFIRM BOOKING",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00E676),
              onPrimary: Colors.black,
              surface: Color(0xFF0A0A0A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // In a real app, we would fetch slots for this new date
      });
    }
  }
  
  void _showSuccessOverlay() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Booking Success",
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation1),
          child: Container(
            color: Colors.black.withOpacity(0.8),
            child: Center(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: const Color(0xFF00E676),
                        size: 100 * value,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
    
    // Automatically dismiss after animation completes
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
      
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Booking successful!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF00E676),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
  
  void _toggleSlotSelection(String slot) {
    HapticFeedback.mediumImpact(); // Tactile feedback
    
    // Only allow selection of available slots
    if (_slotAvailability[slot] == true) {
      setState(() {
        if (_selectedSlots.contains(slot)) {
          _selectedSlots.remove(slot);
        } else {
          _selectedSlots.add(slot);
        }
      });
    } else {
      // Premium snackbar effect for booked slots
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Slot Unavailable",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "This time slot is already booked.",
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "DISMISS",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }
}