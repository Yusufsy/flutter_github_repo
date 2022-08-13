import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  Future<void> launchUrlRepo(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
