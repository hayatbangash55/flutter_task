import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loader extends StatelessWidget {
  static RxBool loader = false.obs;

  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (loader.value)
        ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Get.theme.primaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : Container());
  }
}
