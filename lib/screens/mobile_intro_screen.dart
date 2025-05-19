import 'package:fit_well/screens/mobile_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MobileIntroScreens extends StatefulWidget {
  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<MobileIntroScreens> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              // Intro Screen 1
              _buildIntroScreen(
                imagePath: 'assets/images/introscreen1.png',
                title: "Track Your Intake and Burned Calories",
                subtitle:
                    "Calculate your total intake and burned calories in a day.",
              ),
              // Intro Screen 2
              _buildIntroScreen(
                imagePath: 'assets/images/introscreen2.png',
                title: "Count Your Total Water Intake",
                subtitle:
                    "Review your total water take in a day through your smartwatch.",
              ),
              // Intro Screen 3
              _buildIntroScreen(
                imagePath: 'assets/images/introscreen3.png',
                title: "Timer For Your Workout Time",
                subtitle:
                    "Set timer for your workout time through your smartwatch.",
              ),
            ],
          ),

          // Skip/Finish Button
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (currentPage == 2) {
                  // Handle Finish action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  // Handle Skip action
                  _controller.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                currentPage == 2 ? 'Finish' : 'Skip',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          // Dots Indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50), // Adjust as needed
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.grey,
                  dotColor: Colors.grey,
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroScreen({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 150, width: 150),
        const SizedBox(height: 68),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 300,
          height: 50,
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
