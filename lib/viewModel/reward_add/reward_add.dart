import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAdd with ChangeNotifier {
  bool isAdLoading = false;
  bool get isAddsLoading => isAdLoading;
  RewardedAd? rewardedAd;
  setLoading(bool loading) {
    isAdLoading = loading;
    notifyListeners();
  }

 Future<void> createReward()async {
    setLoading(true);
   await RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        request:
            const AdRequest(contentUrl: "https://zeecodercraft-a5508.web.app/"),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          setLoading(false);
        }, onAdFailedToLoad: (error) {
          setLoading(false);
          rewardedAd = null;
        }));
  }

  showRewarAdd() {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
     
        createReward();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        createReward();
      });
       rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      });
      rewardedAd = null;
    }
  }
}
