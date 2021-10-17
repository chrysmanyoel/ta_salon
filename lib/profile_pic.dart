import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("images/background.png"),
          ),
          // Container(
          //     decoration: BoxDecoration(
          //       border: Border.all(
          //         width: 2,
          //       ),
          //     ),
          //     padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
          //     width: MediaQuery.of(context).size.width,
          //     height: 200.0,
          //     child: Center(
          //       child: _image == null
          //           ? Image.network(
          //               this.foto,
          //               width: 150,
          //               height: 150,
          //               fit: BoxFit.cover,
          //             )
          //           : Image.file(_image),
          //     ),
          //   ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  print("a");
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
