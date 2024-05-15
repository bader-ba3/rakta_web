import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakta_web/ticket_widget.dart';
import 'package:rakta_web/to_image.dart';
import 'package:rakta_web/utils/hive.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'dart:html' as html;
import 'const/route.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class BusTicket extends StatelessWidget {
  final BusTicketModel model ;
  const BusTicket({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    TextEditingController numberController = TextEditingController();
    GlobalKey widgetKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details Ticket"),
        actions: [
          InkWell(
            onTap: (){
              Get.offAllNamed(Routes.home);
            },
            child: Row(
              children: [
                Text("Exit",style: TextStyle(fontSize: 20,color: Colors.red.shade800),),
                SizedBox(width: 10,),
                Icon(Icons.exit_to_app,color: Colors.red.shade800),
              ],
            ),
          ),
          SizedBox(width: 20,),
        ],
      ),
      backgroundColor: Color(0xFF014f86),
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              Spacer(),
              WidgetToImage(
                builder: (GlobalKey<State<StatefulWidget>> key) {
                  widgetKey = key;
                 return TicketWidget(
                    width: 400,
                    height: MediaQuery.sizeOf(context).height/1.5,
                    isCornerRounded: true,
                    aspectRatio: 1.5,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(flex:9,child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Row (
                                  children: [
                                    SizedBox(
                                        width:80,
                                        child: Center(child: Text("From",style: TextStyle(color: Colors.black,fontSize: 22),))),
                                    Spacer(),
                                    SizedBox(
                                        width:80,
                                        child: Center(child: Text("To",style: TextStyle(color: Colors.black,fontSize: 22),))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        child: Center(child: Text(model.from!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),))),
                                    Icon(Icons.arrow_back_ios_new,color: Colors.black,size: 15),
                                    Expanded(child: Container(color: Colors.black,height: 1,)),
                                    Icon(Icons.directions_bus,color: Colors.grey,),
                                    Expanded(child: Container(color: Colors.black,height: 1,)),
                                    Icon(Icons.arrow_forward_ios_sharp,color: Colors.black,size: 15,),
                                    SizedBox(
                                        child: Center(child: Text(model.to!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),))),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: List.generate(43, (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Container(height: 2,width: 4,color: Colors.grey,),
                              )),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Passengers",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 5,),
                                    Text(model.seatNumber.length.toString()+" Adults",style: TextStyle(fontWeight: FontWeight.w600),)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Seats No",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 5,),
                                    Text(model.seatNumber.join(","),style: TextStyle(fontWeight: FontWeight.w600),)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ticket No",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 5,),
                                    Text("42WLd94",style: TextStyle(fontWeight: FontWeight.w600),)
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Passenger Name",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 5,),
                                    Text(HiveDataBase.getUserData().name,style: TextStyle(fontWeight: FontWeight.w600),)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ticket Fare",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 5,),
                                    Text("50 AED",style: TextStyle(fontWeight: FontWeight.w600),)
                                  ],
                                ),
                                SizedBox(),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Center(child: Text("Ticket Status: CONFIRMED"),)
                          ],
                        )),
                        Expanded(child: Center(
                          child: Row(
                            children: List.generate(43, (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Container(height: 2,width: 4,color: Colors.grey,),
                            )),
                          ),
                        )),
                        Expanded(flex: 4,child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Text("show this to the Driver of the bus"),
                            Container(
                              height: 100,
                              child: SfBarcodeGenerator(
                                  value: 'Ba3.co'),
                            )
                          ],
                        ))
                      ],
                    ),
                  );
                },

              ),
              Spacer(flex: 2,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Uint8List data = await Utils.capture(widgetKey);
                      final base64data = base64Encode(data);
                      final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
                      a.download = 'download.jpg';
                      a.click();
                      a.remove();
                    },
                    child: Container(width: 500,height: 100,decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text("Save on Device",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
                    ),
                  ),
                  SizedBox(height: 150,),
                  Container(width: 500,
                    child: Column(
                      children: [
                        Container(
                          width: 500,
                          decoration: BoxDecoration(color: Colors.grey.shade100,borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child:Center(child: Text("Send To "+HiveDataBase.getUserData().mobile,style: TextStyle(fontWeight: FontWeight.bold),))
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                              Uint8List imageData = await Utils.capture(widgetKey);
                              final String url = 'https://graph.facebook.com/v19.0/190767744131124/media';
                              final String token = 'EABkHbZCvVgEABOyCNG3UJQZCLIITZA7qYwv5W4pBts7zTal6BNUJfhkWEyEFN7ZCnPpqhSIb0BzIxcd8NlJgVPMnfZBCXAYJcYEPF84XN3YLjS8GEuOs0u3wsLCfK7823sUwaikW6XnVokmfQ0az8eKHyC0r03k5ZAtgcZBZAye8gs5dwhhAUZC0hFhc0EeD4OQ6VfvrqLsj79OcxO5aAsxMV4TcyNNnDkZCtyNcL2y94bMR4ZD';

                              // Detect the mime type of the image data
                              final mimeType = lookupMimeType('', headerBytes: imageData);

                              // Create multipart request
                              var request = http.MultipartRequest('POST', Uri.parse(url));
                              request.headers['Authorization'] = 'Bearer $token';
                              request.fields['messaging_product'] = 'whatsapp';
                              request.files.add(
                                http.MultipartFile.fromBytes(
                                  'file',
                                  imageData,
                                  filename: 'upload.png',  // You can use any filename
                                  contentType: MediaType.parse(mimeType!),
                                ),
                              );

                              try {
                                var response = await request.send();

                                if (response.statusCode == 200) {
                                  print('Image uploaded successfully');
                                  var responseBody = await response.stream.bytesToString();
                                  print(responseBody);
                                  print(json.decode(responseBody)['id']);
                                  sendMessage(json.decode(responseBody)['id']);
                                } else {
                                  print('Failed to upload image: ${response.statusCode}');
                                  var responseBody = await response.stream.bytesToString();
                                  print(responseBody);
                                }
                              } catch (e) {
                                print('Error uploading image: $e');
                              }
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight:Radius.circular(15))),
                            width: 500,
                            height: 100,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.wh,color: Colors.green,size: 40,),
                                  Image.asset("assets/whatsapp.png",width: 50,),
                                  SizedBox(width: 10,),
                                  Text("Send on Whatsapp",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage(String imageId) async {
    final String url = 'https://graph.facebook.com/v19.0/190767744131124/messages';
    final String token = 'EABkHbZCvVgEABOyCNG3UJQZCLIITZA7qYwv5W4pBts7zTal6BNUJfhkWEyEFN7ZCnPpqhSIb0BzIxcd8NlJgVPMnfZBCXAYJcYEPF84XN3YLjS8GEuOs0u3wsLCfK7823sUwaikW6XnVokmfQ0az8eKHyC0r03k5ZAtgcZBZAye8gs5dwhhAUZC0hFhc0EeD4OQ6VfvrqLsj79OcxO5aAsxMV4TcyNNnDkZCtyNcL2y94bMR4ZD';

    final Map<String, dynamic> requestBody = {
      "messaging_product": "whatsapp",
      "recipient_type": "individual",
      "to": HiveDataBase.getUserData().mobile,
      "type": "template",
      "template": {
        "name": "1_ticket",
        "language": {
          "code": "en_US"
        },
        "components": [
          {
            "type": "header",
            "parameters": [
              {
                "type": "image",
                "image": {
                  "id": imageId
                }
              }
            ]
          }
        ]
      }
    };

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
      print(response.body);
    } else {
      print('Failed to send message: ${response.statusCode}');
      print(response.body);
    }
  }
}