class UpdateTokenRequest {
  String? token;
  UpdateTokenRequest(this.token);
  toJson() {
    return {"fcm_token": token};
  }
}
