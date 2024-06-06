import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/upload_basic_first_page.dart';
import '../widgets/upload_basic_second_page.dart';
import '../widgets/upload_basic_third_page.dart';
import '../../../screens/my_closet.dart'; // Import the MyClosetPage

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({super.key});

  @override
  UploadItemPageState createState() => UploadItemPageState();
}

class UploadItemPageState extends State<UploadItemPage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = photo;
    });
  }

  @override
  void initState() {
    super.initState();
    _takePhoto();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _uploadAndNavigate();
    }
  }

  Future<void> _uploadAndNavigate() async {
    // Perform the upload action here
    // Simulate a delay for the upload process
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to MyClosetPage
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyClosetPage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
      ),
      body: _image == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _image != null
              ? Image.file(
            File(_image!.path),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          )
              : const Text('No image selected.'),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: const [
                UploadBasicFirstPage(),
                UploadOccasionSecondPage(),
                UploadReviewThirdPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(
                _currentPage == 2 ? 'Upload' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
