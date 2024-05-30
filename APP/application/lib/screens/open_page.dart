import 'package:flutter/material.dart';
import 'package:AppController/theme/theme.dart';

class OpenPage extends StatefulWidget {
  const OpenPage({super.key});

  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: backgroundColor1,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: themeImage,
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/image/background.png",
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.55,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome Smart Home\nConnect with smart devices",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: textColor1,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Đoạn này chưa biết ghi gì nên thui",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor2,
                      ),
                    ),
                    SizedBox(height: size.height * 0.07),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 155,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.qr_code,
                                  color: textColor1,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/scanip");
                                },
                                label: Text(
                                  "Scan QRCode",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor1,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 155,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.search,
                                  color: textColor1,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/searchip");
                                },
                                label: Text(
                                  "Search IP",
                                  style: TextStyle(
                                    color: textColor1,
                                    fontSize: 13,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
