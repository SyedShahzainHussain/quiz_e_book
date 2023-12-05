import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/admin_drawer_widget/admin_drawer_widget.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/delete_user_view_model/delete_user_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        drawer: const AdminDrawerWidget(),
        body: Consumer<DeleteUserViewModel>(
          builder: (context, value, _) => ModalProgressHUD(
            inAsyncCall: value.loading,
            progressIndicator: Utils.showLoadingSpinner(),
            child: ChangeNotifierProvider(
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
                              Dismissible(
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    final bool res = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Are you sure you want to delete ${value.apiresponse.data![index].username}?"),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  getUserData().then((admin) {
                                                    print(admin.token);
                                                    print(value.apiresponse
                                                        .data![index].sId);
                                                    context
                                                        .read<
                                                            DeleteUserViewModel>()
                                                        .deleteUser(
                                                            value
                                                                .apiresponse
                                                                .data![index]
                                                                .sId!,
                                                            token: admin.token);

                                                    context.go(
                                                        RouteName.homeScreen);
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    return res;
                                  } else {
                                    return null;
                                  }
                                },
                                key:
                                    ValueKey(value.apiresponse.data![index].id),
                                child: Container(
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
                                      title: Text(
                                          value.apiresponse.data![index]
                                              .username!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              )),
                                    )),
                              ),
                            ],
                          );
                        });
                  default:
                    return const SizedBox();
                }
              }),
            ),
          ),
        ));
  }
}
