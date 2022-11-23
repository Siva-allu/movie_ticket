import 'package:flutter/material.dart';
import 'package:movie_ticket/loginuser.dart';
import 'package:movie_ticket/utilities.dart';
import 'adminhome.dart';
class LoginAdmin extends StatefulWidget {
  const LoginAdmin({Key? key}) : super(key: key);

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginUser()));
              },
              child: Icon(
                  Icons.home_filled,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child:Container(
                  width: 300.0,
                  height: 200.0,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("ADMIN"),
                  ),
            ),
            ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: contactController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number ',
                    hintText: 'Enter Your Phone number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  primary: Colors.red[900],
                ),
                onPressed: () async {
                  var response=await Utilities().loginAdmin(contactController.text,passwordController.text);
                  if(response=='success'){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AdminHome()));
                  }else{
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          content: Text("${response}"),
                        ));
                  }
                  passwordController.clear();
                  contactController.clear();
                },
                child: Text("Login"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
