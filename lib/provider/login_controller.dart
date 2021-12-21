import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:draw_near/models/user.dart';

class LoginController with ChangeNotifier {
  // object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;
  final _firebaseAuth = FirebaseAuth.instance;
  //final user= FirebaseAuth.instance.currentUser!;

  // fucntion for google login
  Future googleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    // inserting values to our user details model
    if(googleUser==null) return;
    googleSignInAccount= googleUser;
    final googleAuth= await googleUser.authentication;

    final credential=GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    this.userDetails = new UserDetails(
      userCredential.user!.uid,
      this.googleSignInAccount?.displayName ?? "User",
      email: this.googleSignInAccount!.email,
      photoURL: this.googleSignInAccount!.photoUrl,
        phoneNumber: ""

    );

    await  FirebaseFirestore.instance.collection('users').doc(userDetails?.uid).set(userDetails!.toJson());
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
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      // Once signed in, return the UserCredential
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );


      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      this.userDetails = new UserDetails(
        userCredential.user!.uid,
        requestData["name"],
        email: requestData["email"],
        photoURL: requestData["picture"]["data"]["url"] ?? " ",
        phoneNumber: ""
      );
      await  FirebaseFirestore.instance.collection('users').doc(userDetails?.uid).set(userDetails!.toJson());
      UserService.instance.userDetails = this.userDetails!;
      UserService.instance.isLoggedIn = true;
      notifyListeners();
      return userCredential;
    }
  }

  Future phoneLogin(UserCredential value) async {
    if(value.user !=null)
    {
      this.userDetails = new UserDetails(
          value.user!.uid,
          "User",
          email:"",
          photoURL:"https://www.google.co.in",
          phoneNumber: value.user?.phoneNumber

      );

      await FirebaseFirestore.instance.collection('users').doc(userDetails?.uid).set(userDetails!.toJson());
      UserService.instance.userDetails = this.userDetails!;
      UserService.instance.isLoggedIn = true;
      notifyListeners();
      return value;
    }
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
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
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
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
    notifyListeners();
  }
}