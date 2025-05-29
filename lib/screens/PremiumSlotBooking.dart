import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class PremiumSlotBookingScreen extends StatefulWidget {
  const PremiumSlotBookingScreen({Key? key}) : super(key: key);

  @override
  _PremiumSlotBookingScreenState createState() => _PremiumSlotBookingScreenState();
}

class _PremiumSlotBookingScreenState extends State<PremiumSlotBookingScreen> with SingleTickerProviderStateMixin {
  // Selected date and format
  late DateTime selectedDate;
  late DateTime currentMonth;
  int selectedDuration = 2; // Default duration in hours
  String selectedStartTime = '06:00 PM';
  int selectedTimeIndex = 5; // Default to 6:00 PM (index 5)
  
  // Animation controller for premium effects
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Color constants to maintain your palette
  final Color primaryGreen = const Color(0xFF00854A);
  final Color darkBackground = const Color(0xFF121212);
  final Color darkSurface = const Color(0xFF1E1E1E);
  final Color cardColor = const Color(0xFF2C2C2E);
  
  // Available times slots
  final List<String> timeSlots = [
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM', 
    '06:00 PM', '07:00 PM', '08:00 PM', '09:00 PM'
  ];
  
  // Booked slots map by date (date string -> list of booked time indices)
  Map<String, List<int>> bookedSlotsByDate = {};

