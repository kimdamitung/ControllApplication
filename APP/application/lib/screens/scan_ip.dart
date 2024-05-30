import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanIp extends StatefulWidget {
  const ScanIp({super.key});

  @override
  State<ScanIp> createState() => _ScanIpState();
}

class _ScanIpState extends State<ScanIp> {
  Future<void> _handle_CheckStatus(String url) async {
    final response = await http.get(Uri.parse('$url?cmd=CHECK'));
    if (response.statusCode == 200 &&
        response.body == 'CHECK CONNECT SUCCESS') {
      Navigator.pushReplacementNamed(context, "/homepage", arguments: url);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('CONNECT FAILING'),
            content: Text('Could not connect to devices'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/openpage");
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            final rawValue = barcode.rawValue;
            print('Barcode found! ${rawValue}');
            if ((rawValue != null) &&
                (Uri.tryParse(rawValue)?.isAbsolute == true)) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("IP Devices"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (image != null) Image(image: MemoryImage(image)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _handle_CheckStatus(rawValue);
                          },
                          child: const Text('Connect'),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              if (image != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(rawValue ?? ""),
                      content: Image(
                        image: MemoryImage(image),
                      ),
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  }
}
