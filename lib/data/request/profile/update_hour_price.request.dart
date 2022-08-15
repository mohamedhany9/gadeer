class UpdateHourPriceRequest {
  final int price;
  UpdateHourPriceRequest(this.price);
  Map<String, dynamic> toJson() {
    return {"price": price};
  }
}
