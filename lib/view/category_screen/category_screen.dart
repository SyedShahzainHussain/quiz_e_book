import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/viewmodel/get_category_view_model.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class CategoriseScreen extends StatefulWidget {
  const CategoriseScreen({super.key});

  @override
  State<CategoriseScreen> createState() => _CategoriseScreenState();
}

class _CategoriseScreenState extends State<CategoriseScreen> {
  GetCategoryViewModel getCategoryViewModel = GetCategoryViewModel();

  @override
  void initState() {
    super.initState();
    getCategoryViewModel.getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffeeeeee),
        appBar: AppBar(
          title: Text(
            "Select Category",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        body: ChangeNotifierProvider<GetCategoryViewModel>(
          create: (context) => getCategoryViewModel,
          builder: (context, _) =>
              Consumer<GetCategoryViewModel>(builder: (context, value, _) {
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
                return value.apiResponse.data!.isEmpty
                    ? Center(
                        child: Text(
                        "No Data Available!",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: const Color(0xff030605),
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              bottom: 6.0,
                              top: 5.0,
                            ),
                            child: Card(
                              elevation: 4,
                              child: GestureDetector(
                                onTap: () {
                                  context.push(RouteName.selectedCategory,
                                      extra: value
                                          .apiResponse.data![index].title
                                          .toString());
                                },
                                child: ClipRRect(
                                  // Set your desired border radius
                                  child: Container(
                                      color: const Color(0xffffffff),
                                      padding: const EdgeInsets.all(4.0),
                                      child: ListTile(
                                        leading: CachedNetworkImage(
                                          imageUrl: value
                                              .apiResponse.data![index].image!,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          placeholder: (
                                            context,
                                            progress,
                                          ) =>
                                              Utils.showLoadingSpinner(),
                                        ),
                                        title: Text(
                                          value.apiResponse.data![index].title!
                                                  .toUpperCase()[0] +
                                              value.apiResponse.data![index]
                                                  .title!
                                                  .substring(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: const Color(0xff030605),
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                        ),
                                      )),
                                ),
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
        ));
  }
}
