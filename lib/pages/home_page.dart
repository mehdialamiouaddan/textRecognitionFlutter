import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String data = "";
  final textDetector = GoogleMlKit.vision.textDetector();
  Uint8List byte;
  Future<String> detect(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    return recognisedText.text;
  }

  final ImagePicker _picker = ImagePicker();

  Future<XFile> pick(ImageSource i) async {
    // Pick an image
    final XFile image = await _picker.pickImage(source: i);
    return image;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                byte != null
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.memory(byte),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    byte != null ? "Extracted Data" : "Choose a file",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$data',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var p = await pick(ImageSource.gallery);
          String d = await detect(p.path);
          byte = await p.readAsBytes();
          setState(() {
            data = d;
          });
        },
        tooltip: 'Camera',
        child: const Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
