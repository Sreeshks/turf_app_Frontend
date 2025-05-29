import 'package:flutter/material.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:turf2/models/booking_data.dart';
import 'Payment.dart';

class CheckoutSummaryPage extends StatefulWidget {
  @override
  _CheckoutSummaryPageState createState() => _CheckoutSummaryPageState();
}

class _CheckoutSummaryPageState extends State<CheckoutSummaryPage> {
  String selectedPayment = 'advance';
  //late Razorpay razorpay;
  BookingData? bookingData;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // razorpay = Razorpay();

    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Get booking data from provider
    bookingData = BookingDataProvider().getBookingData();
    if (bookingData != null) {
      totalAmount = bookingData!.totalAmount;
    }
  }

  // @override
  //   void dispose() {
  //     razorpay.clear();
  //     super.dispose();
  //   }
  //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //     print('Payment Success:');
  //   }

  //   void _handlePaymentError(PaymentFailureResponse response) {
  //     // Handle payment error
  //     print('Payment Error: ${response.error}');
  //   }

  //   void _handleExternalWallet(ExternalWalletResponse response) {
  //     // Handle external wallet
  //     print('External Wallet: ${response}');
  //   }

  void opencheckout() {
    var options = {
      'key': 'rzp_test_eKhFJmDgLky7dl',
      'amount': (1 * 100).toInt(),
      'name': 'Fringe Creations',
      'description': 'Payment for cart items',
      'prefill': {'contact': '1234567890', 'email': 'user@example.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };
    // razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Changed to black background
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E), // Dark app bar
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout Summary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Event Card with dark gradient
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
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
                                colors: [Colors.black, Color(0xFF1E1E1E)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Image with gradient overlay
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF00854A),
                                      Color(0xFF006B3C),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Actual image
                                    Image.asset(
                                      'assets/12.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    // Gradient overlay to ensure text readability
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Event Details with white text
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Battledoor Badminton Academy',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'One-To-One(up on private courts)',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 8),

                                  // Location
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Color(0xFF00854A),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Saket, New Delhi-110017, India',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),

                                  // Date
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Color(0xFF00854A),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '9 June 2024',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),

                                  // Time
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Color(0xFF00854A),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '4 PM - 6 PM',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Apply Coupon with dark theme
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF00854A).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_offer,
                          color: Color(0xFF00854A),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Apply Coupon',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white54,
                      ),
                      onTap: () {},
                    ),
                  ),

                  SizedBox(height: 16),

                  // Payment Options with dark theme
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
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
                                colors: [Colors.black, Color(0xFF1E1E1E)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            // Advance Payment
                            RadioListTile<String>(
                              value: 'advance',
                              groupValue: selectedPayment,
                              activeColor: Color(0xFF00854A),
                              onChanged: (value) {
                                setState(() {
                                  selectedPayment = value!;
                                });
                              },
                              title: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00854A).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.flash_on,
                                      color: Color(0xFF00854A),
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Advance payment',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Get low pay now!',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(height: 1, color: Colors.white10),

                            // Full Payment
                            RadioListTile<String>(
                              value: 'full',
                              groupValue: selectedPayment,
                              activeColor: Color(0xFF00854A),
                              onChanged: (value) {
                                setState(() {
                                  selectedPayment = value!;
                                });
                              },
                              title: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00854A).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.payment,
                                      color: Color(0xFF00854A),
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Full Payment',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
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

                  SizedBox(height: 16),

                  // Price Details with dark theme
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
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
                                colors: [Colors.black, Color(0xFF1E1E1E)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00854A).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long,
                                      color: Color(0xFF00854A),
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'PRICE DETAILS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF00854A),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              // Base Price
                              _buildPriceRow('Base Price', 'INR 750'),
                              SizedBox(height: 8),

                              // Offer Discount
                              _buildPriceRow('Offer Discount', 'INR 0'),
                              SizedBox(height: 8),

                              // Payable at Venue
                              _buildPriceRow(
                                'Payable at Venue',
                                'INR ${totalAmount.toInt()}',
                              ),
                              SizedBox(height: 8),

                              // Advance Amount
                              _buildPriceRow('Advance Amount', 'INR 0'),
                              SizedBox(height: 8),

                              // Convenience Fee
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Convenience Fee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00854A).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'INR 50', // Fixed convenience fee
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Refund Policy with dark theme
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFF00854A).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info,
                            size: 16,
                            color: Color(0xFF00854A),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Read Cancellation Policy',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF00854A),
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),

          // Bottom Button with dark theme
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
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
                    // Show a brief loading animation before transitioning
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFF00854A),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Preparing Payment Options...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    // Add a short delay for better UX
                    Future.delayed(Duration(milliseconds: 800), () {
                      // Close the loading dialog
                      Navigator.of(context).pop();

                      // Navigate to payment screen with a custom transition animation
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PaymentScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            // Create a fade + slide up animation
                            var begin = Offset(0.0, 0.3);
                            var end = Offset.zero;
                            var curve = Curves.easeOutQuint;
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            var fadeAnimation = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            );

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 600),
                        ),
                      );
                    });
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
                        'PROCEED TO PAY',
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
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white70)),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
