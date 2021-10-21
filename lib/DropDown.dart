import 'package:flutter/material.dart';
import 'ExpandedListAnimationWidget.dart';
import 'Scrollbar.dart';

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

List<String> _list = ['semua', 'dibatalkan', 'selesai'];

class _DropDownState extends State<DropDown> {
  bool isStrechedDropDown = false;
  int groupValue;
  String title = 'Select Filter Status';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Custom Drop Down ",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 400,
                color: Colors.yellow,
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffbbbbbb)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27))),
                            child: Column(
                              children: [
                                Container(
                                    // height: 45,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xffbbbbbb),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    constraints: BoxConstraints(
                                      minHeight: 45,
                                      minWidth: double.infinity,
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isStrechedDropDown =
                                                        !isStrechedDropDown;
                                                  });
                                                },
                                                child: Text(
                                                  title,
                                                ),
                                              )),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isStrechedDropDown =
                                                    !isStrechedDropDown;
                                              });
                                            },
                                            child: Icon(isStrechedDropDown
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward))
                                      ],
                                    )),
                                ExpandedSection(
                                  expand: isStrechedDropDown,
                                  height: 100,
                                  child: MyScrollbar(
                                    builder: (context, scrollController2) =>
                                        ListView.builder(
                                            padding: EdgeInsets.all(0),
                                            controller: scrollController2,
                                            shrinkWrap: true,
                                            itemCount: _list.length,
                                            itemBuilder: (context, index) {
                                              return RadioListTile(
                                                  title: Text(
                                                      _list.elementAt(index)),
                                                  value: index,
                                                  groupValue: groupValue,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      groupValue = val;
                                                      title = _list
                                                          .elementAt(index);
                                                      isStrechedDropDown =
                                                          !isStrechedDropDown;
                                                    });
                                                  });
                                            }),
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
