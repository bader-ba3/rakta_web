import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusSeat extends StatefulWidget {
  final Null Function(List<int> seats) onChooseSeat;
  const BusSeat({super.key, required  this.onChooseSeat});

  @override
  State<BusSeat> createState() => _BusSeatState();
}
class _BusSeatState extends State<BusSeat> {
  List<int>  picked = [];
  List<int> listSelected = [];

  @override
  void initState() {

  picked=List.generate(Random().nextInt(47),(index) =>  Random().nextInt(47),);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/images/bus_top.png",
          width: MediaQuery.sizeOf(context).width / 1.5,
          fit: BoxFit.cover,
        ),
        Container(
          width: MediaQuery.sizeOf(context).width / 1.6,
          child: AspectRatio(
            aspectRatio: 3,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: List.generate(12, (index) => (index + 4) + (index * 3))
                                  .map((e) => Expanded(
                                  child: e == 24
                                      ? SizedBox()
                                      : Builder(builder: (context) {
                                    int index = e > 24 ? e - 4 : e;
                                    return InkWell(
                                      onTap: picked.contains(index)
                                          ? null
                                          : () {
                                        setState(() {
                                          if (listSelected.contains(index)) {
                                            listSelected.remove(index);
                                          } else {
                                            listSelected.add(index);
                                          }
                                          widget.onChooseSeat(listSelected);
                                        });
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(listSelected.contains(index)
                                                      ? "assets/images/green.svg"
                                                      : picked.contains(index)
                                                      ? "assets/images/blue.svg"
                                                      : "assets/images/white.svg"),
                                                  Text(index.toString())
                                                ],
                                              ))),
                                    );
                                  })))
                                  .toList(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: List.generate(12, (index) => (index + 3) + (index * 3))
                                  .map((e) => Expanded(
                                  child: e == 23
                                      ? SizedBox()
                                      : Builder(builder: (context) {
                                    int index = e > 23 ? e - 4 : e;
                                    return InkWell(
                                      onTap: picked.contains(index)
                                          ? null
                                          : () {
                                        setState(() {
                                          if (listSelected.contains(index)) {
                                            listSelected.remove(index);
                                          } else {
                                            listSelected.add(index);
                                          }
                                          widget.onChooseSeat(listSelected);
                                        });
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(listSelected.contains(index)
                                                      ? "assets/images/green.svg"
                                                      : picked.contains(index)
                                                      ? "assets/images/blue.svg"
                                                      : "assets/images/white.svg"),
                                                  Text(index.toString())
                                                ],
                                              ))),
                                    );
                                  })))
                                  .toList(),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Row(
                              children: [
                                Spacer(
                                  flex: 11,
                                ),
                                Expanded(
                                    child: InkWell(
                                      onTap: picked.contains(47)
                                          ? null
                                          : () {
                                        setState(() {
                                          if (listSelected.contains(47)) {
                                            listSelected.remove(47);
                                          } else {
                                            listSelected.add(47);
                                          }
                                          widget.onChooseSeat(listSelected);
                                        });
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(listSelected.contains(47)
                                                      ? "assets/images/green.svg"
                                                      : picked.contains(47)
                                                      ? "assets/images/blue.svg"
                                                      : "assets/images/white.svg"),
                                                  Text("47")
                                                ],
                                              ))),
                                    ))
                              ],
                            )),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: List.generate(12, (index) => (index + 2) + (index * 3))
                                  .map((index) => Expanded(
                                  child: InkWell(
                                    onTap: picked.contains(index)
                                        ? null
                                        : () {
                                      setState(() {
                                        if (listSelected.contains(index)) {
                                          listSelected.remove(index);
                                        } else {
                                          listSelected.add(index);
                                        }
                                        widget.onChooseSeat(listSelected);
                                      });
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child: Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SvgPicture.asset(listSelected.contains(index)
                                                    ? "assets/images/green.svg"
                                                    : picked.contains(index)
                                                    ? "assets/images/blue.svg"
                                                    : "assets/images/white.svg"),
                                                Text(index.toString())
                                              ],
                                            ))),
                                  )))
                                  .toList(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: List.generate(12, (index) => (index + 1) + (index * 3))
                                  .map((index) => Expanded(
                                  child: InkWell(
                                    onTap: picked.contains(index)
                                        ? null
                                        : () {
                                      setState(() {
                                        if (listSelected.contains(index)) {
                                          listSelected.remove(index);
                                        } else {
                                          listSelected.add(index);
                                        }
                                        widget.onChooseSeat(listSelected);
                                      });
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child: Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SvgPicture.asset(listSelected.contains(index)
                                                    ? "assets/images/green.svg"
                                                    : picked.contains(index)
                                                    ? "assets/images/blue.svg"
                                                    : "assets/images/white.svg"),
                                                Text(index.toString())
                                              ],
                                            ))),
                                  )))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

