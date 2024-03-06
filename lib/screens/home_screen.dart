import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tem_tech_task_assignment/custom%20widget/progressbar.dart';
import 'package:tem_tech_task_assignment/firebase/firebase_storage.dart';
import 'package:tem_tech_task_assignment/screens/fibonacci.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? _image;
  String? uplodingFile;
  String? ext;
  String? uploaded;
  String? _newImage;
  bool isVideo = false;
  bool UplodedVideo = false;
  // File? _video;
  VideoPlayerController? _videoPlayerController;
  late final AnimationController _Animationcontroller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("1. Upload Image and Video"),
        actions: [
          SizedBox(
            width: 50,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FibonacciScreen()));
              },
              child: Text("Next"),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        // Upload Image and video
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: isVideo
                  ? _videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        )
                      : const Icon(
                          Icons.image,
                          color: Colors.red,
                          size: 100,
                        )
                  : _image != null
                      ? Image.file(File(_image!))
                      : const Icon(
                          Icons.image,
                          color: Colors.red,
                          size: 100,
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 230, 228, 228),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      final bool? isImage = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Pick Image or Video'),
                          content:
                              Text('Do you want to pick an image or a video?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // User wants to pick an image
                              },
                              child: Text('Image'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // User wants to pick a video
                              },
                              child: Text('Video'),
                            ),
                          ],
                        ),
                      );
                      XFile? pickedFile;

                      if (isImage != null) {
                        if (isImage) {
                          pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          isVideo = false;
                          UplodedVideo = false;
                          showPreview(pickedFile!);
                        } else {
                          pickedFile = await picker.pickVideo(
                              source: ImageSource.gallery);
                          isVideo = true;
                          print('new status $isVideo');
                          showPreview(pickedFile!);
                        }
                      }
                    },
                    child: const Text(
                      "Choose file",
                      style: TextStyle(color: Colors.black),
                    )),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 150,
                  child: ext == null
                      ? const Text("No File choosen")
                      : Text(
                          ext.toString(),
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    if (uplodingFile != null) {
                      CustomWidgets.showProgressBar(
                          context, _Animationcontroller);
                      bool status = await Api.UploadImage(File(uplodingFile!));
                      Navigator.pop(context);
                      if (status == true) {
                        CustomWidgets.showFlushBar(
                            context, 'File uploaded Successfully');
                        setState(() {
                          _newImage = _image;
                          _image = null;
                          uploaded = ext.toString();
                          ext = null;
                          isVideo = false;
                        });
                      } else {
                        CustomWidgets.showFlushBar(
                            context, 'Something went wrong try again!');
                      }
                    } else {
                      CustomWidgets.showFlushBar(context, 'Please select file');
                    }
                  },
                  child: const Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            uploaded != null
                ? Container(
                    width: 280,
                    height: 40,
                    color: const Color.fromARGB(255, 213, 244, 214),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            uploaded.toString(),
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ShowAlertDialog(context);
                          },
                          child: Text(
                            'view',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // Before Upload Preview
  void showPreview(XFile file) async {
    if (file != null) {
      File imageFile = File(file.path);
      int fileSizeInBytes = await imageFile.length();
      double fileSizeInKB = fileSizeInBytes / 1024;

      if (fileSizeInKB <= 10000 && isVideo == false) {
        setState(() {
          _image = file.path;
          uplodingFile = file.path;
        });
        ext = file.name;
      } else if (fileSizeInKB <= 10000 && isVideo == true) {
        // _video = File();
        _videoPlayerController = VideoPlayerController.file(File(file.path))
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController?.play();
            uplodingFile = file.path;
            ext = file.name;
            UplodedVideo = true;
          });
      } else {
        CustomWidgets.showFlushBar(
            context, 'File length should be less then 100 MB');
      }
    }
  }

  // After Upload Preview
  void ShowAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: UplodedVideo
              ? _videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : Container()
              : Image.file(File(_newImage!), scale: 1),
        );
      },
    );
  }
}
