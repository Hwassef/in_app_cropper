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

|Parameter           |Description                                                    | Type                | Required / Optional |
|----------------------|----------------------------------------------------------------|---------------------|---------------------|
| canCropImage         | Enables or disables cropping functionality                     | bool                | Required            |
| dragItemSize         | Initial size of the drag item for cropping                     | double              | Required            |
| step                 | Step value for increasing or decreasing the drag item size     | int                 | Required            |
| imageWidth           | Width of the image container                                   | double              | Required            |
| imageHeight          | Height of the image container                                  | double              | Required            |
| canRotate            | Enables or disables image rotation                             | bool                | Required            |
| onExtractedImage     | Callback function triggered when an image region is extracted  | ValueChanged<File>  | Required            |
| networkImage         | URL of the network image to be displayed                       | String?             | Optional            |
| imageFile            | Local image file to be displayed                               | File?               | Optional            |
| cropBorderDecoration | Decoration for the border around the draggable crop item       | BoxBorder?          | Optional            |
| increaseWidget       | Widget for increasing the drag item size                       | Widget?             | Optional            |
| decreaseWidget       | Widget for decreasing the drag item size                       | Widget?             | Optional            |
| placeHolderImage     | Placeholder image while loading or when no image is available  | Image?              | Optional            |
| rotationDuration     | Duration for rotation animations in milliseconds               | int?                | Optional            |
| title                | Widget to display as a title above the crop controls           | Widget?             | Optional            |
| sliderActiveColor    | Color of the active slider track                               | Color?              | Optional            |
| sliderInactiveColor  | Color of the inactive slider track                             | Color?              | Optional            |
| sliderThumbColor     | Color of the slider thumb                                      | Color?              | Optional            |
| imageDecoration      | Decoration for the image container                             | BoxDecoration?      | Optional            |
| extractWidget        | Widget for the button to extract the image after cropping      | Widget?             | Optional            |

##  Examples

[InAppCropper](https://github.com/Hwassef/in_app_cropper/tree/main/example) - an example of how to create a InAppCropper in a pure Dart app.

###   Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Contact
For any questions or suggestions, please reach out at [hassinewassef@gmail.com].

Enjoy using InAppCropper! If you find it useful, please star the repository on GitHub.
