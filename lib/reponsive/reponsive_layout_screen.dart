import 'package:flutter/material.dart';
import 'package:instagram_clone/Providers/user_provider.dart';
import 'package:instagram_clone/utils/globalvariable.dart';
import 'package:provider/provider.dart';


class ResponsiveLayout extends StatefulWidget {

  final Widget DeskTopScreen;
  final Widget MobileScreen;
  const ResponsiveLayout({Key? key, required this.DeskTopScreen, required this.MobileScreen}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async{
    //calling a fumnction
    UserProvider _userProvider=Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if(constraints.maxWidth>web_Screen_Size){
          //webscreen
          return widget.DeskTopScreen;

        }
        return widget.MobileScreen;
        //mobile screen
      },),
    );
  }
}
