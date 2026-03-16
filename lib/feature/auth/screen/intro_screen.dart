import 'dart:ui';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/auth/sharedPref/intro_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late PageController _controller;
  double page = 0;

  final pages = const [
    _IntroData(
      title: 'Get Any Service Any Time, Any Where',
      subtitle:
      'India’s First Hybrid Service Maketplace',
      image:
      'https://assets10.lottiefiles.com/packages/lf20_0fhlytwe.json',
    ),
    _IntroData(
      title: 'Verified Service Provider',
      subtitle:
      'Every provider on Fetch True is Verified, Checked, and Reliable. So you can connect with confidence.',
      image:
      'https://assets1.lottiefiles.com/packages/lf20_tfb3estd.json',
    ),
    _IntroData(
      title: 'Nationwide Operation',
      subtitle:
      'Grow your business across India effortless, anytime and anywhere.',
      image:
      'https://assets2.lottiefiles.com/packages/lf20_jcikwtux.json',
    ),
  ];
  
  final _introImage =[
    'assets/auth/intro_one.png',
    'assets/auth/intro_two.png',
    'assets/auth/intro_three.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      setState(() => page = _controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Pages
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final isActive = page.round() == index;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔷 HERO LOTTIE (NETWORK) – SAME UI
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                        /// index by image
                        image: DecorationImage(image: AssetImage(_introImage[index]),fit: BoxFit.cover)
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          /// TITLE
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                            offset: isActive
                                ? Offset.zero
                                : const Offset(0, 0.3),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: isActive ? 1 : 0,
                              child: Text(
                                pages[index].title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// SUBTITLE
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 650),
                            curve: Curves.easeOutCubic,
                            offset: isActive
                                ? Offset.zero
                                : const Offset(0, 0.4),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: isActive ? 1 : 0,
                              child: Text(
                                pages[index].subtitle,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.7,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          /// Skip Button
          Positioned(
            top: 50,
            right: 16,
            child: // Skip button
            CustomContainer(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: CustomColor.appColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                await IntroSharedpref.setIntroSeen();
                if (!mounted) return;
                context.go('/dashboard');
              },

            ),
          ),

          /// Bottom Controls (UNCHANGED)
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    pages.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 6),
                      width: page.round() == i ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: page.round() == i
                            ? CustomColor.appColor
                            : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  // onTap: () {
                  //   if (page < pages.length - 1) {
                  //     _controller.nextPage(
                  //       duration: const Duration(milliseconds: 350),
                  //       curve: Curves.easeOut,
                  //     );
                  //   } else {
                  //     context.go('/dashboard');
                  //   }
                  // },
                  onTap: () async {
                    if (page < pages.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                      );
                    } else {
                      await IntroSharedpref.setIntroSeen();
                      if (!mounted) return;
                      context.go('/dashboard');
                    }
                  },

                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: CustomColor.appColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                          CustomColor.appColor.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// MODEL
class _IntroData {
  final String title;
  final String subtitle;
  final String image; // now holds Lottie URL

  const _IntroData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
