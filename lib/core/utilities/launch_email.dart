import 'package:url_launcher/url_launcher.dart';
import 'logger.dart';

void launchEmail() async {
  final CustomLogger logger = CustomLogger('EmailLauncher');

  final Uri params = Uri(
    scheme: 'mailto',
    path: 'support@makinglifeeasie.com',
    query: 'subject=Support Request&body=Describe your issue here',
  );

  var url = params.toString();
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    // Use logger for error handling instead of print
    logger.e('Could not launch $url');
  }
}
