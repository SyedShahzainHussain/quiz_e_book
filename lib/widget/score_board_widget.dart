import 'package:flutter/material.dart';

import 'package:quiz_e_book/resources/color/app_color.dart';

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({
    super.key,
  });

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent1 = scrollController.position.minScrollExtent;
      double maxScrollExtent1 = scrollController.position.maxScrollExtent;
      animatedTo(maxScrollExtent1, minScrollExtent1, maxScrollExtent1, 25,
          scrollController);
    });
  }

  animatedTo(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      direction = direction == max ? min : max;
      animatedTo(max, min, direction, seconds, scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text[index],
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.white),
              ),
              Text(
                "50",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.white),
              )
            ],
          );
        },
        itemCount: text.length,
      ),
    );
  }
}

List<String> text = [
"hello",
"hello1",
"hello2",
"hello3",
"hello4",
"hello5",
"hello6",
"hello7",
"hello8",
"hello9",
"hello10",
"hello11",
"hello12",
"hello13",
"hello14",
"hello15",
];
