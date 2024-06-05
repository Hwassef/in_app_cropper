# InAppCropper

**InAppCropper** is a Flutter widget that allows you to crop and extract regions of an image interactively. It supports both local image files and network images, offering a range of customization options for a seamless user experience.

## Features

- Crop local or network images interactively
- Customize drag item size, border decoration, and rotation
- Extract and process cropped images easily
- Adjustable crop parameters and controls

## Installation

Add `in_app_cropper` to your `pubspec.yaml`:
dependencies:
  in_app_cropper: ^1.0.0

Then, run flutter pub get to install the package.
## Parameters

| Parameters        | Description
| ------------- |:-------------:|
| networkImage      | URL of the network image to be displayed
| imageFile      | Local image file to be displayed
| canCropImage | Enables or disables cropping functionality
| dragItemSize | Initial size of the drag item for cropping
| step | Step value for increasing or decreasing the drag item size
| cropBorderDecoration | Decoration for the border around the draggable crop item
| increaseWidget | Widget for increasing the drag item size
| decreaseWidget | Widget for decreasing the drag item size
| imageWidth | Width of the image container
| imageHeight | Height of the image container
| placeHolderImage | Placeholder image while loading or when no image is available
| rotationDuration | Duration for rotation animations in milliseconds
| title | Widget to display as a title above the crop controls
| sliderActiveColor | Color of the active slider track
| sliderInactiveColor | Color of the inactive slider track
| sliderThumbColor | Color of the slider thumb
| canRotate | Enables or disables image rotation
| onExtractedImage | Callback function triggered when an image region is extracted
| imageDecoration | Decoration for the image container
| extractWidget | Widget for the button to extract the image after cropping


```yaml
Contributing
Contributions are welcome! Please open an issue or submit a pull request on GitHub.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Contact
For any questions or suggestions, please reach out at [hassinewassef@gmail.com].

Enjoy using InAppCropper! If you find it useful, please star the repository on GitHub.


