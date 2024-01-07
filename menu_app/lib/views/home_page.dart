// Loads the Summary Page to display College tiles and Summary below.

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/custom_widgets/ad_bar.dart';
import 'package:menu_app/custom_widgets/summary.dart';
import 'package:menu_app/custom_widgets/update_dialog.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_app/custom_widgets/banner.dart';
import 'package:menu_app/models/menus.dart';
import 'package:menu_app/utilities/constants.dart' as constants;
import 'package:menu_app/views/nav_drawer.dart';
import 'package:menu_app/controllers/home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomePageController(),
        builder: (context, child) {
          return Consumer<HomePageController>(
              builder: (context, controller, child) {
            // Needs to be built before showing the update dialog
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!controller.versionCheckResult) {
                showUpdateDialog(context);
              }
            });
            double iconSizeCollege = MediaQuery.of(context).size.width / 2.7;
            final time = DateTime.now();
            return Scaffold(
              // Display app bar header.
              drawer: const NavDrawer(),
              appBar: AppBar(
                toolbarHeight: 65,
                centerTitle: true,
                backgroundColor: const Color(constants.darkBlue),
                surfaceTintColor: const Color.fromARGB(255, 60, 60, 60),
                title: const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "UC Santa Cruz",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                      fontFamily: 'Monoton',
                      color: Color(constants.yellowGold),
                    ),
                  ),
                ),
                shape: const Border(
                    bottom: BorderSide(color: Colors.orange, width: 4)),
              ),
              body: RefreshIndicator(
                onRefresh: controller.refresh,
                // indicatorBuilder: (context, controller) {
                // return const Icon(
                //   Icons.fastfood_outlined,
                //   color: Colors.blueGrey,
                //   size: 30,
                // );
                // return Image.asset(
                //   'images/slug.png',
                //   scale: 0.5,
                // );
                // },
                child: ListView(
                  children: <Widget>[
                    buildBanner(),
                    // Display header text.
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 12),
                      child: const Text(
                        "Dining Halls",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Montserat',
                            fontWeight: FontWeight.w800,
                            color: Color(constants.yellowOrange)),
                      ),
                    ),
                    // Display all hall icons.
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.width / 2.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Loop through every college in [colleges].
                          for (var i = 0; i < controller.colleges.length; i++)
                            // Special formatting for first Icon.
                            if (i == 0)
                              Container(
                                padding: const EdgeInsets.only(left: 7),
                                // Icon button leads to specified [colleges] page.
                                child: IconButton(
                                  onPressed: () {
                                    context.push(
                                        '/${controller.colleges[i].trim()}');
                                  },
                                  icon: Image.asset(
                                      'images/${controller.colleges[i].trim()}.png'),
                                  iconSize: iconSizeCollege,
                                ),
                              )
                            // Special formatting for last Icon.
                            else if (i == controller.colleges.length - 1)
                              Container(
                                padding: const EdgeInsets.only(right: 7),
                                child: IconButton(
                                  onPressed: () {
                                    context.push(
                                        '/${controller.colleges[i].trim()}');
                                  },
                                  icon: Image.asset(
                                      'images/${controller.colleges[i].trim()}.png'),
                                  iconSize: iconSizeCollege,
                                ),
                              )
                            // Icon formatting.
                            else
                              IconButton(
                                onPressed: () {
                                  context.push(
                                      '/${controller.colleges[i].trim()}');
                                },
                                icon: Image.asset(
                                    'images/${controller.colleges[i].trim()}.png'),
                                iconSize: iconSizeCollege,
                              ),
                        ],
                      ),
                    ),

                    // Displays summary for every college in [colleges].
                    Container(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          for (var i = 0; i < controller.colleges.length; i++)
                            buildSummary(
                                controller.colleges[i].trim(),
                                fetchSummary(
                                    controller.colleges[i].trim(), controller.mealTime)),
                          // Provide when the menu was last updated.
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "Last updated: ${time.toString().substring(5, 19)}\nData provided by nutrition.sa.ucsc.edu",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Comment this out to get rid of ad for screenshots!
              // AD bar.
              bottomNavigationBar: const AdBar(),
            );
          });
        });
  }
}
