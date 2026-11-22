import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/auth_failure.dart';

abstract final class FirebaseFailureMapper {
  static AuthFailure fromAuth(Object error) {
    if (error is AuthFailure) return error;
    if (error is! FirebaseAuthException) return _unexpected;

    return switch (error.code) {
      'invalid-email' => const AuthFailure(
        type: AuthFailureType.invalidEmail,
        message: 'Please enter a valid email address.',
      ),
      'invalid-credential' ||
      'user-not-found' ||
      'wrong-password' => const AuthFailure(
        type: AuthFailureType.invalidCredentials,
        message: 'The email or password is incorrect.',
      ),
      'email-already-in-use' => const AuthFailure(
        type: AuthFailureType.emailAlreadyInUse,
        message: 'An account already exists for this email address.',
      ),
      'weak-password' => const AuthFailure(
        type: AuthFailureType.weakPassword,
        message: 'Please choose a stronger password.',
      ),
      'network-request-failed' => const AuthFailure(
        type: AuthFailureType.networkUnavailable,
        message: 'No network connection. Please try again.',
      ),
      'too-many-requests' => const AuthFailure(
        type: AuthFailureType.tooManyRequests,
        message: 'Too many attempts. Please wait and try again.',
      ),
      'user-disabled' => const AuthFailure(
        type: AuthFailureType.userDisabled,
        message: 'This account has been disabled. Please contact support.',
      ),
      'account-exists-with-different-credential' ||
      'credential-already-in-use' => const AuthFailure(
        type: AuthFailureType.accountConflict,
        message:
            'An account already exists for this email using a different '
            'sign-in method. Please use your email and password.',
      ),
      _ => _unexpected,
    };
  }

  static AuthFailure fromGoogle(Object error) {
    if (error is FirebaseAuthException) return fromAuth(error);
    if (error is! GoogleSignInException) return _unexpected;

    return switch (error.code) {
      GoogleSignInExceptionCode.canceled => const AuthFailure(
        type: AuthFailureType.cancelled,
        message: 'Google Sign-In was cancelled.',
      ),
      GoogleSignInExceptionCode.interrupted => const AuthFailure(
        type: AuthFailureType.unexpected,
        message: 'Google Sign-In was interrupted. Please try again.',
      ),
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError => const AuthFailure(
        type: AuthFailureType.providerConfiguration,
        message:
            'Google Sign-In is not configured correctly. Please '
            'contact support.',
      ),
      GoogleSignInExceptionCode.uiUnavailable => const AuthFailure(
        type: AuthFailureType.unexpected,
        message: 'Google Sign-In is temporarily unavailable. Please try again.',
      ),
      GoogleSignInExceptionCode.userMismatch => const AuthFailure(
        type: AuthFailureType.accountConflict,
        message:
            'The selected Google account does not match the current '
            'account. Please try again.',
      ),
      _ => _unexpected,
    };
  }

  static AuthFailure fromProfileWrite(Object error) {
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return const AuthFailure(
          type: AuthFailureType.permissionDenied,
          message:
              'Your account was created, but access to save your profile '
              'was denied. Please try again or contact support.',
        );
      }
      if (error.code == 'unavailable' ||
          error.code == 'network-request-failed') {
        return const AuthFailure(
          type: AuthFailureType.networkUnavailable,
          message:
              'Your account was created, but the profile could not be '
              'saved while offline. Please try Create Account again.',
        );
      }
    }

    return const AuthFailure(
      type: AuthFailureType.profileCreationFailed,
      message:
          'Your account was created, but the profile could not be saved. '
          'Please try Create Account again.',
    );
  }

  static AuthFailure fromGoogleProfileWrite(Object error) {
    if (error is FirebaseException && error.code == 'permission-denied') {
      return const AuthFailure(
        type: AuthFailureType.permissionDenied,
        message:
            'Google Sign-In succeeded, but access to save your profile '
            'was denied. Please try again or contact support.',
      );
    }
    if (error is FirebaseException &&
        (error.code == 'unavailable' ||
            error.code == 'network-request-failed')) {
      return const AuthFailure(
        type: AuthFailureType.networkUnavailable,
        message:
            'Google Sign-In succeeded, but your profile could not be '
            'synchronized while offline. Please try again.',
      );
    }
    return const AuthFailure(
      type: AuthFailureType.profileCreationFailed,
      message:
          'Google Sign-In succeeded, but your profile could not be '
          'synchronized. Please try again.',
    );
  }

  static AuthFailure fromPasswordReset(Object error) {
    if (error is! FirebaseAuthException) return _unexpected;

    return switch (error.code) {
      'invalid-email' || 'missing-email' => const AuthFailure(
        type: AuthFailureType.invalidEmail,
        message: 'Please enter a valid email address.',
      ),
      'network-request-failed' => const AuthFailure(
        type: AuthFailureType.networkUnavailable,
        message: 'No network connection. Please try again.',
      ),
      'too-many-requests' => const AuthFailure(
        type: AuthFailureType.tooManyRequests,
        message: 'Too many reset requests. Please wait and try again.',
      ),
      _ => _unexpected,
    };
  }

  static AuthFailure fromSignOut(Object error) {
    if (error is FirebaseAuthException) return fromAuth(error);
    if (error is GoogleSignInException) {
      return const AuthFailure(
        type: AuthFailureType.unexpected,
        message: 'Could not sign out safely. Please try again.',
      );
    }
    return _unexpected;
  }

  static const AuthFailure _unexpected = AuthFailure(
    type: AuthFailureType.unexpected,
    message: 'Something went wrong. Please try again.',
  );
}
