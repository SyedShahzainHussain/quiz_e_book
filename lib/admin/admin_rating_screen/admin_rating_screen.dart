import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/viewmodel/admin_user_rating_view_model.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/admin/viewmodel/delete_rating_view_model.dart';

class AdminRatingScreen extends StatefulWidget {
  const AdminRatingScreen({super.key});

  @override
  State<AdminRatingScreen> createState() => _AdminRatingScreenState();
}

class _AdminRatingScreenState extends State<AdminRatingScreen> {
  AdminUserRatingViewModel adminUserRatingViewModel =
      AdminUserRatingViewModel();
  @override
  void initState() {
    super.initState();
    adminUserRatingViewModel.getAdminUserRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Rating")),
      body: RefreshIndicator(
        onRefresh: () async {
          await adminUserRatingViewModel.getAdminUserRating();
        },
        child: SafeArea(
          child: ChangeNotifierProvider(
              create: (context) => adminUserRatingViewModel,
              child: Consumer<AdminUserRatingViewModel>(
                builder: (context, value, _) {
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
                                AuthViewModel().remove().then((value) =>
                                    context.go(RouteName.loginScreen));
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
                                AuthViewModel().remove().then((value) =>
                                    context.go(RouteName.loginScreen));
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
                      if (value.apiresponse.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No user ratings available!',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: AppColors.black,
                                ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(value.apiresponse.data![index].sId),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                            "Are you sure you want to delete ?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Cancel",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: AppColors.black,
                                                    )),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          FilledButton.tonal(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                              context
                                                  .read<DeleteRatingViewModel>()
                                                  .deleteRating(
                                                      value.apiresponse
                                                          .data![index].sId!,
                                                      context);
                                            },
                                            child: Text("Delete",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: AppColors.red,
                                                    )),
                                          ),
                                        ],
                                      );
                                    });

                                return res;
                              } else {
                                return null;
                              }
                            },
                            background: Container(
                              color: Colors.white,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      " Delete",
                                      style: TextStyle(
                                        color: Colors.red,
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
                            ),
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
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: value
                                      .apiresponse.data![index].userId!.length,
                                  itemBuilder: (context, index2) => ListTile(
                                    leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColors.bgColor,
                                        backgroundImage: NetworkImage(value
                                            .apiresponse
                                            .data![index]
                                            .userId![index2]
                                            .profilePhoto!)),
                                    title: Text(
                                        value.apiresponse.data![index]
                                            .userId![index2].username!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                    subtitle: Text(
                                        ' ${value.apiresponse.data![index].message!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color: AppColors.white,
                                            )),
                                    trailing: SizedBox(
                                      width: 50,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${value.apiresponse.data![index].rating!}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: AppColors.white,
                                                    )),
                                            const Gap(2),
                                            const Icon(
                                              Icons.star,
                                              color: AppColors.yellow,
                                              size: 8,
                                            )
                                          ]),
                                    ),
                                  ),
                                )),
                          );
                        },
                        itemCount: value.apiresponse.data!.length,
                      );

                    default:
                      return const SizedBox.shrink();
                  }
                },
              )),
        ),
      ),
    );
  }
}
