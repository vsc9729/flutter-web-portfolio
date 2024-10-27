import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/common_assets.dart';
import 'package:portfolio/theme/index.dart';
import 'package:portfolio/utils/common_util.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMe extends StatelessWidget {
  const ContactMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          const Spacer(),
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.landscape
                ? 3
                : 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: CommonUtil.scaleText(120.sp, context),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Divider(
                        color: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .color!
                            .withOpacity(0.4),
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      RichText(
                        maxLines: 4,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Do you have a project in mind? Want to hire me? or simply wanna chat? Feel free to ",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: AppFonts.poppins,
                                    fontSize: CommonUtil.scaleText(
                                        MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 34.sp
                                            : 60.sp,
                                        context),
                                    color: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .color!
                                        .withOpacity(0.7),
                                  ),
                            ),
                            // TextSpan(
                            //   text: "schedule a meeting",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .displaySmall!
                            //       .copyWith(
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: scaleText(
                            //             MediaQuery.of(context).orientation ==
                            //                     Orientation.landscape
                            //                 ? 34.sp
                            //                 : 60.sp,
                            //             context),
                            //         fontFamily: AppFonts.poppins,
                            //         color: Theme.of(context)
                            //             .textTheme
                            //             .displaySmall!
                            //             .color!
                            //             .withOpacity(0.7),
                            //       ),
                            // )
                            WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                        "https://calendly.com/vsc-uiet/30min",
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Text(
                                        "schedule a meeting",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: CommonUtil.scaleText(
                                                  MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? 34.sp
                                                      : 60.sp,
                                                  context),
                                              fontFamily: AppFonts.poppins,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .color!
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(
                                            0,
                                            MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.landscape
                                                ? -30.h
                                                : -25.h),
                                        child: LottieBuilder.network(
                                          CommonLottieAssets.underline,
                                          repeat: false,
                                          frameRate: FrameRate.max,
                                          height: 100.h,
                                          width: 200.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
