import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("About"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnBATLU7TmDjWZlVLPFlLmo8cxxZblz2b9Cw&usqp=CAU"),
                ),
              ),
              const Gap(20),
              Text(
                "📚🧠 Welcome to Quiz Ebook – Your Ultimate Learning Hub! 🧠📚",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              Text(
                "Dive into a world of knowledge and fun with Quiz Ebook, the perfect blend of quizzes and ebooks that will stimulate your mind and expand your horizons.",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Gap(10),
              Text(
                "🔍 Explore a Vast Library of Ebooks:",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(10),
              Text(
                "Immerse yourself in a treasure trove of knowledge with our extensive collection of ebooks covering a myriad of topics. From technology to literature, science to self-help, we've got something for everyone. Learn at your own pace, wherever you are.",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Gap(10),
              Text(
                "🤔 Challenge Your Mind with Engaging Quizzes:",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(10),
              Text(
                "Put your knowledge to the test with our interactive quizzes. Whether you're a trivia buff or just looking for a fun way to learn, our quizzes cater to all skill levels. Earn points, unlock achievements, and compete with friends to see who reigns supreme in the world of intellect.",
                style: Theme.of(context).textTheme.titleSmall,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
