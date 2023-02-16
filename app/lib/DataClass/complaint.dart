class Complaint {
  String block;
  String floor;
  String roomNo;
  String complaint;
  String complainType;
  String status;
  String complaintId;
  String timeStamp;
  String updateStamp;
  Complaint(
      {required this.complaint,
      required this.roomNo,
      required this.floor,
      required this.block,
      required this.complainType,
      required this.status,
      required this.complaintId,
      required this.timeStamp,
      required this.updateStamp});
}
