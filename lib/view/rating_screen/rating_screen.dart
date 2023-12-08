import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/rating_view_model/rating_view_model.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 0.0;

  final ratingController = TextEditingController();
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  void _onsave() {
    if (rating == 0.0 || ratingController.text.isEmpty) {
      return;
    } else {
      getUserData().then(
        (value) {
          context
              .read<RatingViewModel>()
              .postRating(
                context,
                {
                  "userId": value.sId,
                  "message": ratingController.text.toString(),
                  "rating": rating.toString(),
                },
                value.token!,
              )
              .then((value) {
            ratingController.clear();
            rating = 0.0;
            setState(() {});
          });
        },
      );
    }
  }

  Widget _buildRating() => RatingBar.builder(
        itemBuilder: (context, _) => const Icon(
          Icons.star_border_purple500_outlined,
          color: Colors.amber,
        ),
        allowHalfRating: true,
        updateOnDrag: true,
        minRating: 0,
        initialRating: rating,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemSize: 40,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebecf0),
      appBar: AppBar(
        backgroundColor: const Color(0xffebecf0),
        iconTheme: const IconThemeData(color: AppColors.black),
        title: const Text(
          "Rating",
          style: TextStyle(color: AppColors.black),
        ),
      ),
      body: Consumer<RatingViewModel>(
        builder: (context, value, _) => ModalProgressHUD(
          inAsyncCall: value.isLoading,
          progressIndicator: Utils.showLoadingSpinner(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Card(
                      color: const Color(0xff454fb9),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Did you like this app?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 20,
                                    color: AppColors.white,
                                  ),
                            ),
                            const Gap(10),
                            Text(
                              "Let us know what you think",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: const Color(0xffa1afea),
                                  ),
                            ),
                            const Gap(32),
                            _buildRating(),
                            const Gap(10),
                            TextField(
                              maxLines: 5,
                              cursorColor: AppColors.white,
                              controller: ratingController,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: AppColors.white),
                              decoration: InputDecoration(
                                fillColor: const Color(0xff2d367c),
                                filled: true,
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  _onsave();
                                },
                                child: Text(
                                  "SEND REVIEW",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.amber,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
