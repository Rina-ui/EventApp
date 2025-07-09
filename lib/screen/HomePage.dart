import 'dart:async';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> images = [
    'assets/images/166dfc42becbc594dff6022087956a3f.jpg',
    'assets/images/a9b6accc1241c4fa748fb10a73bdf58c.jpg',
    'assets/images/b06c6a5cf62451d613edbab22b5e8229.jpg',
    'assets/images/dd5591ebed2005210844a84e8eb8bd0f.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                  child: PageView.builder(
                    controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                  )
              ),
              Expanded(
                flex: 2,
                  child: Column(
                    children: [

                    ],
                  )
              ),
            ],
          )
      ),
    );
  }
}
