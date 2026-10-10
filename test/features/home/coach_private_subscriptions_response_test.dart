import 'package:coach_app/features/home/data/models/coach_private_subscriptions_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoachPrivateSubscriptionsResponse', () {
    test('parses coach details from the documented response shape', () {
      final response = CoachPrivateSubscriptionsResponse.fromJson({
        'status': 'success',
        'message': 'Coach private subscriptions retrieved successfully',
        'data': {
          'coach': {
            'id': 1,
            'coach_id': 1,
            'full_name': 'Coach Example',
            'first_name': 'Coach',
            'last_name': 'Example',
            'gender': 'male',
            'age': 32,
            'dob': '1994-05-15',
            'photo_url': 'https://example.com/coach.jpg',
            'phone': '0991234567',
            'phone_number': '0991234567',
            'email': 'coach@example.com',
            'username': 'coach_example',
            'work_status': 'active',
            'is_active': true,
            'employment_type': 'percentage',
            'base_salary': 0,
            'default_commission_rate': 20.0,
            'private_commission_rate': 30.0,
            'experience_years': 7,
            'branches': [
              {'id': 1, 'name': 'Main branch'},
            ],
          },
          'summary': {'total_plans': 2},
          'plans': [],
          'all_subscriptions': [],
        },
      });

      final coach = response.coach;
      expect(coach.id, 1);
      expect(coach.fullName, 'Coach Example');
      expect(coach.age, 32);
      expect(coach.photoUrl, 'https://example.com/coach.jpg');
      expect(coach.phone, '0991234567');
      expect(coach.username, 'coach_example');
      expect(coach.employmentType, 'percentage');
      expect(coach.privateCommissionRate, 30.0);
      expect(coach.isActive, isTrue);
      expect(coach.branches.single.name, 'Main branch');
    });

    test('supports documented aliases and string numeric values', () {
      final response = CoachPrivateSubscriptionsResponse.fromJson({
        'data': {
          'coach': {
            'first_name': 'Coach',
            'last_name': 'Example',
            'phone_number': '0991234567',
            'contract_type': 'fixed',
            'private_commission_rate': '25.5',
            'is_active': '1',
          },
        },
      });

      expect(response.coach.fullName, 'Coach Example');
      expect(response.coach.phone, '0991234567');
      expect(response.coach.employmentType, 'fixed');
      expect(response.coach.privateCommissionRate, 25.5);
      expect(response.coach.isActive, isTrue);
    });

    test('rejects a response missing coach data', () {
      expect(
        () => CoachPrivateSubscriptionsResponse.fromJson({'data': {}}),
        throwsFormatException,
      );
    });
  });
}
