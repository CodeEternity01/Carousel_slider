import 'package:flutter/material.dart';

class CarouselWithReflection extends StatefulWidget {
  const CarouselWithReflection({super.key});

  @override
  _CarouselWithReflectionState createState() => _CarouselWithReflectionState();
}

class _CarouselWithReflectionState extends State<CarouselWithReflection> {
  final List<String> images = [
    'assets/Images/song1.png',
    'assets/Images/song2.png',
    'assets/Images/song3.png',
    'assets/Images/song4.png',
    'assets/Images/song5.png'
  ];

  final List<String> songTitles = [
    'Song 1 - Artist',
    'Song 2 - Artist',
    'Song 3 - Artist',
    'Song 4 - Artist',
    'Song 5 - Artist'
  ];

  final PageController _pageController = PageController(viewportFraction: 0.4);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentIndex != next) {
        setState(() {
          _currentIndex = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double carouselHeight = screenHeight * 0.65; // 50% of screen height

    return Column(
      children: [
        // Carousel
        SizedBox(
          height: carouselHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * .3)).clamp(0.9, 1.0);
                  }

                  double rotationY = 0.0;
                  if (_pageController.position.haveDimensions) {
                    rotationY = _pageController.page! - index;
                    rotationY = rotationY.clamp(-1.0, 1.0);
                  }

                  return Transform(
                    transform: Matrix4.identity()
                      ..scale(value)
                      ..rotateY(rotationY),
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Opacity(
                            opacity: value,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Image.asset(
                                    height: 200,
                                    width: 200,
                                    images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationX(3.14159),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(
                                        height: 200,
                                        width: 200,
                                        images[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text(
                            songTitles[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Music Player Bar
        // SizedBox(height: 150,),
        Container(
          color: Colors.grey[900],
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(images[_currentIndex]),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Now Playing',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        songTitles[_currentIndex],
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: () {
                      // Handle previous song
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      // Handle play/pause
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: () {
                      // Handle next song
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}