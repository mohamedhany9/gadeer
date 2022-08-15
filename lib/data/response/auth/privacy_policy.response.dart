import 'package:gadeer/data/model/privacy_policy.model.dart';

class PrivacyPolicyResponse {
  PrivacyPolicyModel? policyModel;

  PrivacyPolicyResponse.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      policyModel = PrivacyPolicyModel.fromJson(json);
    }
  }
}
