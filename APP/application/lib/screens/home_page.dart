import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? IP_Devices;
  Future<void> _handle_SendStateLED(bool state, String cmd, String url) async {
    String command = state ? '${cmd}_ON' : '${cmd}_OFF';
    try {
      final response = await http.get(Uri.parse('${url}?cmd=$command'));
      if (response.statusCode == 200) {
        print('HTTP request sent successfully.');
      } else {
        print('Failed to send HTTP request.');
      }
    } catch (e) {
      print('Error sending HTTP request: $e');
    }
  }

  bool lampState = false;
  bool speed_1_State = false;
  bool speed_2_State = false;
  bool speed_3_State = false;
  void _handle_UpdateStateSpeed(bool speed1, bool speed2, bool speed3) {
    setState(() {
      speed_1_State = speed1;
      speed_2_State = speed2;
      speed_3_State = speed3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      IP_Devices = args;
    }
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/openpage");
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    iconSize: 32,
                    color: Colors.indigo,
                  ),
                  const RotatedBox(
                    quarterTurns: 135,
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello Duy Tùng",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Image.asset(
                        "assets/image/background_home.png",
                        scale: 0.75,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Smart Home",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Container(
                      width: 330,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.device_thermostat,
                                    color: Colors.indigo,
                                    size: 36,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '31°c',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Temperature',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: VerticalDivider(
                                thickness: 1,
                                color: Colors.grey[700]!,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.water_drop_outlined,
                                    color: Colors.indigo,
                                    size: 36,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '26%',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Humidity',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
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
                    const SizedBox(height: 10),
                    Container(
                      width: 330,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.light_rounded,
                                color: Colors.black,
                                size: 36,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lamp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    lampState ? 'ON' : 'OFF',
                                    style: lampState
                                        ? TextStyle(
                                            fontSize: 16, color: Colors.green)
                                        : TextStyle(
                                            fontSize: 16, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: lampState,
                            onChanged: (value) {
                              setState(() {
                                lampState = value;
                              });
                              _handle_SendStateLED(value, 'LED_0', IP_Devices!);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 330,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.ac_unit,
                                color: Colors.blue,
                                size: 36,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Speed: 0',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Switch(
                                value: speed_1_State,
                                onChanged: (value) {
                                  if (value) {
                                    _handle_UpdateStateSpeed(
                                        true, false, false);
                                  } else {
                                    _handle_UpdateStateSpeed(
                                        false, false, false);
                                  }
                                },
                              ),
                              Switch(
                                value: speed_2_State,
                                onChanged: (value) {
                                  if (value) {
                                    _handle_UpdateStateSpeed(
                                        false, true, false);
                                  } else {
                                    _handle_UpdateStateSpeed(
                                        false, false, false);
                                  }
                                },
                              ),
                              Switch(
                                value: speed_3_State,
                                onChanged: (value) {
                                  if (value) {
                                    _handle_UpdateStateSpeed(
                                        false, false, true);
                                  } else {
                                    _handle_UpdateStateSpeed(
                                        false, false, false);
                                  }
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
            ],
          ),
        ),
      ),
    );
  }
}
