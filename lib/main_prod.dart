import 'package:closet_conscious/main_common.dart';
import 'package:closet_conscious/environment.dart';

Future<void> main() async {
  await mainCommon(Environment.prod);
}