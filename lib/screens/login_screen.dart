import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();


  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isLoading = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Future<void> login() async {

    String email =
        emailController.text.trim();

    String password =
        passwordController.text.trim();


    if(email.isEmpty || password.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please enter email and password'),
        ),
      );

      return;
    }


    if(!email.contains('@')){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Enter a valid email'),
        ),
      );

      return;
    }


    setState(() {
      isLoading = true;
    });


    // Get the data saved during Sign Up
    final prefs =
        await SharedPreferences.getInstance();

    String savedName =
        prefs.getString('userName') ?? '';

    String savedEmail =
        prefs.getString('userEmail') ?? '';

    String savedPassword =
        prefs.getString('userPassword') ?? '';


    // Check whether the entered data
    // matches the Sign Up data
    if(email != savedEmail ||
        password != savedPassword){

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Invalid email or password'),
        ),
      );

      return;
    }


    // Login successful
    // Save current logged-in user information
    await prefs.setBool(
      'isLoggedIn',
      true,
    );

    await prefs.setString(
      'loggedInUserName',
      savedName,
    );

    await prefs.setString(
      'loggedInUserEmail',
      savedEmail,
    );


    Future.delayed(
      const Duration(seconds: 2),
      (){

        if(!mounted) return;

        setState(() {
          isLoading = false;
        });


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context)=>
                const HomeScreen(),
          ),
        );

      },
    );

  }



  void forgotPassword(){

    showDialog(
      context: context,
      builder:(context){

        return AlertDialog(

          title:
              const Text(
                'Forgot Password',
              ),

          content:
              const Text(
                'Password reset feature will be connected with Firebase later.',
              ),

          actions:[

            TextButton(
              onPressed:(){
                Navigator.pop(context);
              },

              child:
                  const Text(
                    'OK',
                  ),
            ),

          ],
        );

      },
    );

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.white,


      body: SafeArea(

        child:
            SingleChildScrollView(

          padding:
              const EdgeInsets.all(28),


          child:
              Column(

            crossAxisAlignment:
                CrossAxisAlignment.stretch,


            children:[


              const SizedBox(
                height:50,
              ),



              // ChatNest Logo

              Center(

                child:
                    Container(

                  height:100,

                  width:100,


                  decoration:
                      BoxDecoration(

                    shape:
                        BoxShape.circle,


                    color:
                        Colors.green,

                  ),


                  child:
                      const Icon(

                    Icons.chat_rounded,

                    size:55,

                    color:
                        Colors.white,

                  ),

                ),

              ),



              const SizedBox(
                height:20,
              ),



              const Text(

                'ChatNest',

                textAlign:
                    TextAlign.center,


                style:
                    TextStyle(

                  fontSize:32,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),



              const SizedBox(
                height:8,
              ),



              const Text(

                'Connect with friends and chat securely',

                textAlign:
                    TextAlign.center,


                style:
                    TextStyle(

                  color:
                      Colors.grey,

                  fontSize:
                      15,

                ),

              ),



              const SizedBox(
                height:45,
              ),



              TextField(

                controller:
                    emailController,


                keyboardType:
                    TextInputType.emailAddress,


                decoration:
                    InputDecoration(

                  labelText:
                      'Email',

                  prefixIcon:
                      const Icon(
                        Icons.email_outlined,
                      ),


                  filled:
                      true,


                  fillColor:
                      Colors.grey.shade100,


                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                    borderSide:
                        BorderSide.none,

                  ),

                ),

              ),



              const SizedBox(
                height:20,
              ),



              TextField(

                controller:
                    passwordController,


                obscureText:
                    !isPasswordVisible,


                decoration:
                    InputDecoration(

                  labelText:
                      'Password',


                  prefixIcon:
                      const Icon(
                        Icons.lock_outline,
                      ),


                  suffixIcon:
                      IconButton(

                    icon:
                        Icon(

                      isPasswordVisible

                      ? Icons.visibility

                      : Icons.visibility_off,

                    ),


                    onPressed:(){

                      setState((){

                        isPasswordVisible =
                            !isPasswordVisible;

                      });

                    },

                  ),



                  filled:
                      true,


                  fillColor:
                      Colors.grey.shade100,


                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                    borderSide:
                        BorderSide.none,

                  ),

                ),

              ),



              Row(

                children:[


                  Checkbox(

                    value:
                        rememberMe,


                    onChanged:(value){

                      setState((){

                        rememberMe =
                            value ?? false;

                      });

                    },

                  ),


                  const Text(
                    'Remember me',
                  ),



                  const Spacer(),



                  TextButton(

                    onPressed:
                        forgotPassword,


                    child:
                        const Text(
                          'Forgot Password?',
                        ),

                  ),

                ],

              ),



              const SizedBox(
                height:20,
              ),



              SizedBox(

                height:55,


                child:
                    ElevatedButton(

                  onPressed:
                      isLoading
                      ? null
                      : login,


                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.green,


                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                            25,
                          ),

                    ),

                  ),


                  child:

                  isLoading

                  ?

                  const CircularProgressIndicator(
                    color: Colors.white,
                  )


                  :

                  const Text(

                    'Login',

                    style:
                        TextStyle(

                      color:
                          Colors.white,

                      fontSize:
                          17,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                ),

              ),



              const SizedBox(
                height:25,
              ),



              Row(

                mainAxisAlignment:
                    MainAxisAlignment.center,


                children:[

                  const Text(
                    "Don't have an account?",
                  ),


                  TextButton(

                    onPressed:(){

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(context)=>
                              const SignupScreen(),
                        ),
                      );

                    },


                    child:
                        const Text(
                          'Sign Up',
                        ),

                  ),

                ],

              ),

            ],

          ),

        ),

      ),

    );

  }

}