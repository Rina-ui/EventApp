import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List events = [];
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

    fetchEvents();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchEvents() async {
    final response = await http.get(
    Uri.parse('https://www.eventbriteapi.com/v3/events/search/?q=music'),
      headers: {
      'Authorization': 'Bearer RA6KINIJRKCF3XVITBE5 '
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Nombre d\'événements : ${data['events'].length}');
      setState(() {
        events = data['events'];
      });
    }else {
      print('Erreur: ${response.statusCode}');
    }
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
                  child: events.isEmpty
                      ? Center(child: CircularProgressIndicator()) //loader
                      : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text(event['name']['text'] ?? 'Sans titre'),
                        subtitle: Text(
                          event['description']['text'] ?? 'Sans description',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
              ),
            ],
          )
      ),
    );
  }
}
