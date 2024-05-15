import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageProcessing {
  List<int>? _extractedImage;
  late Size _containerSize;
  late Offset _offset;

  // Method to extract part of the image from a File object
  Future<File?> getFromFile(File file) async {
    // Load the image from the file
    final image = await _loadImageFromFile(file);

    // Extract the part of the image inside the draggable container
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final srcRect = Rect.fromLTWH(
      _offset.dx * image.width / 301,
      _offset.dy * image.height / 301,
      _containerSize.width * image.width / 301,
      _containerSize.height * image.height / 301,
    );
    final dstRect =
        Rect.fromLTWH(0, 0, _containerSize.width, _containerSize.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());

    // Convert the pixels to a byte buffer
    final imageByteData = await recorder
        .endRecording()
        .toImage(_containerSize.width.toInt(), _containerSize.height.toInt());
    final byteData =
        await imageByteData.toByteData(format: ui.ImageByteFormat.png);

    // Update the extracted image
    _extractedImage = byteData!.buffer.asUint8List();

    // Convert Uint8List to File
    return _unit8ListToFile(_extractedImage!);
  }

  // Method to convert a Uint8List to a File
  Future<File> _unit8ListToFile(List<int> imageData) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.png');
    await file.writeAsBytes(imageData);
    return file;
  }

  // Method to convert a Uint8List to a File
  Future<File> unit8ListToFile() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.png');
    await file.writeAsBytes(_extractedImage!);
    return file;
  }

  // Method to load an image from a File object
  Future<ui.Image> _loadImageFromFile(File file) async {
    final data = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(data), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  // Method to load an image from a network URL
  Future<ui.Image> _loadImageFromNetwork(String imageUrl) async {
    final Completer<ui.Image> completer = Completer();

    NetworkImage(imageUrl).resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          completer.complete(info.image);
        },
      ),
    );

    return completer.future;
  }

  // Method to handle image processing from a network URL
  Future<void> processImageFromNetwork(
      String imageUrl, Size containerSize, Offset offset) async {
    _containerSize = containerSize;
    _offset = offset;
    // await _getFromNetwork(imageUrl);
  }

  // Method to handle image processing from a File object
  Future<File?> processImageFromFile(
      File file, Size containerSize, Offset offset) async {
    _containerSize = containerSize;
    _offset = offset;
    return await getFromFile(file);
  }

  Future<void> extractImage({
    required File? imageFile,
    required String? networkImage,
    required double dragItemSize,
    required Offset initialDragItemPos,
    required ValueChanged<File> onExtractedImage,
  }) async {
    imageFile != null
        ? await processImageFromFile(
            imageFile,
            Size(dragItemSize, dragItemSize),
            initialDragItemPos,
          ).then((value) async {
            if (value != null) onExtractedImage.call(value);
          })
        : networkImage != null
            ? await unit8ListToFile().then((value) async {
                onExtractedImage.call(value);
              })
            : null;
  }
}
