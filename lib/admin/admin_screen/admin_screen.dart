import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/admin_drawer_widget/admin_drawer_widget.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  GetAllUsers getAllUsers = GetAllUsers();
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  @override
  void initState() {
    super.initState();
    getUserData()
        .then((value) => {getAllUsers.getUserData(value.token.toString())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        drawer: const AdminDrawerWidget(),
        body: ChangeNotifierProvider(
          create: (context) => getAllUsers,
          child: Consumer<GetAllUsers>(builder: (context, value, _) {
            switch (value.apiresponse.status) {
              case Status.loading:
                return Center(
                  child: Utils.showLoadingSpinner(),
                );
              case Status.error:
                if (value.apiresponse.message!
                    .contains("UnAuthorized Request")) {
                  return const Center(
                      child: Text(
                    "Token Expired! Please Login Again",
                    textAlign: TextAlign.center,
                  ));
                } else if (value.apiresponse.message!
                    .contains("TimeoutException")) {
                  return const Center(
                      child: Text("Time Out! Please Login Again"));
                }
                return Center(
                  child: Text(
                    value.apiresponse.message.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              case Status.completed:
                return ListView.builder(
                    shrinkWrap: true,
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
                                    Text("0",
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
        ));
  }
}
