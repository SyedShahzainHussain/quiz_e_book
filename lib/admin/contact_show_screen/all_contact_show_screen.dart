import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/viewmodel/contact_view_model.dart';
import 'package:quiz_e_book/admin/viewmodel/delete_contact_view_model.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:readmore/readmore.dart';

class AllContactShow extends StatefulWidget {
  const AllContactShow({super.key});

  @override
  State<AllContactShow> createState() => _AllContactShowState();
}

class _AllContactShowState extends State<AllContactShow> {
  GetContactViewModel getContactViewModel = GetContactViewModel();

  @override
  void initState() {
    super.initState();
    getContactViewModel.getContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Contact"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getContactViewModel.getContact();
        },
        child: ChangeNotifierProvider(
          create: (context) => getContactViewModel,
          child: Consumer<GetContactViewModel>(builder: (context, value, _) {
            switch (value.apiResponse.status) {
              case Status.loading:
                return Center(
                  child: Utils.showLoadingSpinner(),
                );
              case Status.error:
                if (value.apiResponse.message!
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
                } else if (value.apiResponse.message!
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
                    value.apiResponse.message.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              case Status.completed:
                if (value.apiResponse.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No user contacts available!',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.black,
                          ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  key: ValueKey(value.apiResponse.message),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(value.apiResponse.data![index].sId),
                      direction: DismissDirection.endToStart,
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
                                            .read<DeleteContactViewModel>()
                                            .deletedContact(
                                                value.apiResponse.data![index]
                                                    .sId!,
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
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                value.apiResponse.data![index].email!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        color: AppColors.white),
                              ),
                              subtitle: Text(
                                  value.apiResponse.data![index].name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: AppColors.white)),
                            ),
                            const Divider(
                              color: AppColors.white,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ReadMoreText(
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '  Show more',
                                trimExpandedText: '   Show less  ',
                                moreStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: AppColors.black),
                                lessStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: AppColors.black),
                                trimLines: 1,
                                "Message: ${value.apiResponse.data![index].message!}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: value.apiResponse.data!.length,
                );
              default:
                return const SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }
}