  // Format for displaying dates
  final DateFormat monthYearFormat = DateFormat('MMMM yyyy');
  final DateFormat dayFormat = DateFormat('d');
  final DateFormat dateKeyFormat = DateFormat('yyyy-MM-dd');
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with current date and month
    final now = DateTime.now();
    selectedDate = now;
    currentMonth = DateTime(now.year, now.month, 1);
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    
    // Initialize some mock booked slots for demo purposes
    _initializeBookedSlots();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Initialize some mock booked slots for demo purposes
  void _initializeBookedSlots() {
    // Today's date
    final today = dateKeyFormat.format(selectedDate);
    // Tomorrow's date
    final tomorrow = dateKeyFormat.format(selectedDate.add(const Duration(days: 1)));
    
    // Add some random booked slots for demonstration
    bookedSlotsByDate[today] = [5, 6]; // 6:00 PM and 7:00 PM are booked today
    bookedSlotsByDate[tomorrow] = [2, 3, 7]; // 3:00 PM, 4:00 PM, and 8:00 PM are booked tomorrow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: Text(
          'Book Your Slot',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: primaryGreen),
            onPressed: () {
              // Show info dialog
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVenueSelector(),
              SizedBox(height: 24),
              _buildDateSelector(),
              SizedBox(height: 24),
              _buildTimeSelector(),
              SizedBox(height: 24),
              _buildPriceSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildContinueButton(),
    );
  }
  
  Widget _buildVenueSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Stack(
        children: [
          // Background with diamond pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DiamondPatternPainter(
                color: Colors.white.withOpacity(0.03),
                diamondSize: 10,
              ),
            ),
          ),
          // Subtle glow effect at the top
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    primaryGreen.withOpacity(0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.sports, size: 16, color: primaryGreen),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'SELECT SPORT',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildVenueOption(Icons.sports_soccer, 'Football', isSelected: true),
                    _buildVenueOption(Icons.sports_cricket, 'Cricket'),
                    _buildVenueOption(Icons.sports_volleyball, 'Volleyball'),
                    _buildVenueOption(Icons.sports_tennis, 'Tennis'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVenueOption(IconData icon, String label, {bool isSelected = false}) {
    return MouseRegion(
      onEnter: (_) {
        if (!isSelected) {
          _animationController.forward();
        }
      },
      onExit: (_) {
        if (!isSelected) {
          _animationController.reverse();
        }
      },
      child: GestureDetector(
        onTap: () {
          // Handle selection
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? 1.0 : _scaleAnimation.value,
              child: Column(
                children: [
                  // Icon container with premium styling
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryGreen.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? primaryGreen : Colors.grey.shade800,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ] : [],
                    ),
                    child: Stack(
                      children: [
                        // Diamond pattern for selected items
                        if (isSelected)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DiamondPatternPainter(
                                color: primaryGreen.withOpacity(0.1),
                                diamondSize: 8,
                              ),
                            ),
                          ),
                        // Icon
                        Center(
                          child: Icon(
                            icon,
                            color: isSelected ? primaryGreen : Colors.grey.shade400,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Label
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, size: 16, color: primaryGreen),
              ),
              SizedBox(width: 10),
              Text(
                'SELECT DATE',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              Spacer(),
              Text(
                monthYearFormat.format(currentMonth),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Week days header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => 
              SizedBox(
                width: 40,
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ).toList(),
          ),
          SizedBox(height: 12),
          // Date cells with diamond indicators
          _buildDateGrid(),
        ],
      ),
    );
  }
  
  Widget _buildDateGrid() {
    // Find the start of the week containing the selected date
    final int selectedDayOfWeek = selectedDate.weekday % 7; // 0 for Sunday, 1 for Monday, etc.
    final DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDayOfWeek));
    
    // Generate 7 days starting from the start of the week
    final List<DateTime> weekDates = List.generate(
      7, 
      (index) => startOfWeek.add(Duration(days: index)),
    );
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDates.map((date) {
        final bool isSelected = date.year == selectedDate.year && 
                              date.month == selectedDate.month && 
                              date.day == selectedDate.day;
        final bool isCurrentMonth = date.month == currentMonth.month && 
                                  date.year == currentMonth.year;
        
        // Check if date has booked slots
        final String dateKey = dateKeyFormat.format(date);
        final bool hasBookings = bookedSlotsByDate.containsKey(dateKey) && 
                               bookedSlotsByDate[dateKey]!.isNotEmpty;
        
        return GestureDetector(
          onTap: () {
            if (isCurrentMonth) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? primaryGreen : Colors.transparent,
              border: isSelected ? null : Border.all(
                color: Colors.grey.shade800,
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Date number
                Text(
                  dayFormat.format(date),
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : (isCurrentMonth ? Colors.grey.shade300 : Colors.grey.shade700),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                // Diamond indicator for dates with bookings
                if (hasBookings && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildTimeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.access_time, size: 16, color: primaryGreen),
              ),
              SizedBox(width: 10),
              Text(
                'SELECT TIME',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTimeSlider(),
          SizedBox(height: 20),
          _buildDurationSelector(),
        ],
      ),
    );
  }
  
  Widget _buildTimeSlider() {
    // Get booked slots for the selected date
    final dateKey = dateKeyFormat.format(selectedDate);
    final bookedTimes = bookedSlotsByDate[dateKey] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final bool isSelected = index == selectedTimeIndex;
              final bool isBooked = bookedTimes.contains(index);
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    if (!isBooked) {
                      setState(() {
                        selectedTimeIndex = index;
                        selectedStartTime = timeSlots[index];
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 70,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? primaryGreen 
                          : (isBooked ? Colors.grey.shade800 : darkSurface),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? primaryGreen 
                            : Colors.grey.shade700,
                        width: 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timeSlots[index].split(' ')[0],
                          style: TextStyle(
                            color: isSelected 
                                ? Colors.white 
                                : (isBooked ? Colors.grey.shade600 : Colors.white),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          timeSlots[index].split(' ')[1],
                          style: TextStyle(
                            color: isSelected 
                                ? Colors.white.withOpacity(0.8) 
                                : (isBooked ? Colors.grey.shade600 : Colors.grey.shade400),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (isBooked)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Booked',
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
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
      ],
    );
  }
  
  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedDuration > 1) {
                    selectedDuration--;
                  }
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: darkSurface,
                  border: Border.all(color: Colors.grey.shade700),
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Text(
                    '$selectedDuration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'hours',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedDuration < 5) {
                    selectedDuration++;
                  }
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPriceSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: primaryGreen.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt_long, size: 16, color: primaryGreen),
              ),
              SizedBox(width: 10),
              Text(
                'PRICE DETAILS',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildPriceRow('Base Price', 'INR 200/hr'),
          SizedBox(height: 8),
          _buildPriceRow('Duration', '$selectedDuration hrs'),
          SizedBox(height: 8),
          _buildPriceRow('Subtotal', 'INR ${200 * selectedDuration}'),
          SizedBox(height: 8),
          _buildPriceRow('GST (18%)', 'INR ${(200 * selectedDuration * 0.18).round()}'),
          
          Divider(height: 24, color: Colors.grey.shade800),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'INR ${(200 * selectedDuration * 1.18).round()}',
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildContinueButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/summary');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: primaryGreen.withOpacity(0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for diamond pattern
class DiamondPatternPainter extends CustomPainter {
  final Color color;
  final double diamondSize;
  
  DiamondPatternPainter({required this.color, this.diamondSize = 20});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    
    final double spacing = diamondSize * 2;
    
    for (double x = 0; x < size.width + diamondSize; x += spacing) {
      for (double y = 0; y < size.height + diamondSize; y += spacing) {
        final path = Path();
        path.moveTo(x, y - diamondSize/2);
        path.lineTo(x + diamondSize/2, y);
        path.lineTo(x, y + diamondSize/2);
        path.lineTo(x - diamondSize/2, y);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
