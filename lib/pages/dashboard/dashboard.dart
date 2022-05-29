import 'package:flutter/material.dart';
import 'package:omni_manager/pages/dashboard/widgets/bar_chart_section.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_title.dart';
import 'package:omni_manager/pages/dashboard/widgets/overview_cards_large.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30.0),
            child: CustomTextTitle(
              text: "Dashboard",
              size: 40,
              weight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: OverviewCardsLargeScreen()),
                SizedBox(width: 40),
                Center(
                    child: Column(
                  children: [
                    CustomTextTitle(
                      text: "Evaluation by Manager",
                      size: 24,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    BarChartDash(isManager: true),
                  ],
                )),
                SizedBox(width: 40),
                Center(
                    child: Column(
                  children: [
                    CustomTextTitle(
                      text: "Employee's Self-evaluation",
                      size: 24,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    BarChartDash(isManager: false),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
