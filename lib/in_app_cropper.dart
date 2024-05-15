// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:in_app_cropper/image_processing.dart';

/// A widget that allows cropping and extracting regions of an image interactively.
///
/// Use `InAppCropper` to display an image with interactive cropping functionality.
/// It supports both local image files and network images.
///
/// The cropping behavior can be customized by specifying various parameters such as
/// drag item size, border decoration, rotation, and more.
///
/// **Basic Usage:**
///
/// ```dart
/// InAppCropper(
///   imageFile: File('path_to_image.jpg'),
///   imageWidth: 300,
///   imageHeight: 400,
///   onExtractedImage: (croppedImageFile) {
///     // Handle the extracted image file
///   },
///   canCropImage: true,
/// );
/// ```
///
/// The `onExtractedImage` callback is triggered when the user extracts a cropped
/// region of the image. You can use this callback to save or process the cropped image.
class InAppCropper extends StatefulWidget {
  /// The network image URL to be displayed in the cropper.
  final String? networkImage;

  /// How the image should be inscribed into the space allocated for it.
  final BoxFit? fit;

  /// The local image file to be displayed in the cropper.
  final File? imageFile;

  /// Determines if the image can be cropped within the cropper.
  final bool canCropImage;

  /// The step value used for increasing or decreasing the drag item size.
  final double step;

  /// Decoration for the border around the draggable crop item.
  final BoxBorder? cropBorderDecoration;

  /// Widget to display for increasing the drag item size.
  final Widget? increaseWidget;

  /// Widget to display for decreasing the drag item size.
  final Widget? decreaseWidget;

  /// The width of the image container.
  final double imageWidth;

  /// The height of the image container.
  final double imageHeight;

  /// The initial size of the drag item for cropping.
  double dragItemSize;

  /// Placeholder image to display while loading or when no image is available.
  final Image? placeHolderImage;

  /// The duration for rotation animations in milliseconds.
  final int? rotationDuration;

  /// Widget to display as a title above the crop controls.
  final Widget? title;

  /// The color of the active slider track.
  final Color? sliderActiveColor;

  /// The color of the inactive slider track.
  final Color? sliderInactiveColor;

  /// The color of the slider thumb.
  final Color? sliderThumbColor;

  /// Determines if the image can be rotated within the cropper.
  final bool canRotate;

  /// Callback function triggered when an image region is extracted.
  final ValueChanged<File> onExtractedImage;

  /// Decoration for the image container.
  final BoxDecoration? imageDecoration;

  ///Widget to display the button to extract the image after cropping
  final Widget? extractWidget;

  /// Constructs an [InAppCropper] widget.
  ///
  /// The [onExtractedImage] callback must not be null.
  /// The [imageHeight] and [imageWidth] must be specified and greater than 0.
  InAppCropper({
    Key? key,
    required this.onExtractedImage,
    required this.imageHeight,
    required this.imageWidth,
    this.dragItemSize = 50.0,
    this.networkImage,
    this.fit,
    this.imageFile,
    this.canCropImage = false,
    this.cropBorderDecoration,
    this.increaseWidget,
    this.decreaseWidget,
    this.placeHolderImage,
    this.rotationDuration,
    this.title,
    this.imageDecoration,
    this.step = 10,
    this.sliderActiveColor,
    this.sliderInactiveColor,
    this.sliderThumbColor,
    this.canRotate = true,
    this.extractWidget,
  }) : super(key: key);

  @override
  State<InAppCropper> createState() => _InAppCropperState();
}

