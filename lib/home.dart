import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  Future<File>? imageFile;
  File? _image;
  String result ='';
  ImagePicker? imagePicker;
  
  selectPhotoFromGallery()async{
    XFile? pickedFile = await imagePicker!.pickImage(source: ImageSource.gallery);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageClassification();
    });
  }
  
  capturePhotoFromCamera()async{
    XFile? pickedFile = await imagePicker!.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageClassification();
    });
  }
  
  loadDataModelFiles()async{
    String? output = await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    print(output);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    loadDataModelFiles();
  }
  
  doImageClassification()async{
    var recognitions = await Tflite.runModelOnImage(path: _image!.path,
    imageMean: 0.0,
    imageStd: 255.0,
    numResults: 1,
    threshold: 0.1,
    asynch: true,
    );
    print(recognitions!.length.toString());
    setState(() {
      result ='';
    });
    recognitions.forEach((element) { 
      setState(() {
       print(element.toString());
       result += element['label'] + '\n';
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('DreamWorks - Project'),
        leading: const Icon(Icons.camera_alt),
      ),
      body: Container(
        decoration: const BoxDecoration(

          image: DecorationImage(image: AssetImage('assets/undraw_Doctors.png'),
          fit: BoxFit.cover
          )
        ),
        child: Column(
          children: [
            const SizedBox(width:100.0),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: [
                  Center(
                    child: TextButton(onPressed: selectPhotoFromGallery,
                        onLongPress: capturePhotoFromCamera,
                        child: Container(
                          margin: const EdgeInsets.only(top: 30.0, right: 35.0, left: 10.0),
                          child: _image!=null? Image.file(_image!, height: 360.0, width: 400.0,fit: BoxFit.contain,) : Container(
                            width: 140.0,
                            height: 190.0,
                            child: const Icon(
                              Icons.image_search,
                              color: Colors.red,
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const Text(
                    " Skin diseases detection Results ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold ,
                        fontSize: 20.0,
                        color: Colors.white,
                        backgroundColor: Colors.black
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Text(
                    "$result",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold ,
                        fontSize: 17.0,
                        color: Colors.white,
                        backgroundColor: Colors.red
                    ),
                  ),
                  ElevatedButton(onPressed: () {
                    //Get.snackbar('Feature Coming soon', 'Update in progress');
                    Get.bottomSheet(
                      Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Maximilian - Chat NOW!'),
                            onTap: () {
                              Get.snackbar('Feature Coming soon', 'Update in progress');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Harris - Chat NOW!'),
                            onTap: () {
                              Get.snackbar('Feature Coming soon', 'Update in progress');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Evgenni - Chat NOW!'),
                            onTap: () {
                              Get.snackbar('Feature Coming soon', 'Update in progress');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Maiia - Chat NOW!'),
                            onTap: () {
                              Get.snackbar('Feature Coming soon', 'Update in progress');
                            },
                          )
                        ],
                      ),
                      backgroundColor: Colors.white,
                    );
                  }, child: Text('Make Appointment'))
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
