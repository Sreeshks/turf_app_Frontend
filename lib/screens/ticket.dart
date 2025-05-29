import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:turf2/models/booking_data.dart';
import 'package:turf2/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

// Modified Custom clipper for bottom of ticket with serrated edges
class TicketBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top left
    path.moveTo(0, 0);

    // Top edge with curved connection from tear-off part
    double curveHeight = 15;
    path.quadraticBezierTo(size.width / 4, 0 - curveHeight, size.width / 2, 0);
    path.quadraticBezierTo(3 * size.width / 4, 0 + curveHeight, size.width, 0);

    // Right edge with serrated pattern
    final teethHeight = 5.0;
    for (int i = 0; i < 10; i++) {
      final step = size.height / 10;
      path.lineTo(size.width - teethHeight, i * step + (step / 2));
      path.lineTo(size.width, (i + 1) * step);
    }

    // Create serrated bottom edge
    final teethCount = 20;
    final teethWidth = size.width / teethCount;

    for (int i = teethCount - 1; i >= 0; i--) {
      path.lineTo(
        (i * teethWidth) + (teethWidth / 2),
        size.height - teethHeight,
      );
      path.lineTo(i * teethWidth, size.height);
    }

    // Left edge with serrated pattern
    for (int i = 9; i >= 0; i--) {
      final step = size.height / 10;
      path.lineTo(teethHeight, i * step + (step / 2));
      path.lineTo(0, i * step);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

// Modified Custom clipper for top of ticket with serrated edges
class TicketTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top left
    path.moveTo(0, 0);

    // Create serrated top edge
    final teethCount = 20;
    final teethWidth = size.width / teethCount;
    final teethHeight = 5.0;

    for (int i = 0; i < teethCount; i++) {
      path.lineTo((i * teethWidth) + (teethWidth / 2), teethHeight);
      path.lineTo((i + 1) * teethWidth, 0);
    }

    // Right edge with serrated pattern
    for (int i = 0; i < 10; i++) {
      final step = size.height / 10;
      path.lineTo(size.width - teethHeight, i * step + (step / 2));
      path.lineTo(size.width, (i + 1) * step);
    }

    // Bottom edge with curved connection for the tear-off part
    path.lineTo(size.width, size.height);
    double curveHeight = 15;
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - curveHeight,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width / 4,
      size.height + curveHeight,
      0,
      size.height,
    );

    // Left edge with serrated pattern
    for (int i = 9; i >= 0; i--) {
      final step = size.height / 10;
      path.lineTo(teethHeight, i * step + (step / 2));
      path.lineTo(0, i * step);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  bool _isDownloading = false;
  bool _isSharing = false;

  // Booking data from provider
  BookingData? bookingData;

  // GlobalKey for capturing the ticket widget
  final GlobalKey _ticketKey = GlobalKey();

  // WhatsApp phone number
  final String _whatsappNumber = '6238440943';

  // Static fake booking details
  final Map<String, dynamic> _fakeBookingDetails = {
    'name': 'John Doe',
    'id': 'TD123456',
    'mobile': '+91 98765 43210',
    'sportName': 'Football',
    'turfName': 'GreenField Turf',
    'address': '123 Sports Avenue, Mumbai, India',
    'bookingTime': '6:00 PM - 7:00 PM',
    'date': '25th March 2025',
    'players': '5',
    'amount': '₹1500',
    'transactionId': 'TXN789456123',
  };

  @override
  void initState() {
    super.initState();

    // Get booking data from provider
    bookingData = BookingDataProvider().getBookingData();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    // Setup fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Setup scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Setup rotate animation
    _rotateAnimation = Tween<double>(begin: 0.02, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      children: [
        Expanded(child: _buildDetailItem(label1, value1)),
        Expanded(child: _buildDetailItem(label2, value2)),
      ],
    );
  }

  Widget _buildHalfCircle(bool left) {
    return Container(
      width: 20,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: left ? Radius.circular(20) : Radius.zero,
          bottomRight: left ? Radius.circular(20) : Radius.zero,
          topLeft: !left ? Radius.circular(20) : Radius.zero,
          bottomLeft: !left ? Radius.circular(20) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildTicket() {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top part of ticket
            ClipPath(
              clipper: TicketTopClipper(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    // Top ticket header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PREMIUM TURF',
                              style: TextStyle(
                                color: const Color(0xFF00854A),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              bookingData?.sportType ?? 'Football',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00854A).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF00854A)),
                          ),
                          child: Text(
                            'CONFIRMED',
                            style: TextStyle(
                              color: const Color(0xFF00854A),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DATE & TIME',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: const Color(0xFF00854A),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    bookingData?.date ?? '23 May 2025',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: const Color(0xFF00854A),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${bookingData?.startTime ?? '6:00 PM'} - ${bookingData?.endTime ?? '8:00 PM'}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VENUE',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                bookingData?.turfDetails.name ??
                                    'The Sports Habitat',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                bookingData?.turfDetails.location ??
                                    'Hwadaridong Sport Fields, Pankrati, Patirkarti',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
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
            // Middle part with dotted line and circles
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  _buildHalfCircle(true),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            (constraints.constrainWidth() / 10).floor(),
                            (index) => Container(
                              width: 5,
                              height: 1,
                              color: Colors.black26,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildHalfCircle(false),
                ],
              ),
            ),
            // Bottom part of ticket
            ClipPath(
              clipper: TicketBottomClipper(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            'Scan this QR on the Scanner Machine at Entrance',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF00854A),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/qr.jpg',
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _fakeBookingDetails['id'],
                            style: TextStyle(
                              color: const Color(0xFF00854A),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: Colors.black12, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'NAME',
                            _fakeBookingDetails['name'],
                            'MOBILE',
                            _fakeBookingDetails['mobile'],
                          ),
                          SizedBox(height: 8),
                          _buildDetailRow(
                            'PLAYERS',
                            _fakeBookingDetails['players'],
                            'AMOUNT',
                            _fakeBookingDetails['amount'],
                          ),
                          SizedBox(height: 8),
                          // Terms and Conditions Section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.gavel,
                                      size: 12,
                                      color: const Color(0xFF00854A),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'By using this ticket, you agree to our terms of service. Cancellations must be made 4 hours prior to booking time for a refund.',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black54,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.security,
                                size: 12,
                                color: const Color(0xFF00854A),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Transaction ID: ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _fakeBookingDetails['transactionId'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 12,
                                  color: const Color(0xFF00854A),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Please arrive 15 minutes before your scheduled time',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to share ticket via WhatsApp
  Future<void> _shareViaWhatsApp() async {
    setState(() {
      _isSharing = true;
    });

    try {
      // Capture the widget as an image
      RenderRepaintBoundary boundary =
          _ticketKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/ticket.png').create();
      await file.writeAsBytes(pngBytes);

      // Create a message for WhatsApp
      final message =
          'Check out my Premium Turf Booking! 🏆\n'
          'Sport: ${_fakeBookingDetails['sportName']}\n'
          'Date: ${_fakeBookingDetails['date']}\n'
          'Time: ${_fakeBookingDetails['bookingTime']}\n';

      // Launch WhatsApp with the phone number
      final whatsappUrl =
          'https://wa.me/+91${_whatsappNumber}?text=${Uri.encodeComponent(message)}';
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // If WhatsApp is not installed, share via normal share dialog
        // await Share.shareXFiles([XFile(file.path)], text: message);
      }
    } catch (e) {
      print('Error sharing via WhatsApp: $e');
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  // Method to copy booking link to clipboard
  void _copyBookingLink() {
    final bookingLink =
        'https://premiumturf.app/booking/${_fakeBookingDetails['id']}';
    Clipboard.setData(ClipboardData(text: bookingLink));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Booking link copied to clipboard')));
  }

  // Method to show share options dialog
  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share Ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShareOptionWithImage(
                      imagePath: 'assets/whatsapp.png',
                      color: Color(0xFF25D366),
                      label: 'WhatsApp',
                      onTap: () {
                        Navigator.pop(context);
                        _shareViaWhatsApp();
                      },
                    ),
                    _buildShareOption(
                      icon: Icons.share,
                      color: Colors.blue,
                      label: 'Share',
                      onTap: () {
                        Navigator.pop(context);
                        _shareTicket();
                      },
                    ),
                    _buildShareOption(
                      icon: Icons.copy,
                      color: Colors.amber,
                      label: 'Copy Link',
                      onTap: () {
                        Navigator.pop(context);
                        _copyBookingLink();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  // Helper method to build share option button with icon
  Widget _buildShareOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  // Helper method to build share option button with image
  Widget _buildShareOptionWithImage({
    required String imagePath,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(imagePath, width: 28, height: 28),
            ),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  // Method to share ticket (original functionality)
  Future<void> _shareTicket() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      // Capture the widget as an image
      RenderRepaintBoundary boundary =
          _ticketKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/ticket.png').create();
      await file.writeAsBytes(pngBytes);

      // Share the image
      // await Share.shareXFiles([XFile(file.path)], text: 'My Premium Turf Booking Ticket');
    } catch (e) {
      print('Error sharing ticket: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _saveAndShareTicket() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final RenderRepaintBoundary boundary =
          _ticketKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List imageBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final String fileName =
          'turf_ticket_${_fakeBookingDetails['transactionId']}.png';
      final File file = File('${directory.path}/$fileName');

      await file.writeAsBytes(imageBytes);

      // await Share.shareXFiles(
      //   [XFile(file.path)],
      //   subject: 'Your Turf Booking Ticket',
      //   text: 'Here is your booking confirmation for ${_fakeBookingDetails['sportName']} at ${_fakeBookingDetails['turfName']}',
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket shared successfully!'),
          backgroundColor: const Color(0xFF00854A),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share ticket: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Booking Confirmation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 2,
                                color: const Color(0xFF00854A),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Container(
                                  width: 60 + (10 * _animationController.value),
                                  height:
                                      60 + (10 * _animationController.value),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF00854A).withOpacity(
                                      0.2 - (0.2 * _animationController.value),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF00854A),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00854A,
                                    ).withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Congratulations!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your slot has been booked!',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: RepaintBoundary(
                          key: _ticketKey,
                          child: _buildTicket(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF1E1E1E),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white10),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_outlined, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isDownloading ? null : _showShareOptions,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF00854A),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child:
                            _isDownloading
                                ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'Share Ticket',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
