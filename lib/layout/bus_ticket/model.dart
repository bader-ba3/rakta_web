class BusTicketModel {
  BusTicketModel ({ required this.status,this.from, this.to, this.date, this.fromDateTime, this.toDateTime, this.price,required this.seatNumber});
  String? from,to,date,fromDateTime,toDateTime,price;
  late bool status;
  List<int> seatNumber = [];
}