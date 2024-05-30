import 'package:AppController/theme/theme.dart';
import 'package:flutter/material.dart';

class SearchIp extends StatefulWidget {
  const SearchIp({super.key});

  @override
  State<SearchIp> createState() => _SearchIpState();
}

class _SearchIpState extends State<SearchIp> {
  final TextEditingController _ipController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _ipController.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _ipController.text.length;
    });
  }

  @override
  void dispose() {
    _ipController.removeListener(_updateCharCount);
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              backgroundColor2,
              backgroundColor3,
              backgroundColor4,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Connect Devices",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 42,
                  color: textColor1,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "You need to enter the device's ip",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: textColor2,
                  height: 1.2,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              IpTextField("Local IP", Colors.white),
              const SizedBox(height: 10),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // for sign in button
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: size.width * 0.2,
                          color: Colors.black12,
                        ),
                        Text(
                          "  Or continue with   ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor2,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          height: 2,
                          width: size.width * 0.2,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        socialIcon("assets/image/google.png"),
                        socialIcon("assets/image/apple.png"),
                        socialIcon("assets/image/facebook.png"),
                      ],
                    ),
                    SizedBox(height: size.height * 0.07),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Do you want to return to the home page?",
                            style: TextStyle(
                              color: textColor2,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // Handle icon button press
                            Navigator.pushReplacementNamed(
                                context, "/openpage");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Image.asset(
        image,
        height: 35,
      ),
    );
  }

  Widget IpTextField(String hint, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _ipController,
            maxLength: 15,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 22,
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 19,
              ),
              suffixIcon: Icon(
                Icons.visibility_off_outlined,
                color: color,
              ),
              counterText: "", // Hide default counter text
            ),
          ),
          SizedBox(height: 20),
          Text(
            "$_charCount/15",
            style: TextStyle(
              color: textColor2,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
