import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:draw_near/models/user.dart';

class LoginController with ChangeNotifier {
  // object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;
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

    this.userDetails = new UserDetails(
      displayName: this.googleSignInAccount!.displayName,
      email: this.googleSignInAccount!.email,
      photoURL: this.googleSignInAccount!.photoUrl,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
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

      this.userDetails = new UserDetails(
        displayName: requestData["name"],
        email: requestData["email"],
        photoURL: requestData["picture"]["data"]["url"] ?? " ",
      );
      notifyListeners();
      return await FirebaseAuth.instance.signInWithCredential(credential);

    }
  }

  // logout

  logout() async {
    this.googleSignInAccount = await _googleSignIn.signOut();
    await FacebookAuth.i.logOut();
    userDetails = null;
    notifyListeners();
  }
}