import 'package:country_code_picker/country_code_picker.dart';
//import 'package:draw_near/provider/google_sign_in.dart';
import 'package:draw_near/screens/base-home.dart';
//import 'package:draw_near/util/color_theme.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/OTPController.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
{
  String dialCodeDigits="+91";
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
              Colors.pinkAccent,
            //Color(pastelThemePrimaryValue),
            //  Colors.pinkAccent,

            Colors.white,
              //Colors.red,
            ]
          )
        ),
        child: Column (
            mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            SizedBox(height: 40,),
            Padding(padding: const EdgeInsets.all(15.0),
              child: Image.asset("assets/images/new_logo.png"),
            ),

            /*Padding(
              padding: EdgeInsets.all(20),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Draw Near",style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10,),
                  Text("A Family Daily Devotion", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),*/
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
                        Text(" Sign in using Social account", style: TextStyle(color: Colors.black54),),
                        SizedBox(height: 20,),
                        Container(/*decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            color: Color(0xFFF1A9A9),
                            blurRadius: 25,
                            offset: Offset(0,10)
                          ),],
                        ),*/
                        child: Column(
                          children: [
                            SignInButton(
                              Buttons.GoogleDark,
                              //padding: EdgeInsets.all(4.0),
                              text : ("Sign in with Google"),

                             // shape: RoundedRectangleBorder(
                               //   borderRadius: BorderRadius.circular(10.0)),

                              onPressed: () {
                                Provider.of<LoginController>(context, listen: false)
                                    .googleLogin();
                              },
                            ),
                           /* GestureDetector(
                                child: Image.asset(
                                  "assets/images/google.png",
                                  width: 240,
                                ),
                                onTap: () {
                                  Provider.of<LoginController>(context, listen: false)
                                      .googleLogin();
                                }),*/
                          ],
                        )
                        ),
                        SizedBox(height: 5,),
                        Container(/*decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Color(0xFFF1A9A9),
                                blurRadius: 25,
                                offset: Offset(0,10)
                            )]
                        ),*/
                            child: Column(
                              children: [
                                SignInButton(
                                  Buttons.AppleDark,
                                  //padding: EdgeInsets.all(8.0),
                                  text: "Sign in with Apple",
                                  onPressed: () {
                                    Provider.of<LoginController>(context, listen: false)
                                        .googleLogin();
                                  },
                                ),
                                  //SizedBox(height: 20,),
                                ],
                            ),
                        ),
                        SizedBox(height: 5,),
                        Container(/*decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Color(0xFFF1A9A9),
                                blurRadius: 25,
                                offset: Offset(0,10)
                            )]
                        ),*/
                          child: Column(
                              children:[
                                SignInButton(
                                  Buttons.Facebook,
                                  text: "Sign in with Facebook",
                                  //padding: EdgeInsets.all(6.0),
                                  onPressed: () {
                                    Provider.of<LoginController>(context, listen: false)
                                        .facebooklogin();
                                  },
                                ),
                                //SizedBox(height: 20,),
                              ]
                          ),
                        ),
                        SizedBox(height: 20,),
                        //Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                        Text(" OR", style: TextStyle(color: Colors.black54),),
                        SizedBox(height: 20,),
                        //SizedBox(height: 50,),
                        Text(" Continue with Phone Number", style: TextStyle(color: Colors.black54),),
                        SizedBox(
                          width : 400,
                          height: 55,
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
                          margin: EdgeInsets.only(top: 0, right: 10, left: 10),
                          //color: Color(0xff1d1d1d),
                         // borderRadius: BorderRadius.circular(15),

                          child: TextField(
                          decoration: InputDecoration(

                            hintText: "   Enter your Phone Number",
                            prefix: Padding(
                              padding: EdgeInsets.all(2),
                              child: Text(dialCodeDigits),

                            )
                          ),
                           maxLength: 10,
                           keyboardType: TextInputType.number,
                           controller: _controller,
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.all(15),
                          width: 150,
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


                            child: Text('Verify',style: TextStyle(fontFamily: 'San Francisco',color: Colors.white,fontWeight: FontWeight.bold),),
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
          child: BaseHome(),
        );
        Navigator.push(context, new MaterialPageRoute(builder: (context)=> BaseHome()));
      }else{
        return loginControllers(context);
      }
      return Container();
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
          Image.network(model.userDetails?.photoURL ?? "").image,
          radius: 50,
        ),

        Text(model.userDetails?.displayName ?? ""),
        Text(model.userDetails?.email ?? ""),

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