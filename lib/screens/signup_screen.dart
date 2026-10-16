import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword =
        confirmPasswordController.text.trim();

    // Check empty fields
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    // Check password
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
        ),
      );
      return;
    }

    // Password length
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 6 characters',
          ),
        ),
      );
      return;
    }

    try {
      final prefs =
          await SharedPreferences.getInstance();

      // Check if an account already exists
      final existingEmail =
          prefs.getString('userEmail');

      if (existingEmail != null &&
          existingEmail == email) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This email is already registered',
            ),
          ),
        );
        return;
      }

      // Save signup information
      await prefs.setString(
        'userName',
        name,
      );

      await prefs.setString(
        'userEmail',
        email,
      );

      await prefs.setString(
        'userPassword',
        password,
      );

      // Account is not logged in automatically
      await prefs.setBool(
        'isLoggedIn',
        false,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully',
          ),
        ),
      );

      // Go back to Login screen
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [
              const SizedBox(height: 20),

              // Signup Icon
              const Icon(
                Icons.person_add_rounded,
                size: 75,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                'Create your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Join ChatNest and start chatting',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 35),

              // Name
              TextField(
                controller: nameController,

                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',

                  prefixIcon: const Icon(
                    Icons.person_outline,
                  ),

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Email
              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,

                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',

                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Password
              TextField(
                controller: passwordController,
                obscureText:
                    !isPasswordVisible,

                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a password',

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        isPasswordVisible =
                            !isPasswordVisible;
                      });
                    },
                  ),

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Confirm Password
              TextField(
                controller:
                    confirmPasswordController,

                obscureText:
                    !isConfirmPasswordVisible,

                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText:
                      'Enter password again',

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible =
                            !isConfirmPasswordVisible;
                      });
                    },
                  ),

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Create Account
              SizedBox(
                height: 55,

                child: ElevatedButton(
                  onPressed: createAccount,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green,

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text(
                    'Create Account',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Text(
                    'Already have an account?',
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight:
                            FontWeight.bold,
                      ),
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