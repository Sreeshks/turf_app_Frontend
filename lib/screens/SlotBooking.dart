import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turf2/models/booking_data.dart';
import 'package:turf2/screens/summary.dart';

class SlotBookingScreen extends StatefulWidget {
  const SlotBookingScreen({super.key});

  @override
  _SlotBookingScreenState createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen> with TickerProviderStateMixin {
  // Selected date and format
  late DateTime selectedDate;
  late DateTime currentMonth;
  int selectedDuration = 2; // Default duration in hours
  String selectedStartTime = '06:00 PM';
  int selectedTimeIndex = 5; // Default to 6:00 PM (index 5)
  
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  
  // Color palette inspired by SportSelection screen
  final Color primaryGreen = const Color(0xFF00854A);
  final Color accentGreen = const Color(0xFF00A86B);
  final Color darkBackground = const Color(0xFF121212);
  final Color darkSurface = const Color(0xFF1E1E1E);
  final Color cardColor = const Color(0xFF2A2A2A);
  final Color accentAmber = const Color(0xFFFFB74D);
  final Color premiumSilver = const Color(0xFFC0C0C0);
  
  // Available times slots
  final List<String> timeSlots = [
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM', 
    '06:00 PM', '07:00 PM', '08:00 PM', '09:00 PM'
  ];
  
  // Booked slots map by date (date string -> list of booked time indices)
  Map<String, List<int>> bookedSlotsByDate = {};

  // Available dates (current month)
  late List<DateTime> availableDates;
  late List<String> weekDays;
  
  // Format for displaying dates
  final DateFormat monthYearFormat = DateFormat('MMMM yyyy');
  final DateFormat dayFormat = DateFormat('d');
  final DateFormat dateKeyFormat = DateFormat('yyyy-MM-dd');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
    icon: Icon(
      Icons.chevron_left, // Changed from arrow_back_ios to arrow_back
      color: Colors.white, // Matches the white title
      size: 24,
    ),
    onPressed: () {
      Navigator.of(context).pop(); // Navigates back to the previous screen
    },
  ),
  title: const Text(
    'Slot Booking',
    style: TextStyle(
      color: Colors.white, // This will now take effect
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  ),
  backgroundColor: darkBackground,
  elevation: 0,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          darkBackground,
          darkBackground.withOpacity(0.8),
        ],
      ),
    ),
  ),
),
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildVenueSelector(),
                const SizedBox(height: 32),
                
                _buildMonthNavigator(),
                const SizedBox(height: 16),
                
                _buildCalendar(),
                const SizedBox(height: 40),
                
                _buildTimeSlider(),
                const SizedBox(height: 40),
                
                _buildTimeAndDurationSelectors(),
                const SizedBox(height: 32),
                
                _buildPriceSection(),
                const SizedBox(height: 32),
                
                _buildContinueButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String calculateEndTime() {
    final startTimeParts = selectedStartTime.split(':');
    final startHour = int.parse(startTimeParts[0]);
    final startMinute = int.parse(startTimeParts[1].split(' ')[0]);
    final isPM = selectedStartTime.contains('PM');
    
    int hour24 = isPM && startHour != 12 ? startHour + 12 : startHour;
    if (!isPM && startHour == 12) hour24 = 0;
    
    int endHour24 = (hour24 + selectedDuration) % 24;
    
    final endIsPM = endHour24 >= 12;
    int endHour12 = endHour24 > 12 ? endHour24 - 12 : endHour24;
    if (endHour12 == 0) endHour12 = 12;
    
    return '$endHour12:00 ${endIsPM ? 'PM' : 'AM'}';
  }
  
  int calculateTotalPrice() {
    return 400 * selectedDuration;
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
    
    // Initialize with current date and month
    final now = DateTime.now();
    selectedDate = now;
    currentMonth = DateTime(now.year, now.month, 1);
    
    // Generate dates for the current month
    _generateDatesForMonth(currentMonth);
    
    // Initialize weekdays
    weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    
    // Initialize some mock booked slots for demo purposes
    _initializeBookedSlots();
    
    // Check time availability to adjust default time if necessary
    _checkTimeAvailability();
  }
  
  Widget _buildCalendar() {
    final dayLabels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayLabels.map((day) => 
            SizedBox(
              width: 40,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [primaryGreen.withOpacity(0.8), accentGreen.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ).toList(),
        ),
        const SizedBox(height: 16),
        _buildWeekRow(),
      ],
    );
  }
