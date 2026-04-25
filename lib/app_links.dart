import 'package:url_launcher/url_launcher.dart';

const String armourConverterUrl = 'https://snapcraft.io/armour-converter';

Future<bool> openExternalLink(String url) async {
  final uri = Uri.parse(url);
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<bool> openArmourConverterStore() async {
  return openExternalLink(armourConverterUrl);
}
