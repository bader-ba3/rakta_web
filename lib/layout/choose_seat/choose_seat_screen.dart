import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rakta_web/layout/choose_seat/bus_seat.dart';

import '../../model.dart';
import '../../payment.dart';
import '../home_page/home_page_screen.dart';

class ChooseSeatScreen extends StatefulWidget {
  final String from, to, date;
  const ChooseSeatScreen({
    super.key,
    required this.from,
    required this.to,
    required this.date,
  });

  @override
  State<ChooseSeatScreen> createState() => _ChooseSeatScreenState();
}

class _ChooseSeatScreenState extends State<ChooseSeatScreen> {
  List<int> seats = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text("Confirm Booking"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  child: BusSeat(
                   onChooseSeat: (_seats) {
                     setState(() {
                       seats = _seats;
                     });
                   },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15),boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 10)]),
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Center(child: Text("Summrize",style: TextStyle(fontSize: 24),)),
                          SizedBox(height: 5,),
                          Expanded(child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: seats.length,
                            itemBuilder: (context, index) =>  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Seat NO",style: TextStyle(fontSize: 20),),
                                  SizedBox(width: 5,),
                                  Text(seats[index].toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 10,),
                                  Text("X",style: TextStyle(fontSize: 22),),
                                  SizedBox(width: 10,),
                                  Text("100",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 5,),
                                  Text("AED",style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ),

                          )),
                          Container(height: 2,color: Colors.grey.shade300,),
                          SizedBox(
                            height: 100,
                            child: Center(child: Text((seats.length*100).toString()+" AED",style: TextStyle(fontSize: 24),)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25,),
              ],
            ),
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text("From: ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text(widget.from,style: TextStyle(fontSize: 22),),
              Spacer(),
              Text("To: ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text(widget.to,style: TextStyle(fontSize: 22),),
              Spacer(),
              Text("Date: ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text(widget.date,style: TextStyle(fontSize: 22),),
              Spacer(),
              Text("Number of Seat: ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text(seats.length.toString(),style: TextStyle(fontSize: 22),),
              Spacer(),
              Text("Total: ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text((seats.length*100).toString()+" AED",style: TextStyle(fontSize: 22),),
              Spacer(),
            ],
          ),
          Spacer(),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Get.to(BusTicket(model: BusTicketModel(status:true,from: widget.from,to: widget.to, seatNumber:seats ),));
                },
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text("Confrim Booking",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
