import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imagelinks;
  const CarouselImage({super.key, required this.imagelinks});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imagelinks.map((link) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    margin: const EdgeInsets.all(10.0),
                    child: Image.network(
                      link,
                      fit: BoxFit.contain,
                    ));
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            Row(
              children: widget.imagelinks.asMap().entries.map((e) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                      _current == e.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        )
      ],
    );
  }
}
