import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/join_live_webinar/join_live_webinar_bloc.dart';
import '../bloc/join_live_webinar/join_live_webinar_event.dart';
import '../bloc/join_live_webinar/join_live_webinar_state.dart';
import '../bloc/live_webinar/live_webinar_bloc.dart';
import '../repository/join_live_webinar_repository.dart';
import '../repository/live_webinar_repository.dart';

class EnrollNowScreen extends StatefulWidget {
  final String webinarId;
  const EnrollNowScreen({super.key, required this.webinarId});

  @override
  State<EnrollNowScreen> createState() => _EnrollNowScreenState();
}

class _EnrollNowScreenState extends State<EnrollNowScreen> {
  bool _itEnroll = false;
  Duration _remainingTime = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 🔹 Countdown Setup
  void _startCountdown(DateTime startDateTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = startDateTime.difference(now);

      if (difference.isNegative) {
        timer.cancel();
        setState(() => _remainingTime = Duration.zero);
      } else {
        setState(() => _remainingTime = difference);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LiveWebinarBloc(LiveWebinarRepository())
            ..add(FetchLiveWebinarsEvent()),
        ),
        BlocProvider(
          create: (_) => JoinLiveWebinarBloc(JoinLiveWebinarRepository()),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(title: 'Webinar', showBackButton: true),

        // 🔥 LISTEN FOR JOIN SUCCESS / ERROR
        body: BlocListener<JoinLiveWebinarBloc, JoinLiveWebinarState>(
          listener: (context, state) {
            if (state is JoinLiveWebinarSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is JoinLiveWebinarFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },

          child: SafeArea(
            child: BlocBuilder<LiveWebinarBloc, LiveWebinarState>(
              builder: (context, state) {
                if (state is LiveWebinarLoading) {
                  return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
                }

                if (state is LiveWebinarError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is LiveWebinarLoaded) {
                  final webinar = state.liveWebinarModel.data
                      .firstWhere((w) => w.id == widget.webinarId);

                  // 🧩 Parse DateTime
                  try {
                    final dateParts = (webinar.date ?? '').split('-');
                    final timeParts = (webinar.startTime ?? '').split(':');
                    if (dateParts.length == 3 && timeParts.length >= 2) {
                      final startDateTime = DateTime(
                        int.parse(dateParts[0]),
                        int.parse(dateParts[1]),
                        int.parse(dateParts[2]),
                        int.parse(timeParts[0]),
                        int.parse(timeParts[1]),
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _startCountdown(startDateTime);
                      });
                    }
                  } catch (_) {}

                  // 🧭 Calculate hours & minutes
                  final hours = _remainingTime.inHours;
                  final minutes = _remainingTime.inMinutes.remainder(60);

                  final bool alreadyJoined = webinar.user.any(
                        (u) => u.user == userSession.userId && u.status == true,
                  );


                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: dimensions.screenWidth * 0.03),
                    child: Column(
                      children: [
                        CustomContainer(
                          border: true,
                          color: CustomColor.whiteColor,
                          padding: EdgeInsets.zero,
                          margin:
                          EdgeInsets.only(top: dimensions.screenHeight * 0.015),
                          child: Column(
                            children: [
                              CustomContainer(
                                margin: EdgeInsets.zero,
                                networkImg: webinar.imageUrl ?? '',
                                height: dimensions.screenHeight * 0.18,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(webinar.name ?? '',
                                        style: textStyle14(context)),
                                    Text(
                                      webinar.description ?? '',
                                      style: textStyle12(
                                        context,
                                        color: CustomColor.descriptionColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    10.height,
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Date: ${webinar.date ?? ''}',
                                            style: textStyle12(context)),
                                        Row(
                                          children: [
                                            Text(
                                                'Start: ${webinar.startTime ?? ''}',
                                                style: textStyle12(context)),
                                            10.width,
                                            Text('End: ${webinar.endTime ?? ''}',
                                                style: textStyle12(context)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    20.height,

                                    // 🔹 Updated Timer UI
                                    if (_remainingTime > Duration.zero) ...[
                                      Text(
                                        'Time Remaining',
                                        style: textStyle14(context,
                                            color: CustomColor.descriptionColor),
                                      ),
                                      10.height,
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: hours
                                                      .toString()
                                                      .padLeft(2, '0'),
                                                  style: textStyle20(context),
                                                ),
                                                TextSpan(
                                                  text: ' hr',
                                                  style: textStyle16(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.width,
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: minutes
                                                      .toString()
                                                      .padLeft(2, '0'),
                                                  style: textStyle20(context),
                                                ),
                                                TextSpan(
                                                  text: ' min',
                                                  style: textStyle16(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ] else
                                      Text(
                                        webinar.closeStatus
                                            ? 'Closed'
                                            : "Webinar is Live!",
                                        style: textStyle14(context,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        20.height,

                        // 🔹 Enroll Section
                        if (!alreadyJoined)
                        CustomContainer(
                          border: true,
                          width: double.infinity,
                          color: CustomColor.whiteColor,
                          onTap: () => setState(() => _itEnroll = !_itEnroll),
                          child: !_itEnroll
                              ? Column(
                            children: [
                              20.height,
                              Text(
                                'Tap below to enroll',
                                style: textStyle14(context,
                                    color: CustomColor.descriptionColor),
                              ),
                              10.height,
                              Text(
                                'Enroll Now',
                                style: textStyle20(context,
                                    color: CustomColor.appColor),
                              ),
                              20.height,
                            ],
                          )
                              : Column(
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.videocam_outlined,
                                      color: CustomColor.appColor),
                                  5.width,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: (webinar.displayVideoUrls ??
                                          [])
                                          .map(
                                            (link) => Text(
                                          link,
                                          style: textStyle14(context,
                                              color: CustomColor
                                                  .appColor),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                              20.height,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  _card(context,
                                      label: 'Copy',
                                      icon: Icons.copy,
                                      onTap: () {
                                        if (webinar.displayVideoUrls
                                            ?.isNotEmpty ??
                                            false) {
                                          CopyUrl(webinar
                                              .displayVideoUrls!.first);
                                        }
                                      }),

                                  // -----------------------------------------------------
                                  // 🔥 JOIN BUTTON WITH BLOC
                                  // -----------------------------------------------------
                                  BlocBuilder<JoinLiveWebinarBloc,
                                      JoinLiveWebinarState>(
                                    builder: (context, joinState) {
                                      return _card(context,
                                        label: joinState
                                        is JoinLiveWebinarLoading
                                            ? "Joining..."
                                            : 'Join',
                                        icon: Icons.phonelink_rounded,
                                        onTap: joinState
                                        is JoinLiveWebinarLoading
                                            ? null
                                            : () {
                                          context
                                              .read<
                                              JoinLiveWebinarBloc>()
                                              .add(
                                            JoinWebinarEvent(
                                              webinarId: widget.webinarId,
                                              users: ["${userSession.userId}"],
                                              status: true,
                                            ),
                                          );

                                          if (webinar.displayVideoUrls
                                              ?.isNotEmpty ??
                                              false) {
                                            CustomUrlLaunch(webinar
                                                .displayVideoUrls!
                                                .first);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 Reusable Action Button
Widget _card(BuildContext context,
    {VoidCallback? onTap, required String label, required IconData icon}) {
  return CustomContainer(
    border: true,
    color: CustomColor.whiteColor,
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: Row(
      children: [
        Text(label, style: textStyle14(context, color: CustomColor.appColor)),
        10.width,
        Icon(icon, size: 16, color: CustomColor.appColor),
      ],
    ),
  );
}
