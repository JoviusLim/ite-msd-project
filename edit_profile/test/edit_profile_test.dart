import 'package:flutter_test/flutter_test.dart';
import 'package:your_project_name/services/profile_service.dart';
import 'package:your_project_name/models/user_profile.dart';

void main() {
  group('ProfileService', () {
    late ProfileService profileService;

    setUp(() {
      profileService = ProfileService();
    });

    test('should fetch user profile', () async {
      final userProfile = await profileService.fetchUserProfile();
      expect(userProfile, isA<UserProfile>());
      expect(userProfile.name, isNotEmpty);
      expect(userProfile.email, isNotEmpty);
    });

    test('should update user profile', () async {
      final userProfile = UserProfile(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '1234567890',
        age: 30,
        weight: 70.0,
        height: 175.0,
      );

      final result = await profileService.updateUserProfile(userProfile);
      expect(result, true);
    });
  });
}