import 'package:flutter/material.dart';

class FeatureCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> descriptions;
  final ThemeData theme;

  const FeatureCarousel({
    super.key,
    required this.imageUrls,
    required this.descriptions,
    required this.theme,
  });

  @override
  FeatureCarouselState createState() => FeatureCarouselState();
}

class FeatureCarouselState extends State<FeatureCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image Carousel
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4, // Height for the image
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.contain,
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Page Indicator below the image
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imageUrls.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: currentIndex == index ? 12.0 : 8.0,
              height: currentIndex == index ? 12.0 : 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? widget.theme.colorScheme.primary
                    : Colors.grey,
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Display the description below the indicator
        Text(
          widget.descriptions[currentIndex],
          style: widget.theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
