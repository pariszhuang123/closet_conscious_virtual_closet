import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/config/config_reader.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;

  GoogleSignInService()
      : _googleSignIn = GoogleSignIn(
    clientId: ConfigReader.getIosClientId(),
    serverClientId: ConfigReader.getWebClientId(),
  );

  Future<GoogleSignInAuthentication> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google sign-in aborted';
    }
    return await googleUser.authentication;
  }
}
