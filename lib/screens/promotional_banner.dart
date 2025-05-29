import 'package:flutter/material.dart';

class PromotionalBanner extends StatefulWidget {
  final List<Map<String, dynamic>> promotions;
  
  const PromotionalBanner({
    Key? key,
    required this.promotions,
  }) : super(key: key);

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align column contents to the left
      children: [
        // Container showing current banner with a peek of the next one
        SizedBox(
          height: 160, // Increased height for better visibility
          width: MediaQuery.of(context).size.width, // Full width
          child: PageView.builder(
            itemCount: widget.promotions.length,
            controller: PageController(viewportFraction: 0.88, initialPage: 0), // Reduced to show more of the second banner
            padEnds: false, // Don't add padding at the start and end of the PageView
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final promo = widget.promotions[index];
              return Container(
                margin: const EdgeInsets.only(right: 8, left: 16),
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
                    // Green overlay with gradient
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.center,
                            colors: [
                              const Color(0xFF0E9F6E).withOpacity(0.7),
                              const Color(0xFF00854A).withOpacity(0.0),
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
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.promotions.length,
            (index) => Container(
              width: _currentBannerIndex == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentBannerIndex == index
                    ? const Color(0xFF00854A)
                    : const Color.fromARGB(255, 248, 247, 247),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
