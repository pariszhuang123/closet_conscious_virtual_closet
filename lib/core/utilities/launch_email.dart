import 'package:url_launcher/url_launcher.dart';
import 'logger.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

enum EmailType { support, npsReview }

void launchEmail(BuildContext context, EmailType emailType) async {
  final CustomLogger logger = CustomLogger('EmailLauncher');
  String subject;
  String body;

  // Fetch localized strings based on email type
  switch (emailType) {
    case EmailType.support:
      subject = S.of(context).supportEmailSubject;
      body = S.of(context).supportEmailBody;
      break;
    case EmailType.npsReview:
      subject = S.of(context).npsReviewEmailSubject;
      body = S.of(context).npsReviewEmailBody;
      break;
  }

  final Uri params = Uri(
    scheme: 'mailto',
    path: 'support@makinglifeeasie.com', // Adjust this for different email addresses if needed
    query: 'subject=$subject&body=$body',
  );

  var url = params.toString();
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    // Use logger for error handling instead of print
    logger.e('Could not launch $url');
  }
}
