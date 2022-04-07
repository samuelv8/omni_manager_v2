import 'package:flutter/material.dart';
import 'package:omni_manager/constants/style.dart';
import 'package:omni_manager/pages/dashboard/widgets/bar_chart.dart';
import 'package:omni_manager/pages/dashboard/widgets/custom_text_content.dart';
import 'package:omni_manager/pages/dashboard/widgets/pie_chart.dart';

class ChartSectionLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Column(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextContent(
                  text: "Autoavaliação",
                  size: 20,
                  weight: FontWeight.bold,
                  color: dark,
                ),
                Container(
                    width: 600,
                    height: 400,
                    child: SimpleBarChart.withSampleData()),
              ],
            ),
          ),
          Container(width: 600, height: 60, color: Colors.white),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextContent(
                  text: "Desafios semanais",
                  size: 20,
                  weight: FontWeight.bold,
                  color: dark,
                ),
                Container(
                    width: 600,
                    height: 400,
                    child: PieOutsideLabelChart.withSampleData()),
              ],
            ),
          ),
          //In case we want to display the information of the charts in text, "bar_char_info.dart"
          //has the template for the text boxes and we just need to uncomment the section below.
          /*Container(
            width: 1,
            height: 120,
            color: lightGrey,
          ),

          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    RevenueInfo(
                      title: "Toda\'s revenue",
                      amount: "230",
                    ),
                    RevenueInfo(
                      title: "Last 7 days",
                      amount: "1,100",
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "Last 30 days",
                      amount: "3,230",
                    ),
                    RevenueInfo(
                      title: "Last 12 months",
                      amount: "11,300",
                    ),
                  ],
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