Widget _buildContinueButton() {
  return AnimatedBuilder(
    animation: _pulseAnimation,
    builder: (context, child) {
      return Transform.scale(
        scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.02,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryGreen,
                accentGreen,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.4),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // Create TurfDetails object
              final turfDetails = TurfDetails(
                name: 'The Sports Habitat',
                location: 'Hwadaridong Sport Fields, Pankrati, Patirkarti',
                imageUrl: 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=1000',
                rating: 4.8,
                reviewCount: 124,
                openingHours: '6:30 AM - 12:30 AM',
                pricePerHour: '₹450',
              );

              // Create BookingData object
              final bookingData = BookingData(
                turfDetails: turfDetails,
                date: DateFormat('dd MMM yyyy').format(selectedDate),
                startTime: selectedStartTime,
                endTime: calculateEndTime(),
                duration: selectedDuration,
                totalAmount: calculateTotalPrice().toDouble(),
                sportType: 'Football',
                bookingId: 'TD${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6)}',
              );

              // Save booking data to provider
              BookingDataProvider().setBookingData(bookingData);

              // Navigate to summary screen with fade transition
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>  CheckoutSummaryPage(), // Ensure SummaryScreen is defined
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500), // Adjust duration for smoothness
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
  Widget _buildDateCell(String date, bool isSelected, {bool isEnabled = true}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected
            ? LinearGradient(
                colors: [primaryGreen, accentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          date,
          style: TextStyle(
            color: isEnabled 
                ? (isSelected ? Colors.white : Colors.grey.shade300)
                : Colors.grey.shade600,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  Widget _buildDurationButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [primaryGreen, accentGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DURATION',
              style: TextStyle(
                color: const Color(0xFF00854A),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              'Select Hours',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildDurationButton(Icons.remove, () {
              setState(() {
                if (selectedDuration > 1) {
                  selectedDuration--;
                  _checkTimeAvailability();
                }
              });
            }),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: primaryGreen.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '$selectedDuration hrs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 12),
            _buildDurationButton(Icons.add, () {
              setState(() {
                if (selectedDuration < 5) {
                  selectedDuration++;
                  _checkTimeAvailability();
                }
              });
            }),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: 0.785398, // 45 degrees in radians
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: premiumSilver.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNavigator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: darkSurface.withAlpha(100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryGreen.withOpacity(0.2),
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
                'CALENDAR',
                style: TextStyle(
                  color: const Color(0xFF00854A),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Text(
                monthYearFormat.format(currentMonth),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildNavigationButton(Icons.chevron_left, () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                  _generateDatesForMonth(currentMonth);
                  
                  if (selectedDate.month != currentMonth.month || selectedDate.year != currentMonth.year) {
                    selectedDate = DateTime(currentMonth.year, currentMonth.month, 1);
                    _checkTimeAvailability();
                  }
                });
              }),
              const SizedBox(width: 16),
              _buildNavigationButton(Icons.chevron_right, () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                  _generateDatesForMonth(currentMonth);
                  
                  if (selectedDate.month != currentMonth.month || selectedDate.year != currentMonth.year) {
                    selectedDate = DateTime(currentMonth.year, currentMonth.month, 1);
                    _checkTimeAvailability();
                  }
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [primaryGreen.withOpacity(0.8), accentGreen.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon, 
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
  
  Widget _buildPremiumTimePoint(bool isSelected, bool isBooked, int index) {
    Color dotColor = isBooked
        ? Colors.red.shade600
        : (isSelected ? primaryGreen : premiumSilver.withOpacity(0.6));
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Transform.rotate(
        angle: 0.785398, // 45 degrees - diamond shape
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(3),
            boxShadow: isSelected || isBooked
                ? [
                    BoxShadow(
                      color: dotColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
            border: !isBooked && !isSelected
                ? Border.all(color: premiumSilver.withOpacity(0.3), width: 1)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                darkSurface.withOpacity(0.9),
                cardColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.2),
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: primaryGreen.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Shimmer effect
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Transform.translate(
                    offset: Offset(_shimmerAnimation.value * 200, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            primaryGreen.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.5, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [primaryGreen, accentGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'PREMIUM TOTAL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [primaryGreen, accentGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      '₹ ${calculateTotalPrice()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Per Hour: ₹400 | Duration: ${selectedDuration}hrs',
                    style: TextStyle(
                      color: premiumSilver.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTimeAndDurationSelectors() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A), // Same as facility box in Venue.dart
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeSelector(),
          _buildDurationSelector(),
        ],
      ),
    );
  }
  
  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'START TIME',
              style: TextStyle(
                color: const Color(0xFF00854A),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              'Select Time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: _showTimePickerDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryGreen, accentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedStartTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlider() {
    final dateKey = dateKeyFormat.format(selectedDate);
    final bookedTimes = bookedSlotsByDate[dateKey] ?? [];
    
    int startTimeIndex = timeSlots.indexOf(selectedStartTime);
    if (startTimeIndex != selectedTimeIndex) {
      startTimeIndex = selectedTimeIndex;
      selectedStartTime = timeSlots[startTimeIndex];
    }
    
    final List<int> selectedTimeRange = [];
    for (int i = 0; i <= selectedDuration; i++) {
      if (startTimeIndex + i < timeSlots.length) {
        selectedTimeRange.add(startTimeIndex + i);
      }
    }
    
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double dotWidth = 16;
    final double spacing = (containerWidth - (timeSlots.length * dotWidth)) / (timeSlots.length - 1);
    
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            darkSurface.withOpacity(0.8),
            cardColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: primaryGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'XPLAY ARENA',
                style: TextStyle(
                  color: const Color(0xFF00854A),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Time Selection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          
          // Time labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(timeSlots.length, (index) {
              final bool isInSelectedRange = selectedTimeRange.contains(index);
              
              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isInSelectedRange 
                      ? [primaryGreen, accentGreen]
                      : [Colors.grey[400]!, Colors.grey[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  timeSlots[index].substring(0, 4),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: isInSelectedRange ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          
          // Time slider with diamond dots
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 24,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base line
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: premiumSilver.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      
                      // Selected range highlight
                      if (selectedTimeRange.length > 1)
                        Positioned(
                          left: (startTimeIndex * (dotWidth + spacing)) + (dotWidth / 2),
                          width: (selectedTimeRange.length - 1) * (dotWidth + spacing),
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryGreen, accentGreen],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryGreen.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      // Diamond dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(timeSlots.length, (index) {
                          final bool isInSelectedRange = selectedTimeRange.contains(index);
                          final bool isBooked = bookedTimes.contains(index);
                          
                          return GestureDetector(
                            onTap: () {
                              bool hasConflict = false;
                              for (int i = 0; i < selectedDuration; i++) {
                                if (index + i < timeSlots.length && bookedTimes.contains(index + i)) {
                                  hasConflict = true;
                                  break;
                                }
                              }
                              
                              if (!hasConflict) {
                                setState(() {
                                  selectedTimeIndex = index;
                                  selectedStartTime = timeSlots[index];
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('This time conflicts with an existing booking'),
                                    backgroundColor: Colors.red.shade800,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: _buildPremiumTimePoint(isInSelectedRange, isBooked, index),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 28),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(primaryGreen, 'Selected'),
              SizedBox(width: 24),
              _buildLegendItem(Colors.red.shade600, 'Booked'),
              SizedBox(width: 24),
              _buildLegendItem(premiumSilver.withOpacity(0.6), 'Available'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVenueOption(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryGreen.withOpacity(0.9),
                      accentGreen.withOpacity(0.7),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E1E1E),  // Grey
                      Colors.black,      // Black
                    ],
                  ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: primaryGreen.withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: isSelected ? primaryGreen : cardColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? Colors.white.withOpacity(0.2) 
                    : primaryGreen.withOpacity(0.1),
              ),
              child: Icon(
                icon, 
                color: isSelected ? Colors.white : primaryGreen, 
                size: 24
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isSelected ? [primaryGreen, accentGreen] : [Colors.white70, Colors.white60],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            label, 
            style: TextStyle(
              color: Colors.white,
              fontSize: 12, 
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVenueSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryGreen, accentGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'SELECT SPORT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
  
  Widget _buildWeekRow() {
    final int selectedDayOfWeek = selectedDate.weekday % 7;
    final DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDayOfWeek));
    
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
        
        return GestureDetector(
          onTap: () {
            if (isCurrentMonth) {
              setState(() {
                selectedDate = date;
                _checkTimeAvailability();
              });
            }
          },
          child: _buildDateCell(
            dayFormat.format(date), 
            isSelected,
            isEnabled: isCurrentMonth,
          ),
        );
      }).toList(),
    );
  }
  
  void _checkTimeAvailability() {
    final dateKey = dateKeyFormat.format(selectedDate);
    final bookedTimes = bookedSlotsByDate[dateKey] ?? [];
    
    bool hasConflict = false;
    for (int i = 0; i <= selectedDuration; i++) {
      if (selectedTimeIndex + i < timeSlots.length && bookedTimes.contains(selectedTimeIndex + i)) {
        hasConflict = true;
        break;
      }
    }
    
    if (hasConflict) {
      for (int i = 0; i < timeSlots.length; i++) {
        bool isAvailable = true;
        for (int j = 0; j <= selectedDuration; j++) {
          if (i + j < timeSlots.length && bookedTimes.contains(i + j)) {
            isAvailable = false;
            break;
          }
        }
        if (isAvailable) {
          setState(() {
            selectedTimeIndex = i;
            selectedStartTime = timeSlots[i];
          });
          break;
        }
      }
    }
  }
  
  // Generate dates for the given month
  void _generateDatesForMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    availableDates = List.generate(
      daysInMonth,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  // Initialize some mock booked slots for demo purposes
  void _initializeBookedSlots() {
    final today = dateKeyFormat.format(selectedDate);
    final tomorrow = dateKeyFormat.format(selectedDate.add(const Duration(days: 1)));
    
    bookedSlotsByDate[today] = [5, 6];
    bookedSlotsByDate[tomorrow] = [2, 3, 7];
  }

  void _showTimePickerDialog() {
    final dateKey = dateKeyFormat.format(selectedDate);
    final bookedTimes = bookedSlotsByDate[dateKey] ?? [];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [primaryGreen, accentGreen],
            ).createShader(bounds),
            child: Text(
              'Select Time',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final bool isBooked = bookedTimes.contains(index);
                
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isBooked ? Colors.red.shade900.withOpacity(0.2) : cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isBooked ? Colors.red.shade600 : primaryGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      timeSlots[index],
                      style: TextStyle(
                        color: isBooked ? Colors.red.shade300 : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      isBooked ? Icons.block : Icons.check_circle,
                      color: isBooked ? Colors.red.shade600 : primaryGreen,
                    ),
                    enabled: !isBooked,
                    onTap: isBooked ? null : () {
                      setState(() {
                        selectedTimeIndex = index;
                        selectedStartTime = timeSlots[index];
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: primaryGreen),
              ),
            ),
          ],
        );
      },
    );
  }
}