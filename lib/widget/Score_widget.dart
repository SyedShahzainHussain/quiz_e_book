import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';

class ScoreWidget extends StatefulWidget {
  const ScoreWidget({
    super.key,
  });

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent1 = scrollController.position.minScrollExtent;
      double maxScrollExtent1 = scrollController.position.maxScrollExtent;
      animatedTo(maxScrollExtent1, minScrollExtent1, maxScrollExtent1, 25);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void animatedTo(double max, double min, double direction, int seconds) {
    if (scrollController.hasClients) {
      scrollController
          .animateTo(
        direction,
        duration: Duration(seconds: seconds),
        curve: Curves.linear,
      )
          .then((value) {
        direction = direction == max ? min : max;
        animatedTo(max, min, direction, 25);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: const GradientBoxBorder(
              gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
              width: 4,
            ),
          ),
          child: ListView.builder(
              controller: scrollController,
              itemCount: winner.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.bgColor4,
                      borderRadius: BorderRadius.circular(12.0),
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(colors: [
                          AppColors.deeporange,
                          AppColors.yellow,
                        ]),
                        width: 4,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.bgColor,
                          backgroundImage:
                              NetworkImage(winner[index]['image'])),
                      trailing: Text(winner[index]['totalScore'],
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                      title: Text(winner[index]['username'],
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                    ));
              })),
    );
  }
}

final List<Map<String, dynamic>> winner = [
  {
    "image":
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1kH8p9wS5Yj2NL2cwUTEzEiRau45Wb8S_Hg&usqp=CAU',
    "username": 'Romaisa',
    "totalScore": '500',
  },
  {
    "image":
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeHt2GDofV5sNOaTrLarqU3XmMpTNXxaw9dg&usqp=CAU',
    "username": 'Ali',
    "totalScore": '400',
  },
  {
    "image":
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEggpHVqWDedhGqOyqh60ah1VdTpdtVAzlRw&usqp=CAU',
    "username": 'Rafay',
    "totalScore": '300',
  }
];
