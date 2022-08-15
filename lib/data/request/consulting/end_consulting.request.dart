class EndConsultingRequest {
  EndConsultingRequest(this.duration);
  int duration;
  toJson() {
    return {"duration": duration};
  }
}
