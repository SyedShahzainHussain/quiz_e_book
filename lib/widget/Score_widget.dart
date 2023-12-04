import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';

class ScoreWidget extends StatefulWidget {
  final ScrollController scrollController;

  const ScoreWidget({
    super.key,
    required this.scrollController,
  });

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  GetAllUsers getAllUsers = GetAllUsers();
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  Future<void> fetchData() async {
    try {
      LoginData userData = await getUserData();
      await getAllUsers.getUserData(userData.token.toString());
    } catch (error) {
      // Handle errors if needed
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // void animatedTo(double max, double min, double direction, int seconds) {
  //   if (widget.scrollController.hasClients) {
  //     widget.scrollController
  //         .animateTo(
  //       direction,
  //       duration: Duration(seconds: seconds),
  //       curve: Curves.linear,
  //     )
  //         .then((value) {
  //       direction = direction == max ? min : max;
  //       animatedTo(max, min, direction, 20);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    context.watch<QuizViewModel>();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
            width: 4,
          ),
        ),
        child: ChangeNotifierProvider<GetAllUsers>(
          create: (context) => getAllUsers,
          child: Consumer<GetAllUsers>(builder: (context, value, _) {
            
            switch (value.apiresponse.status) {
              case Status.loading:
                return Center(child: Utils.showLoadingSpinner());
              case Status.error:
                if (value.apiresponse.message!
                    .contains("UnAuthorized Request")) {
                  return Center(
                      child: AlertDialog(
                    title: const Text("Token Expire"),
                    content: const Text("You have to login again!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AuthViewModel().remove().then(
                              (value) => context.go(RouteName.loginScreen));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ));
                } else if (value.apiresponse.message!
                    .contains("TimeoutException")) {
                  return Center(
                      child: AlertDialog(
                    title: const Text("Token Expire"),
                    content: const Text("You have to login again!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AuthViewModel().remove().then(
                              (value) => context.go(RouteName.loginScreen));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ));
                }
                return Text(value.apiresponse.message.toString());
              case Status.completed:
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: value.apiresponse.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.all(12.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: AppColors.bgColor,
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
                                    backgroundImage: NetworkImage(value
                                        .apiresponse
                                        .data![index]
                                        .profilePhoto!)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        value.apiresponse.data![index].scorrer!
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            )),
                                    Image.asset(
                                      "assets/images/coin.gif",
                                      width: context.screenwidth * .05,
                                    )
                                  ],
                                ),
                                title: Text(
                                    value.apiresponse.data![index].username!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        )),
                              )),
                        ],
                      );
                    });
              default:
                return const SizedBox();
            }
          }),
        ),
      ),
    );
  }
}
