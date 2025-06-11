import 'package:get/get.dart';

//Define dimensions which can be used to make ouur app work from any size of device.
class Dimensions {
  //flutter ( 5585): height:781.0909090909091
//flutter ( 5585): width392.72727272727275

  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  static double pageView = screenHeight / 2.28;

  static double pageViewContainer = screenHeight / 3.32;
  static double pageViewText = screenHeight / 6.09;

  //dynamic Height Padding & Margin
  static double height10 = screenHeight / 78.10;
  static double height15 = screenHeight / 52.07;
  static double height20 = screenHeight / 39.05;
  static double height30 = screenHeight / 26.03;
  static double height45 = screenHeight / 17.35;
  static double height50 = screenHeight / 15.62;
  static double height75 = screenHeight / 10.41;
  static double height100 = screenHeight / 7.81;
  static double height200 = screenHeight / 3.90;

  //dynamic Width Padding & Margin
  static double width10 = screenHeight / 39.27;
  static double width15 = screenHeight / 26.18;
  static double width20 = screenHeight / 19.63;
  static double width30 = screenHeight / 13.09;
  static double width45 = screenHeight / 8.72;
  static double width50 = screenHeight / 7.85;
  static double width75 = screenHeight / 5.23;
  static double width100 = screenHeight / 3.92;

  //font size
  static double font16 = screenHeight / 48.87;
  static double font20 = screenHeight / 39.1;
  static double font26 = screenHeight / 30.07;

  //radius
  static double radius10 = screenHeight / 78.10;
  static double radius15 = screenHeight / 52.13;
  static double radius20 = screenHeight / 39.01;
  static double radius30 = screenHeight / 26.03;

  //Icon Size
  static double iconSize24 = screenHeight / 30.47;
  static double iconSize16 = screenHeight / 45.71;

  //List View Size
  static double listViewImgSize = screenWidth / 3.42;
  static double listViewTextContainerSize = screenWidth / 4.11;

  //Popular food
  static double popularFoodImgSize = screenHeight / 2.08;

  //bottom height
  static double bottomHeightBar = screenHeight / 10.10;

  //Splash Screen Dimensions
  static double splashimg = screenHeight / 2.92;
}
