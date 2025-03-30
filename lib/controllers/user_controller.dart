import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;

  /// Logs in with Google and updates the user
  static Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) {
        return null; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      user = userCredential.user; // Update the static user variable

      if (user != null) {
        await _storeUserInFirestore(user!);
        await _saveUserLocally(user!.uid);
      }

      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  /// Stores user info in Firestore
  static Future<void> _storeUserInFirestore(User user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").doc(user.uid).set({
      "name": user.displayName,
      "email": user.email,
    }, SetOptions(merge: true));
  }

  /// Saves user ID in SharedPreferences
  static Future<void> _saveUserLocally(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userID", userId);
  }

  /// Gets stored user ID from SharedPreferences
  static Future<String?> getStoredUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userID");
  }

  /// Auto-login using stored user ID
  static Future<User?> getLoggedInUser() async {
    String? storedUserId = await getStoredUserId();
    if (storedUserId == null) return null;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(storedUserId)
            .get();

    if (userDoc.exists) {
      user = FirebaseAuth.instance.currentUser;
      return user;
    }

    return null;
  }

  /// Signs out from Firebase and Google
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      user = null;

      print("User logged out successfully.");
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  static Future<User?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": name,
          "email": email,
          "createdAt": Timestamp.now(),
        });
      }
      return user;
    } catch (e) {
      throw FirebaseAuthException(message: e.toString(), code: "SIGNUP_FAILED");
    }
  }
}