class _InAppCropperState extends State<InAppCropper>
    with TickerProviderStateMixin {
  late Offset _initialDragItemPos;
  double? dragItemWidth;
  double? dragItemHeight;
  double? aspectRatio;
  int rotateTime = 0;
  late AnimationController animationController1;
  late AnimationController animationController2;
  late AnimationController animationController3;
  late AnimationController animationController4;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;
  int defaultRotationDurationInMilliseconds = 250;
  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            widget.rotationDuration ?? defaultRotationDurationInMilliseconds,
      ),
    );
    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            widget.rotationDuration ?? defaultRotationDurationInMilliseconds,
      ),
    );
    animationController3 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            widget.rotationDuration ?? defaultRotationDurationInMilliseconds,
      ),
    );
    animationController4 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            widget.rotationDuration ?? defaultRotationDurationInMilliseconds,
      ),
    );
    animation1 = Tween<double>(begin: 0, end: pi / 2).animate(
      animationController1,
    );

    animation2 = Tween<double>(begin: pi / 2, end: pi).animate(
      animationController2,
    );

    animation3 = Tween<double>(
      begin: pi,
      end: pi + pi / 2,
    ).animate(animationController3);

    animation4 = Tween<double>(
      begin: pi + pi / 2,
      end: pi + pi,
    ).animate(animationController4);
    _currentDragItemSize = widget.dragItemSize;

    super.initState();
    _calculateInitialDragItemPos();
    _calculateDragItemSize();
  }

  late double _currentDragItemSize;

  void _calculateInitialDragItemPos() {
    double initialX = (widget.imageWidth - widget.dragItemSize) / 2;
    double initialY = (widget.imageHeight - widget.dragItemSize) / 2;
    _initialDragItemPos = Offset(initialX, initialY);
  }

  void _calculateDragItemSize() {
    aspectRatio = widget.imageWidth / widget.imageHeight;
    if (widget.imageWidth > widget.imageHeight) {
      // Landscape orientation
      dragItemWidth = widget.dragItemSize;
      dragItemHeight = dragItemWidth! / aspectRatio!;
    } else {
      // Portrait orientation
      dragItemHeight = widget.dragItemSize;
      dragItemWidth = dragItemHeight! * aspectRatio!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _buildAnimation(),
            builder: (context, child) {
              return Transform.rotate(
                angle: _buildAnimation().value,
                child: Container(
                  height: widget.imageHeight,
                  width: widget.imageWidth,
                  decoration: widget.imageDecoration ??
                      BoxDecoration(
                        border: Border.all(
                          width: 0,
                          color: Colors.black,
                        ),
                        image: DecorationImage(
                          opacity: 0.5,
                          image: _getImageProvider(),
                          fit: widget.fit ?? BoxFit.cover,
                        ),
                      ),
                  child: Stack(
                    children: [
                      if (widget.canCropImage)
                        Positioned(
                          left: _initialDragItemPos.dx,
                          top: _initialDragItemPos.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                _initialDragItemPos += details.delta;
                                _initialDragItemPos = Offset(
                                  _initialDragItemPos.dx.clamp(
                                    0,
                                    widget.imageWidth - dragItemWidth!,
                                  ),
                                  _initialDragItemPos.dy.clamp(
                                    0,
                                    widget.imageHeight - dragItemHeight!,
                                  ),
                                );
                              });
                            },
                            child: Container(
                              width: dragItemWidth,
                              height: dragItemHeight,
                              decoration: BoxDecoration(
                                backgroundBlendMode: BlendMode.overlay,
                                color: Colors.black,
                                shape: BoxShape.rectangle,
                                border: widget.cropBorderDecoration ??
                                    Border.all(
                                      width: 2,
                                      color: Colors.red,
                                    ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.canCropImage)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.title ?? const SizedBox.shrink(),
              GestureDetector(
                onTap: _decreaseDragItemSize,
                child: widget.decreaseWidget ??
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: const Text(
                        '--',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: -1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
              ),
              Expanded(
                child: Slider(
                  activeColor: widget.sliderActiveColor,
                  thumbColor: widget.sliderThumbColor,
                  inactiveColor: widget.sliderInactiveColor,
                  value: _currentDragItemSize,
                  min: 50.0,
                  max: getImageMaxSize(),
                  onChanged: (newValue) {
                    setState(() {
                      _currentDragItemSize = newValue;
                      _updateDragItemSize();
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: _increaseDragItemSize,
                child: widget.increaseWidget ??
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: const Text(
                        '+',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
              ),
              const SizedBox(width: 22),
              if (widget.canRotate)
                GestureDetector(
                  onTap: _rotateChildContinuously,
                  child: const Icon(
                    Icons.refresh,
                    size: 24,
                  ),
                ),
            ],
          ),
        GestureDetector(
          onTap: () async => await ImageProcessing().extractImage(
            dragItemSize: widget.dragItemSize,
            imageFile: widget.imageFile,
            initialDragItemPos: _initialDragItemPos,
            networkImage: widget.networkImage,
            onExtractedImage: widget.onExtractedImage,
          ),
          child: widget.extractWidget ?? const Text("Extract"),
        ),
      ],
    );
  }

  void _updateDragItemSize() {
    setState(() {
      // Update the drag item size based on the current value of _currentDragItemSize
      widget.dragItemSize = _currentDragItemSize;
      _calculateDragItemSize();
      _updateInitialDragItemPos();
    });
  }

  void _updateInitialDragItemPos() {
    double centerX = (widget.imageWidth - dragItemWidth!) / 2;
    double centerY = (widget.imageHeight - dragItemHeight!) / 2;
    _initialDragItemPos = Offset(centerX, centerY);
  }

  void _decreaseDragItemSize() {
    double newDragItemSize = widget.dragItemSize - widget.step;
    double minDragItemSize = 50.0; // Define your minimum allowable size
    if (newDragItemSize >= minDragItemSize) {
      setState(() {
        widget.dragItemSize = newDragItemSize;
        _currentDragItemSize = newDragItemSize; // Update _currentDragItemSize
        _calculateDragItemSize();
        _updateInitialDragItemPos();
      });
    } else {
      setState(() {
        widget.dragItemSize = minDragItemSize; // Clamp to the minimum size
        _currentDragItemSize = minDragItemSize; // Update _currentDragItemSize
        _calculateDragItemSize();
        _updateInitialDragItemPos();
      });
    }
  }

  void _increaseDragItemSize() {
    double newDragItemSize = widget.dragItemSize + widget.step;
    double maxDragItemSize =
        getImageMaxSize(); // Calculate the maximum allowable size
    if (newDragItemSize <= maxDragItemSize) {
      setState(() {
        widget.dragItemSize = newDragItemSize;
        _currentDragItemSize = newDragItemSize; // Update _currentDragItemSize
        _calculateDragItemSize();
        _updateInitialDragItemPos();
      });
    } else {
      setState(() {
        widget.dragItemSize = maxDragItemSize; // Clamp to the maximum size
        _currentDragItemSize = maxDragItemSize; // Update _currentDragItemSize
        _calculateDragItemSize();
        _updateInitialDragItemPos();
      });
    }
  }

  double getImageMaxSize() {
    double maxWidthToFit = widget.imageWidth;
    double maxHeightToFit = widget.imageHeight;
    return aspectRatio! <= 1.0 ? maxHeightToFit : maxWidthToFit;
  }

  void _rotateChildContinuously() {
    setState(() {
      rotateTime++;
      if (rotateTime > 4) {
        /// Reset rotateTime to 1 if it exceeds 4
        rotateTime = 1;
      }
      if (rotateTime == 1) {
        animationController1.forward(from: 0);
      } else if (rotateTime == 2) {
        animationController2.forward(from: 0);
      } else if (rotateTime == 3) {
        animationController3.forward(from: 0);
      } else if (rotateTime == 4) {
        animationController4.forward(from: 0);
      }
    });
  }

  ImageProvider _getImageProvider() {
    if (widget.imageFile != null) {
      return Image.file(
        widget.imageFile!,
        fit: widget.fit ?? BoxFit.cover,
      ).image;
    } else if (widget.networkImage != null && widget.networkImage!.isNotEmpty) {
      return Image.network(
        widget.networkImage!,
        color: Colors.black,
        fit: widget.fit ?? BoxFit.cover,
        colorBlendMode: BlendMode.saturation,
      ).image;
    } else if (widget.placeHolderImage != null) {
      return widget.placeHolderImage!.image;
    } else {
      // Fallback to default placeholder image
      return Image.asset(
        "user_default_image.png",
        package: "in_app_cropper",
      ).image;
    }
  }

  Animation<double> _buildAnimation() {
    switch (rotateTime) {
      case 1:
        return animation1;
      case 2:
        return animation2;
      case 3:
        return animation3;
      case 4:
        return animation4;
      default:
        return animation1;
    }
  }
}
