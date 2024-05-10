// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "SignupApple":
            MessageLookupByLibrary.simpleMessage("Sign up with Apple"),
        "SignupGoogle":
            MessageLookupByLibrary.simpleMessage("Sign up with Google"),
        "SignupSocialAccount": MessageLookupByLibrary.simpleMessage(
            "Sign up with your Social Account"),
        "appName": MessageLookupByLibrary.simpleMessage("Closet Conscious"),
        "loginApple": MessageLookupByLibrary.simpleMessage("Login with Apple"),
        "loginFailed": MessageLookupByLibrary.simpleMessage(
            "Login failed. Please check your credentials and try again"),
        "loginGoogle":
            MessageLookupByLibrary.simpleMessage("Login with Google"),
        "loginSocialAccount": MessageLookupByLibrary.simpleMessage(
            "Login with your social account"),
        "loginSuccess": MessageLookupByLibrary.simpleMessage(
            "Welcome back! You are now logged in"),
        "offlineStatus":
            MessageLookupByLibrary.simpleMessage("You are currently offline"),
        "retryConnection": MessageLookupByLibrary.simpleMessage("Retry"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up")
      };
}
