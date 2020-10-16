import 'package:dystopia_flutter_app/screens/list_of_pets.dart';
import 'package:dystopia_flutter_app/widgets/platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dystopia_flutter_app/widgets/platform_widgets.dart';

class PetCategory extends StatelessWidget {
  final String emoji;
  final String name;

  final BuildContext context;
  const PetCategory({
    Key key,
    this.context,
    this.emoji,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Tooltip(
        message: name,
        child: Material(
          type: MaterialType.canvas,
          child: InkWell(
            onTap: () {
              PlatformPageRoute.pageRoute(
                  fullScreen: false,
                  widget: ListScreen(),
                  fromRoot: true,
                  context: context);
            },
            child: IgnorePointer(
              child: Container(
                child: Center(
                  child: Text(emoji, style: TextStyle(fontSize: 50.0))
                )
              ),
            ),
          ),
        ),
      ),
    );*/

    /*return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Tooltip(
        message: name,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0,17),
                blurRadius: 23,
                spreadRadius: -13,
                color: Color(0xFFE6E6E6)
            )
            ]
          ),
          child: Column(
            children: <Widget>[
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          )
        )
      )
    );*/

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              PlatformPageRoute.pageRoute(
                fullScreen: false,
                widget: ListScreen(),
                fromRoot: true,
                context: context);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: 50.0))
              )
              ),
            ),
          ),
        ),
      );
  }
}
