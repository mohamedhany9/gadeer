class AddRateRequest {
  String message;
  double rate;

  AddRateRequest(this.message, this.rate);

  toJson() {
    return {"message": message, "rate": rate};
  }
}
