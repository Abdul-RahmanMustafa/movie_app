import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/features/authentication/data/firebase_failure_mapper.dart';
import 'package:movie_app/features/authentication/domain/auth_failure.dart';

void main() {
  test('a canceled Google flow is reported as cancelled', () {
    final failure = FirebaseFailureMapper.fromGoogle(
      const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
    );

    expect(failure.type, AuthFailureType.cancelled);
  });

  test('an unknown Play services error is not swallowed as generic', () {
    // Play services reports an unregistered signing certificate (the debug
    // SHA-1 case) as unknownError.
    final failure = FirebaseFailureMapper.fromGoogle(
      const GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: 'Unknown error [status=UNREGISTERED_ON_API_CONSOLE]',
      ),
    );

    expect(failure.type, AuthFailureType.providerConfiguration);
    expect(failure.message, isNot(contains('Something went wrong')));
  });

  test('unmapped errors fall back to the generic failure', () {
    expect(
      FirebaseFailureMapper.fromGoogle(StateError('boom')).type,
      AuthFailureType.unexpected,
    );
  });
}
