import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/user.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class LoginController with ChangeNotifier {
  // object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;
  final _firebaseAuth = FirebaseAuth.instance;
  //final user= FirebaseAuth.instance.currentUser!;

  // fucntion for google login
  Future<UserCredential?> googleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    // inserting values to our user details model
    if (googleUser == null) return null;
    googleSignInAccount = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    this.userDetails = new UserDetails(userCredential.user!.uid,
        this.googleSignInAccount?.displayName ?? "User",
        email: this.googleSignInAccount!.email,
        photoURL: this.googleSignInAccount!.photoUrl,
        phoneNumber: "");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails?.uid)
        .set(userDetails!.toJson());
    UserService.instance.userDetails = this.userDetails!;
    UserService.instance.isLoggedIn = true;

    // call
    notifyListeners();
  }

  // function for facebook login
  Future<UserCredential?> facebooklogin() async {
    final LoginResult result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );
    // check the status of our login
    if (result.status == LoginStatus.success) {
      //final AccessToken accessToken = result.accessToken!;
      // final AccessToken? accessToken = await FacebookAuth.i.accessToken;
// or FacebookAuth.i.accessToken
      //if (accessToken != null) {
      // user is logged
      //}
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      // Once signed in, return the UserCredential
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      this.userDetails = new UserDetails(
          userCredential.user!.uid, requestData["name"],
          email: requestData["email"],
          photoURL: requestData["picture"]["data"]["url"] ?? " ",
          phoneNumber: "");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails?.uid)
          .set(userDetails!.toJson());
      UserService.instance.userDetails = this.userDetails!;
      UserService.instance.isLoggedIn = true;
      notifyListeners();
      return userCredential;
    }
  }

  Future phoneLogin(UserCredential value) async {
    if (value.user != null) {
      this.userDetails = new UserDetails(value.user!.uid, "User",
          email: "", photoURL: "", phoneNumber: value.user?.phoneNumber);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails?.uid)
          .set(userDetails!.toJson());
      UserService.instance.userDetails = this.userDetails!;
      UserService.instance.isLoggedIn = true;
      print(UserService.instance.isLoggedIn);
      notifyListeners();
      return value;
    }
  }

  Future<User?> signInWithApple(
      {List<Scope> scopes = const [Scope.email, Scope.fullName]}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        print(result.credential?.toMap().toString());
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        var displayName = "User";

        final fullName = appleIdCredential.fullName;
        if (fullName != null &&
            fullName.givenName != null &&
            fullName.familyName != null) {
          displayName = '${fullName.givenName} ${fullName.familyName}';
          await firebaseUser.updateDisplayName(displayName);
        }

        final email = appleIdCredential.email;
        await firebaseUser.updateDisplayName(displayName);

        this.userDetails = new UserDetails(
            userCredential.user!.uid, displayName,
            email: email ?? "", photoURL: "", phoneNumber: "");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDetails?.uid)
            .set(userDetails!.toJson());
        UserService.instance.userDetails = this.userDetails!;
        UserService.instance.isLoggedIn = true;
        notifyListeners();

        return firebaseUser;
      case AuthorizationStatus.error:
        Fluttertoast.showToast(msg: "Something went wrong !");
        FirebaseCrashlytics.instance.setCustomKey(
            'description', result.error?.localizedDescription ?? "");
        FirebaseCrashlytics.instance.setCustomKey('recovery suggestion',
            result.error?.localizedRecoverySuggestion ?? "");
        FirebaseCrashlytics.instance.recordError(result.error, null,
            reason: result.error?.localizedFailureReason);
        break;

      case AuthorizationStatus.cancelled:
        break;
      default:
        throw FirebaseCrashlytics.instance.recordError(
            'Default case executed on Apple Sign In for Authorization status',
            null);
    }
  }

  /*String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
*/
  // logout

  logout() async {
    this.googleSignInAccount = await _googleSignIn.signOut();
    FacebookAuth.i.logOut();
    FirebaseAuth.instance.signOut();
    userDetails = null;
    print(userDetails);
    UserService.instance.removeUserDetails();
    UserService.instance.isLoggedIn = false;
    print('is logged in');
    print(UserService.instance.isLoggedIn);
    notifyListeners();
  }
}
