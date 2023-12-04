import 'package:flutter/material.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';

class PositionHolderWidget extends StatelessWidget {
  final double height;
  final double width;
  final String position;
  final String winnername;
  final int totalScore;
  final Color positionColor;
  final String winnerprofile;

  const PositionHolderWidget({
    super.key,
    required this.height,
    required this.width,
    required this.position,
    required this.winnername,
    required this.totalScore,
    required this.positionColor,
    required this.winnerprofile,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            AppColors.darkorane,
                            AppColors.darkbrown,
                            AppColors.darkyellow,
                          ])),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: context.screenheight * .15,
                      width: context.screenwidth * .3,
                      decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0))),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              winnername,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              totalScore.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: positionColor),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  child: ClipOval(
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                            AppColors.deeporange,
                            AppColors.yellow,
                          ])),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            width:
                                50.0, // this width forces the container to be a circle
                            height: 50.0,
                            child: CircleAvatar(
                              backgroundColor: AppColors.bgColor3,
                              backgroundImage: NetworkImage(winnerprofile),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 15,
                    child: ClipOval(
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: positionColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                             position,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold))),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
