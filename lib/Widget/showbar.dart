import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../screens/view_screen.dart';

class ShowBar extends StatelessWidget {
  const ShowBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            height: 0.8.h,
            width: 16.h,
            decoration: ShapeDecoration(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Bike'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src: 'assets/3DModel/cyberpunk_bike.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('Brain Project'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src: 'assets/3DModel/brain_project.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('Astronaut'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src:
                              'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('Car'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src: 'assets/3DModel/cyberpunk_car.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('Human Heart'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src: 'assets/3DModel/realistic_human_heart.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('3 Seater Sofa'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src:
                              'assets/3DModel/refined_venetian_3-seater_sofa.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('Ship in Cloud'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src: 'assets/3DModel/ship_in_clouds.glb',
                        )),
                  ),
                  ListTile(
                    title: const Text('Table Lamp'),
                    subtitle: const Text('Card Subtitle'),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: () => Get.to(() => const ViewScreen(
                          src: 'assets/3DModel/table_lamp__free.glb',
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
