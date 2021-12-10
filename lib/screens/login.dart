import 'package:country_code_picker/country_code_picker.dart';
import 'package:draw_near/provider/google_sign_in.dart';
import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/OTPController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
{
  String dialCodeDigits= "+91";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: loginUI(),

    );
  }

      loginControllers(BuildContext context){
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(pastelThemePrimaryValue),
              Colors.white,
              Colors.pinkAccent,
             Colors.white70,
              //Colors.red,
            ]
          )
        ),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Draw Near",style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10,),
                  Text("A Family Daily Devotion", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height:20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children:<Widget>[
                        SizedBox(height: 50,),
                        Container(decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            color: Color(0xFFF1A9A9),
                            blurRadius: 25,
                            offset: Offset(0,10)
                          ),],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                                child: Image.asset(
                                  "assets/images/google.png",
                                  width: 240,
                                ),
                                onTap: () {
                                  Provider.of<LoginController>(context, listen: false)
                                      .googleLogin();
                                }),
                          ],
                        )
                        ),
                        SizedBox(height: 10,),
                        Container(decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Color(0xFFF1A9A9),
                                blurRadius: 25,
                                offset: Offset(0,10)
                            )]
                        ),
                            child: Column(
                              children: [
                                GestureDetector(
                                    child: Image.asset(
                                      "assets/images/apple.png",
                                      //height: 40,
                                      width: 240,
                                    ),
                                    onTap: () {
                                      Provider.of<LoginController>(context, listen: false)
                                          .googleLogin();
                                    }),
                                  //SizedBox(height: 20,),
                                ],
                            ),
                        ),
                        SizedBox(height: 10,),
                        Container(decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Color(0xFFF1A9A9),
                                blurRadius: 25,
                                offset: Offset(0,10)
                            )]
                        ),
                          child: Column(
                              children:[
                                GestureDetector(
                                    child: Image.asset(
                                      "assets/images/fb.png",
                                      width: 240,
                                    ),
                                    onTap: () {
                                      Provider.of<LoginController>(context, listen: false)
                                          .facebooklogin();
                                    }),
                                //SizedBox(height: 20,),
                              ]
                          ),
                        ),
                        SizedBox(height: 20,),
                        //Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                        Text(" OR", style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 20,),
                        //SizedBox(height: 50,),
                        Text(" Continue with Phone Number", style: TextStyle(color: Colors.grey),),
                        SizedBox(
                          width : 400,
                          height: 60,
                          child: CountryCodePicker(
                            onChanged: (country){
                              setState((){
                                dialCodeDigits = country.dialCode!;
                              });
                          },
                            initialSelection: "IN",
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            favorite: ["+91","IN", "+1","US"],
                          ),
                        ),


                        Container(
                          //height: 50,
                          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: TextField(
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(dialCodeDigits),
                            )
                          ),
                           maxLength: 12,
                           keyboardType: TextInputType.number,
                           controller: _controller,
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.all(15),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pinkAccent, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: (){
                             // if(hasValue()) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (c) =>
                                        OTPControllerScreen(
                                          phone: _controller.text,
                                          codeDigits: dialCodeDigits,
                                        )));
                             // }

                            },


                            child: Text('Verify',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          )
                        )

                      ]
                    )
                  )
                )
              )
            )
          ]
        )
      );
  }

  loginUI(){
    return Consumer<LoginController>(

    //var authStateChanges = FirebaseAuth.instance.authStateChanges();
        builder: (context, models, child){

      if(models.userDetails!=null){
        return Center(
          child: loggedInUI(models),
        );
      }else{
        return loginControllers(context);
      }
    });
  }


  loggedInUI(LoginController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      // our ui will have 3 children, name, email, photo , logout button

      children: [
        CircleAvatar(
          backgroundImage:
          Image.network(model.userDetails!.photoURL ?? "").image,
          radius: 50,
        ),

        Text(model.userDetails!.displayName ?? ""),
        Text(model.userDetails!.email ?? ""),

        // logout
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("Logout"),
            onPressed: () {
              Provider.of<LoginController>(context, listen: false).logout();
            })


      ],
    );
  }


}