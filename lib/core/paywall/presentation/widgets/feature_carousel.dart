import 'package:flutter/material.dart';
import '../../../widgets/layout/page_indicator.dart';

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
        PageIndicator(
          itemCount: widget.imageUrls.length,
          currentIndex: currentIndex,
          theme: widget.theme,
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
