import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_url_launch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/custom_log_emoji.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../helper/Contact_helper.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../checkout/screen/check_out_screen.dart';
import '../../../provider/bloc/service_wise_provider_subscriber/service_wise_provider_subscriber_bloc.dart';
import '../../../provider/bloc/service_wise_provider_subscriber/service_wise_provider_subscriber_event.dart';
import '../../../provider/bloc/service_wise_provider_subscriber/service_wise_provider_subscriber_state.dart';
import '../../../provider/repository/service_wise_provider_subscriber_repository.dart';
import '../../../rating_review/bloc/servicereview/servicereview_bloc.dart';
import '../../../rating_review/bloc/servicereview/servicereview_event.dart';
import '../../../service/repository/service_review_service.dart';
import '../../../rating_review/widget/review_rating_card_widget.dart';
import '../../business/screen/investment_repository_screen.dart';
import '../../business/screen/monthly_earning_screen.dart';
import '../../marketing/screen/franchise_commission_screen.dart';
import '../bloc/franchise_model/franchise_model_bloc.dart';
import '../bloc/franchise_model/franchise_model_event.dart';
import '../bloc/franchise_model/franchise_model_state.dart';
import '../bloc/franchise_service_details/franchise_service_details_bloc.dart';
import '../bloc/franchise_service_details/franchise_service_details_event.dart';
import '../bloc/franchise_service_details/franchise_service_details_state.dart';
import '../repository/franchise_repository.dart';
import '../repository/franchise_service_details_repository.dart';
// import 'package:flutter_html/table.dart';


class FranchiseServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const FranchiseServiceDetailsScreen(
      {super.key, required this.serviceId, required this.serviceName});

  @override
  State<FranchiseServiceDetailsScreen> createState() =>
      _FranchiseServiceDetailsScreenState();
}

class _FranchiseServiceDetailsScreenState
    extends State<FranchiseServiceDetailsScreen> {
  int _currentBannerIndex = 0;
  // int expandedIndex = -1;
  int expandedIndex = 0;
  int _selectedPackageIndex = 0;
  int? _expandedFranchiseModelIndex;

  int? selectedProviderIndex;
  bool showAllProviders = false;
  final ScrollController scrollController = ScrollController();
  final GlobalKey providerSectionKey = GlobalKey();
  final List providers = List.generate(7, (index) => index);

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context, listen: false);


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FranchiseServiceDetailsBloc(repository: FranchiseServiceDetailsRepository())..add(FetchFranchiseServiceDetails(widget.serviceId))),

        BlocProvider(
          create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
          )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),
        ),

        BlocProvider(create: (_) => ServiceReviewBloc(ReviewService())..add(FetchServiceReviews(widget.serviceId)),),
        BlocProvider(create: (_) => FranchiseModelBloc(FranchiseRepository())..add(FetchFranchiseModel(widget.serviceId)),),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<FranchiseServiceDetailsBloc,
            FranchiseServiceDetailsState>(
          builder: (context, state) {
            if (state is FranchiseServiceDetailsLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: CustomColor.franchise,
              ));
            } else if (state is FranchiseServiceDetailsLoaded) {
              final service = state.service;
              final selectedPackage = service.franchiseDetails.franchiseModel[_selectedPackageIndex];

              return BlocBuilder<ServiceWiseProviderSubscriberBloc, ServiceWiseProviderSubscriberState>(
                builder: (context, providerState) {
                  if (providerState is ServiceWiseProviderSubscriberLoading) {
                    return SizedBox.shrink();
                  }

                  if (providerState is ServiceWiseProviderSubscriberLoaded) {
                    final providers = providerState.providers;

                    return Column(
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverAppBar(
                                pinned: true,
                                expandedHeight: dimensions.screenHeight * 0.45,
                                backgroundColor: Colors.white,
                                elevation: 0,
                                automaticallyImplyLeading: false,
                                flexibleSpace: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final top = constraints.biggest.height;
                                    bool isCollapsed = top <=
                                        kToolbarHeight + MediaQuery.of(context).padding.top;

                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          opacity: isCollapsed ? 0.0 : 1.0,
                                          child: service.bannerImages.isNotEmpty
                                              ? Stack(
                                            children: [
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                  viewportFraction: 1.0,
                                                  height: double.infinity,
                                                  autoPlay:
                                                  service.bannerImages.length > 1,
                                                  autoPlayInterval:
                                                  const Duration(seconds: 3),
                                                  autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                                  autoPlayCurve: Curves.easeInOut,
                                                  enlargeCenterPage: false,
                                                  enableInfiniteScroll:
                                                  service.bannerImages.length > 1,
                                                  pauseAutoPlayOnTouch: true,
                                                  onPageChanged: (index, reason) {
                                                    setState(() {
                                                      _currentBannerIndex = index;
                                                    });
                                                  },
                                                ),
                                                items: service.bannerImages
                                                    .map((imageUrl) {
                                                  return Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  );
                                                }).toList(),
                                              ),
                                              if (service.bannerImages.length > 1)
                                                Positioned(
                                                  bottom: 12,
                                                  left: 15,
                                                  right: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: List.generate(
                                                      service.bannerImages.length,
                                                          (index) => AnimatedContainer(
                                                        duration: const Duration(
                                                            milliseconds: 300),
                                                        margin: const EdgeInsets
                                                            .symmetric(horizontal: 4),
                                                        height: 6,
                                                        width: _currentBannerIndex ==
                                                            index
                                                            ? 18
                                                            : 6,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          _currentBannerIndex ==
                                                              index
                                                              ? CustomColor
                                                              .marketing
                                                              : Colors.white
                                                              .withOpacity(
                                                              0.5),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )
                                              : Container(color: Colors.grey),
                                        ),
                                        if (isCollapsed)
                                          Positioned.fill(
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                        Positioned(
                                          top: MediaQuery.of(context).padding.top + 8,
                                          left: 8,
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 200),
                                            opacity:
                                            isCollapsed ? 0.0 : 1.0, // hide on collapse
                                            child: CircleAvatar(
                                              backgroundColor:
                                              Colors.black.withOpacity(0.1),
                                              radius: 18,
                                              child: IconButton(
                                                icon: Icon(Icons.arrow_back,
                                                    color: CustomColor.marketing),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 16,
                                          bottom: 16,
                                          right: 16,
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 200),
                                            opacity: isCollapsed
                                                ? 1.0
                                                : 0.0, // show only when collapsed
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                // CircleAvatar(child: Center(child: Icon(Icons.arrow_back_ios))),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(service.serviceName,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.star,
                                                              color: Colors.amber,
                                                              size: 14),
                                                          const SizedBox(width: 3),
                                                          Text(
                                                              "${service.averageRating} (${service.totalReviews})",
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.black)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (service.serviceDetails
                                                    .franchiseOperatingModel.isNotEmpty)
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: CustomColor.franchise,
                                                      borderRadius:
                                                      BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      "₹ ${selectedPackage!.price.toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),

                                                    // child: Text(
                                                    //   "₹ ${service.serviceDetails.packages.first.discountedPrice.toStringAsFixed(2)}",
                                                    //   style: const TextStyle(
                                                    //       fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                                                    // ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 10)),

                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(service.serviceName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                              Text(service.category.name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey.shade700)),

                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${CustomLogEmoji.star} ${service.averageRating}',
                                                style:
                                                TextStyle(color: Colors.grey.shade700),
                                              ),
                                              Text(
                                                '(${service.totalReviews}+ Reviews)',
                                                style:
                                                TextStyle(color: Colors.grey.shade700),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CustomContainer(
                                              margin: EdgeInsets.zero,
                                              color: Color(0xFFABB999).withOpacity(0.2),
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Investment range',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Row(spacing: 5, children: [
                                                    Text(
                                                      '\u20B9 ${service.franchiseDetails.investmentRange[0].range}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      '${service.franchiseDetails.investmentRange[0].parameters}',
                                                      style: TextStyle(
                                                          color: Colors.grey.shade700,
                                                          fontSize: 10),
                                                    ),
                                                  ]),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => InvestmentRepositoryScreen(
                                                            serviceId: service.id,
                                                            serviceImage: service.thumbnailImage,
                                                            serviceName: service.serviceName,
                                                          ),));
                                                        },
                                                        child: Text(
                                                          'View Breakup',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: CustomColor.franchise,
                                                              fontWeight: FontWeight.w600),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: CustomContainer(
                                              margin: EdgeInsets.zero,
                                              color: Color(0xFFABB999).withOpacity(0.2),
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Monthly Earning Potential',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Row(spacing: 5, children: [
                                                    Text(
                                                      '\u20B9 ${service.franchiseDetails.monthlyEarnPotential[0].range}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      '${service.franchiseDetails.monthlyEarnPotential[0].parameters}',
                                                      style: TextStyle(
                                                          color: Colors.grey.shade700,
                                                          fontSize: 10),
                                                    ),
                                                  ]),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyEarningScreen(

                                                          ),));
                                                        },
                                                        child: Text(
                                                          'View Breakup',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              CustomColor.franchise,
                                                              fontWeight:
                                                              FontWeight.w600),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      15.height,
                                      Row(
                                        spacing: 5,
                                        children: [
                                          Icon(
                                            Icons.file_copy_outlined,
                                            size: 18,
                                            color: Colors.grey.shade700,
                                          ),
                                          Text(
                                            'EMI Options Available',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700),
                                          )
                                        ],
                                      ),
                                      15.height,
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFF8EF),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                color: CustomColor.franchise, width: 0.3)),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Franchise Commission',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'Earn Up to ${service.franchiseDetails.commission}',
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseCommissionScreen(commission: service.franchiseDetails.commission,t_and_c: service.franchiseDetails.termsAndConditions,),));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'T&C',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey.shade700,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      15.height,
                                      Container(
                                          decoration: BoxDecoration(
                                            // color: Color(0xFFFFF8EF),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: CustomColor.franchise,
                                                  width: 0.3)),
                                          padding: const EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: () {
                                              CustomUrlLaunch('${service.serviceDetails.brochureImage.first}');
                                            },
                                            child: Row(
                                              spacing: 5,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.save_alt,
                                                  size: 18,
                                                  color: CustomColor.franchise,
                                                ),
                                                Text(
                                                  'Free Brochure',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: CustomColor.franchise,
                                                      fontWeight: FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 10)),

                              if (service.serviceDetails.benefits.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Benefits",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.franchise,
                                          ),
                                        ),

                                        ...service.serviceDetails.benefits.map(
                                              (b) => Html(
                                                data: b,
                                                style: {
                                                  "p": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                    lineHeight: LineHeight.number(1.4),
                                                  ),
                                                  "li": Style(
                                                  ),
                                                  "table": Style(
                                                  ),
                                                  "th": Style(
                                                  ),
                                                  "td": Style(
                                                  ),
                                                  "body": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                  ),
                                                  "br": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                  )
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.aboutUs.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "About Us",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.franchise,
                                          ),
                                        ),
                                        ...service.serviceDetails.aboutUs.map(
                                              (b) =>  Html(
                                                data: b,
                                                style: {
                                                  "p": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                    lineHeight: LineHeight.number(1.4),
                                                  ),
                                                  "li": Style(
                                                  ),
                                                  "table": Style(
                                                  ),
                                                  "th": Style(
                                                  ),
                                                  "td": Style(
                                                  ),
                                                  "body": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                  ),
                                                  "br": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                  )
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.highlight.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: List.generate(
                                        service.serviceDetails.highlight.length,
                                            (index) {
                                          final highlightImg =
                                          service.serviceDetails.highlight[index];
                                          return Container(
                                            height: dimensions.screenHeight * 0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(20), // 20
                                                  topRight: Radius.circular(20), // 20
                                                ),
                                                // border: Border(
                                                //   top: BorderSide(
                                                //     color: CustomColor.marketing,
                                                //     width: 1.5,
                                                //   ),
                                                // ),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.black12,
                                                //     blurRadius: 6,
                                                //     offset: Offset(0, 3),
                                                //   ),
                                                // ],
                                                image: DecorationImage(
                                                    image: NetworkImage(highlightImg))),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),


                              if (service.keyValues.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: const Color(0xFFFFFBF7),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: service.keyValues.length,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 1 / 0.4,
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = service.keyValues[index];

                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 0,
                                          minVerticalPadding: 0,
                                          leading: Image.network(
                                            item.icon,
                                            height: 20,
                                            width: 20,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.image, size: 22),
                                          ),
                                          title: Text(
                                            item.key,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${item.value}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              const SliverToBoxAdapter(child: SizedBox(height: 10)),

                              if (service.serviceDetails.counter.isNotEmpty)
                                SliverToBoxAdapter(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: service.serviceDetails.counter.length,
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3, // FIXED count (best practice)
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 1 / 0.7),
                                      itemBuilder: (context, index) {
                                        final List<Color> counterBgColors = [
                                          const Color(0xFFEDF3FF),
                                          const Color(0xFFECFFEF),
                                          const Color(0xFFF7F3FF),
                                          Colors.green.shade50,
                                        ];

                                        final List<Color> counterTextColors = [
                                          const Color(0xFF2563EB), // blue
                                          const Color(0xFF16A34A), // green
                                          const Color(0xFF7C3AED), // purple
                                          const Color(0xFF15803D), // dark green
                                        ];


                                        final counter = service.serviceDetails.counter[index];
                                        final bgColor = counterBgColors[index % counterBgColors.length];
                                        final textColor = counterTextColors[index % counterTextColors.length];

                                        return CustomContainer(
                                          color:bgColor,
                                          margin: EdgeInsets.zero,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${counter.number.toString()}+',
                                                style:  TextStyle(
                                                  fontSize: 20,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                counter.title ?? "",
                                                style: const TextStyle(
                                                    fontSize: 10, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )),

                              if (service.serviceDetails.franchiseOperatingModel.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Franchise Operating Models',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: CustomColor.franchise,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${service.serviceDetails.franchiseOperatingModel.first.info}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        20.height,
                                        CustomContainer(
                                          border: true,
                                          margin: EdgeInsets.zero,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: CustomContainer(
                                                  margin: EdgeInsets.zero,
                                                  color: CustomColor.franchise,
                                                  child: Icon(
                                                    Icons.home_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                title: Text(
                                                  service.serviceDetails
                                                      .franchiseOperatingModel.first.title,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: CustomColor.franchise),
                                                ),
                                                trailing: CustomContainer(
                                                  border: true,
                                                  color: Color(0xFF2164F4).withOpacity(0.2),
                                                  borderColor: CustomColor.franchise,
                                                  child: Text(
                                                    'FOFO',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                service
                                                    .serviceDetails
                                                    .franchiseOperatingModel
                                                    .first
                                                    .description,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade700),
                                              ),
                                              20.height,
                                              GridView.builder(
                                                itemCount: service
                                                    .serviceDetails
                                                    .franchiseOperatingModel
                                                    .first
                                                    .features
                                                    .length,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    // crossAxisSpacing: 8,
                                                    mainAxisSpacing: 8),
                                                itemBuilder: (context, index) {
                                                  final showBorder =
                                                      index == 1 || index == 4;
                                                  final list = service
                                                      .serviceDetails
                                                      .franchiseOperatingModel
                                                      .first
                                                      .features[index];
                                                  return Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        left: showBorder
                                                            ? const BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.9)
                                                            : BorderSide.none,
                                                        right: showBorder
                                                            ? const BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.9)
                                                            : BorderSide.none,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      spacing: 5,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        Image.network(
                                                          list.icon,
                                                          height: 21,
                                                          width: 21,
                                                        ),
                                                        Text(
                                                          list.subtitle,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.grey.shade700),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 2,
                                                        ),
                                                        Text(
                                                          list.subDescription,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              10.height,
                                              Row(
                                                spacing: 10,
                                                children: [
                                                  Text(
                                                    '${CustomLogEmoji.crown} Example:',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: CustomColor.marketing),
                                                  ),
                                                  Text(
                                                    '${service.serviceDetails.franchiseOperatingModel.first.example}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color:
                                                        CustomColor.descriptionColor),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),


                              if(service.serviceDetails.whyChooseUs.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Why Choose This Franchise?',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: CustomColor.franchise),
                                        ),
                                        10.height,
                                        GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: service.serviceDetails.whyChooseUs.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1/0.6
                                          ),
                                          itemBuilder: (context, index) {
                                            final choose = service.serviceDetails.whyChooseUs[index];
                                            return Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                    Colors.black.withOpacity(0.06),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                spacing: 10,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.network('${choose.icon}',height: 14,),
                                                  Expanded(
                                                    child: Column(
                                                      spacing: 5,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('${choose.title}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                        Text('${choose.description}', style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.grey.shade700),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              if(service.serviceDetails.businessFundamental!.description.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Business Fundamental',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: CustomColor.franchise),
                                        ),
                                        Text(service.serviceDetails.businessFundamental!.description,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey.shade700),),
                                        10.height,

                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                Colors.black.withOpacity(0.06),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            spacing: 10,
                                            children: List.generate(service.serviceDetails.businessFundamental!.points.length,
                                                  (index) {
                                                final list = service.serviceDetails.businessFundamental!.points[index];
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(list.subtitle, style: TextStyle(fontSize: 12),),
                                                        Text(list.subDescription,style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                                      ],
                                                    ),

                                                    Icon(Icons.check_circle_outline_outlined,size: 18,color: Colors.green,),
                                                  ],
                                                );
                                              },),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),


                              if (service.franchiseDetails.franchiseModel.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Franchise Model", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        const SizedBox(height: 10),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: service.franchiseDetails.franchiseModel.length,
                                          scrollDirection: Axis.vertical,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder:(context, index) {

                                            final pkg = service.franchiseDetails.franchiseModel[index];
                                            final bool isSelected = _selectedPackageIndex == index;

                                            return  Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 2),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedPackageIndex = index;
                                                  });

                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: CustomColor.franchise,
                                                          offset: const Offset(0, -3),
                                                          blurRadius: 1,
                                                          spreadRadius: 0,
                                                        ),

                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.2),
                                                          offset: const Offset(0, 4),
                                                          blurRadius: 10,
                                                          spreadRadius: 1,
                                                        ),
                                                      ]
                                                  ),

                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(pkg.title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: CustomColor.business),),
                                                              Row(
                                                                spacing: 5,
                                                                children: [
                                                                  Text('Agreement',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.grey),),
                                                                  Text(pkg.agreement,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400, color: Colors.grey),),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("₹${pkg.price.toString()}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: CustomColor.business),),
                                                              Row(
                                                                spacing: 5,
                                                                children: [
                                                                  Text('+${pkg.gst}% GST',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400, color: Colors.grey),),
                                                                ],
                                                              ),
                                                            ],
                                                          ),

                                                          CustomContainer(
                                                            margin: EdgeInsets.zero,
                                                            color: CustomColor.business,
                                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                                            child: Text('Enquiry Now', style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.white),),
                                                          )
                                                        ],
                                                      ),
                                                      5.height,
                                                      Divider(height: 0.1,color: Colors.grey.shade200,),
                                                      10.height,

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Franchise Frees',style: TextStyle(color: Colors.grey),),
                                                              Text('₹${pkg.fees}'),
                                                            ],
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                if (_expandedFranchiseModelIndex == index) {
                                                                  _expandedFranchiseModelIndex = null; // close
                                                                } else {
                                                                  _expandedFranchiseModelIndex = index; // open
                                                                }
                                                              });
                                                            },
                                                            icon: AnimatedRotation(
                                                              turns: _expandedFranchiseModelIndex == index ? 0.5 : 0,
                                                              duration: const Duration(milliseconds: 500),
                                                              curve: Curves.easeOutCubic,
                                                              child:  Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.grey,),
                                                            ),
                                                          )

                                                        ],
                                                      ),

                                                      AnimatedSize(
                                                        duration: const Duration(milliseconds: 500),
                                                        curve: Curves.easeOutCubic,
                                                        alignment: Alignment.topCenter,
                                                        clipBehavior: Clip.antiAlias,
                                                        child: _expandedFranchiseModelIndex == index
                                                            ? BlocBuilder<FranchiseModelBloc, FranchiseModelState>(
                                                          builder: (context, state) {
                                                            if (state is FranchiseModelLoading) {
                                                              return const CircularProgressIndicator();
                                                            }

                                                            if (state is FranchiseModelLoaded) {
                                                              final allModels = state.data.data?.model ?? [];

                                                              final matchedModels = allModels.where((e) =>
                                                                  e.franchiseSize
                                                                      .toLowerCase()
                                                                      .replaceAll(' ', '')
                                                                      .contains(
                                                                    pkg.title.toLowerCase().replaceAll(' ', ''),
                                                                  ),
                                                              ).toList();

                                                              if (matchedModels.isEmpty) {
                                                                return const Padding(
                                                                  padding: EdgeInsets.only(top: 8),
                                                                  child: Text(
                                                                    'No franchise details available',
                                                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                                                  ),
                                                                );
                                                              }

                                                              final item = matchedModels.first;


                                                              return Padding(
                                                                padding: const EdgeInsets.only(top: 10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    _infoTile('Area Required', item.areaRequired),
                                                                    _infoTile('Marketing', item.marketing),
                                                                    _infoTile('ROI', item.returnOfInvestment),
                                                                    _infoTile('Man Power', item.manPower.toString()),
                                                                    _infoTile('Staff Management', item.staffManagement),
                                                                    _infoTile('Royalty', item.royaltyPercent),
                                                                    _infoTile('Gross Margin', item.grossMargin),
                                                                    _infoTile('Radius Area', item.radiusArea),
                                                                  ],
                                                                ),
                                                              );
                                                            }

                                                            if (state is FranchiseModelError) {
                                                              return Text(state.message);
                                                            }

                                                            return const SizedBox();
                                                          },
                                                        )
                                                            : const SizedBox(),
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },),

                                      ],
                                    ),
                                  ),
                                ),


                              if (service.serviceDetails.keyAdvantages.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Key Advantages", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        const SizedBox(height: 10),

                                        Column(
                                          children: List.generate(service.serviceDetails.keyAdvantages.length, (index) {
                                            final list = service.serviceDetails.keyAdvantages[index];
                                            return Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              padding: EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                border:  Border(
                                                  left: BorderSide(
                                                    color: CustomColor.franchise,
                                                    width: 2,
                                                  ),
                                                ),

                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.08),
                                                    blurRadius: 6,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),

                                              child: ListTile(
                                                leading: Image.network(list.icon,height: 20,),
                                                title: Text('${list.title}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                subtitle: Text('${list.description}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                              ),
                                            );
                                          },),
                                        )

                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.completeSupportSystem.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Complete Support System", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        const SizedBox(height: 10),

                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            spacing: 20,
                                            children: List.generate(service.serviceDetails.completeSupportSystem.length, (index) {
                                              final list = service.serviceDetails.completeSupportSystem[index];
                                              return Column(
                                                spacing: 10,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    spacing: 10,
                                                    children: [
                                                      Image.network(list.icon,height: 20,),
                                                      Text('${list.title}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                    ],
                                                  ),

                                                  Wrap(
                                                    spacing: 25,
                                                    runSpacing: 6,
                                                    children: List.generate(list.lists.length, (index) {
                                                      final listData = list.lists[index];
                                                      return Wrap(
                                                        crossAxisAlignment: WrapCrossAlignment.center,
                                                        spacing: 5,
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Colors.grey.shade700,
                                                          ),
                                                          Text(
                                                            listData,
                                                            style: TextStyle(fontSize: 12,color: Colors.grey.shade700),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                  Divider(color: Colors.grey.shade200,),

                                                ],
                                              );
                                            },),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),


                              if (service.serviceDetails.trainingDetails.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Training Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        10.height,

                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            spacing: 10,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(service.serviceDetails.trainingDetails.length, (index) {
                                              final list = service.serviceDetails.trainingDetails[index];
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5.0,right: 8),
                                                    child: Icon(Icons.circle,size: 8,),
                                                  ),
                                                  Expanded(child: Text('${list}',style: TextStyle(fontSize: 14),)),
                                                ],
                                              );
                                            },),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.agreementDetails.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Agreement Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        10.height,

                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            spacing: 10,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: List.generate(service.serviceDetails.agreementDetails.length, (index) {
                                              final list = service.serviceDetails.agreementDetails[index];
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5.0,right: 8),
                                                    child: Icon(Icons.circle,size: 8,),
                                                  ),
                                                  Expanded(child: Text('${list}',style: TextStyle(fontSize: 14),)),
                                                ],
                                              );
                                            },),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.goodThings.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Good Things Here", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        10.height,

                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Wrap(
                                            spacing: 10,          // horizontal space
                                            runSpacing: 10, // vertical space
                                            alignment: WrapAlignment.start,
                                            children: List.generate(
                                              service.serviceDetails.goodThings.length,
                                                  (index) {
                                                final list = service.serviceDetails.goodThings[index];
                                                return
                                                  CustomContainer(
                                                    border: true,
                                                    margin: EdgeInsets.zero,
                                                    color: Colors.white,
                                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                    child: Text(
                                                      list,
                                                      style: TextStyle(fontSize: 12,color: Colors.grey),
                                                    ),
                                                  );
                                              },
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.weRequired.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("We Required", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                        10.height,

                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            spacing: 10,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: List.generate(service.serviceDetails.weRequired.length, (index) {
                                              final list = service.serviceDetails.weRequired[index];
                                              return Row(
                                                spacing: 5,
                                                children: [
                                                  Icon(Icons.check_circle_outline_outlined,size: 18,color: Colors.green,),
                                                  Text(list.title,style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                                                ],
                                              );
                                            },),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),


                              if (service.serviceDetails.weDeliver.isNotEmpty)
                                // SliverToBoxAdapter(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(16.0),
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         Text("We Deliver", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.franchise)),
                                //         10.height,
                                //
                                //         Container(
                                //           width: double.infinity,
                                //           decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             borderRadius: BorderRadius.circular(10),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: Colors.black.withOpacity(0.08),
                                //                 blurRadius: 6,
                                //                 offset: Offset(0, 3),
                                //               ),
                                //             ],
                                //           ),
                                //           padding: EdgeInsets.all(16),
                                //           child: Column(
                                //             spacing: 10,
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             mainAxisAlignment: MainAxisAlignment.start,
                                //             children: List.generate(service.serviceDetails.weDeliver.length, (index) {
                                //               final list = service.serviceDetails.weDeliver[index];
                                //               return Row(
                                //                 spacing: 5,
                                //                 children: [
                                //                   Icon(Icons.check_circle_outline_outlined,size: 18,color: Colors.green,),
                                //                   Text(list.title,style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                                //                 ],
                                //               );
                                //             },),
                                //           ),
                                //         )
                                //
                                //       ],
                                //     ),
                                //   ),
                                // ),


                              if (service.serviceDetails.compareAndChoose.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Compare & Choose",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.franchise,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // 👇 TABLE FIX
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Html(
                                            data: service.serviceDetails.compareAndChoose.first,

                                            extensions:  [
                                              TableHtmlExtension(), // 🔥 MUST
                                            ],

                                            style: {
                                              "table": Style(
                                                border: Border.all(color: Colors.grey.shade300),
                                                backgroundColor: Colors.white,
                                              ),
                                              "td": Style(
                                                padding: HtmlPaddings.all(10),
                                                border: Border.all(color: Colors.grey.shade300),
                                                fontSize: FontSize(13),
                                              ),
                                              "th": Style(
                                                padding: HtmlPaddings.all(10),
                                                border: Border.all(color: Colors.grey.shade300),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              "figure": Style(
                                                margin: Margins.zero,
                                              ),
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if(service.serviceDetails.companyDetails.isNotEmpty)
                              SliverToBoxAdapter(
                                child: CustomContainer(
                                  color: Color(0xFFE2E0E6),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(service.serviceDetails.companyDetails.first.profile),
                                        ),
                                        title: Text(service.serviceDetails.companyDetails.first.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                        subtitle: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0,right: 3),
                                              child: Icon(Icons.location_on_outlined,size: 14,),
                                            ),
                                            Expanded(child: Text(service.serviceDetails.companyDetails.first.location, style: TextStyle(fontSize: 14),)),
                                          ],
                                        ),
                                      ),

                                      GridView.builder(
                                        itemCount: service.serviceDetails.companyDetails.first.details.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1/0.25
                                        ),
                                        itemBuilder: (context, index) {
                                          final details = service.serviceDetails.companyDetails.first.details[index];

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(details.title,style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                              Text(details.description,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey.shade700),),
                                            ],
                                          );
                                        },)
                                    ],
                                  ),
                                ),
                              ),


                              if (service.serviceDetails.assuredByFetchTrue.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    color: Color(0xFF6E26CB),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Assured By Fetch True",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.whiteColor,
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        MasonryGridView.count(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 14,
                                          crossAxisSpacing: 14,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: service
                                              .serviceDetails.assuredByFetchTrue.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            final data = service.serviceDetails.assuredByFetchTrue[index];

                                            return Row(
                                              spacing: 5,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.network(data.icon,height: 20,),
                                                Expanded(
                                                  child: Column(
                                                    spacing: 5,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        data.title,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      Text(
                                                        data.description,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      5.height,
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),



                              if (service.serviceDetails.moreInfo.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "More Information",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.franchise,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          children: List.generate(
                                            service.serviceDetails.moreInfo.length,
                                                (index) {
                                              final item =
                                              service.serviceDetails.moreInfo[index];
                                              final bool isExpanded =
                                                  expandedIndex == index;

                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    expandedIndex = isExpanded ? -1 : index;
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(bottom: 10.0),
                                                  child: AnimatedSize(
                                                    duration:
                                                    const Duration(milliseconds: 400),
                                                    curve: Curves.easeInOut,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      child: Container(
                                                        constraints: BoxConstraints(
                                                          minHeight: 80,
                                                          maxHeight: isExpanded ? 200 : 80,
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                              child: Image.network(
                                                                item.image,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            Positioned.fill(
                                                              child: Container(
                                                                color: Colors.black
                                                                    .withOpacity(0.35),
                                                              ),
                                                            ),
                                                            Positioned.fill(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                  12,
                                                                  12,
                                                                  12,
                                                                  20,
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                  MainAxisSize.min,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      item.title,
                                                                      style: TextStyle(
                                                                          color:
                                                                          Colors.white,
                                                                          fontSize: 14,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                    ),
                                                                    if (isExpanded) ...[
                                                                      const SizedBox(
                                                                          height: 6),
                                                                      Text(
                                                                        item.description,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w500),
                                                                      ),
                                                                    ],
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
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              if (service.serviceDetails.termsAndConditions.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Terms & Conditions",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.franchise,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Html(
                                                data: service
                                                    .serviceDetails.termsAndConditions
                                                    .join(''),
                                              style: {
                                                "p": Style(
                                                  margin: Margins.zero,
                                                  padding: HtmlPaddings.zero,
                                                  lineHeight: LineHeight.number(1.4),
                                                ),
                                                "li": Style(
                                                ),
                                                "table": Style(
                                                ),
                                                "th": Style(
                                                ),
                                                "td": Style(
                                                ),
                                                "body": Style(
                                                  margin: Margins.zero,
                                                  padding: HtmlPaddings.zero,
                                                ),
                                                "br": Style(
                                                  margin: Margins.zero,
                                                  padding: HtmlPaddings.zero,
                                                )
                                              },)),
                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.faq.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "FAQs",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.franchise,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            // border: Border(
                                            //   top: BorderSide(
                                            //     color: CustomColor.marketing,
                                            //     width: 1.5,
                                            //   ),
                                            // ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children:
                                            service.serviceDetails.faq.map((item) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                    dividerColor: Colors.transparent,
                                                  ),
                                                  child: ExpansionTile(
                                                    tilePadding: EdgeInsets.zero,
                                                    childrenPadding: EdgeInsets.zero,
                                                    expandedAlignment: Alignment.centerLeft,
                                                    expandedCrossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    visualDensity: VisualDensity.compact,
                                                    collapsedShape:
                                                    const RoundedRectangleBorder(
                                                      side: BorderSide.none,
                                                    ),
                                                    shape: const RoundedRectangleBorder(
                                                      side: BorderSide.none,
                                                    ),
                                                    title: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        item.question,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(top: 2),
                                                        child: Text(item.answer),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              SliverToBoxAdapter(
                                child: ReviewRatingCardWidget(color: CustomColor.franchise,),
                              ),

                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Contact With'),
                                          Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.franchise,fontWeight: FontWeight.w600),),
                                        ],
                                      ),

                                      Row(
                                        spacing: dimensions.screenWidth*0.1,
                                        children: [
                                          InkWell(onTap: () {
                                            ContactHelper.call(service.serviceDetails.connectWith.first.mobileNo);
                                          },child: Icon(Icons.call, color: Colors.green,)),
                                          InkWell(
                                            onTap: () async {
                                              String email = '${service.serviceDetails.connectWith.first.email}';
                                              const String subject = 'Support Request';
                                              const String body = 'Hello FetchTrue Team,';

                                              final Uri gmailWebUri = Uri.parse(
                                                'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$subject&body=$body',
                                              );

                                              try {
                                                final Uri mailtoUri = Uri(
                                                  scheme: 'mailto',
                                                  path: email,
                                                  query: 'subject=$subject&body=$body',
                                                );

                                                bool launched = await launchUrl(
                                                  mailtoUri,
                                                  mode: LaunchMode.externalApplication,
                                                );

                                                if (!launched) {
                                                  await launchUrl(
                                                    gmailWebUri,
                                                    mode: LaunchMode.externalApplication,
                                                  );
                                                }
                                              } catch (e) {
                                                debugPrint("Error launching email: $e");
                                                try {
                                                  await launchUrl(
                                                    gmailWebUri,
                                                    mode: LaunchMode.externalApplication,
                                                  );
                                                } catch (_) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Unable to open email')),
                                                  );
                                                }
                                              }
                                            },
                                            child: Icon(
                                              Icons.email_outlined,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              const SliverToBoxAdapter(child: SizedBox(height: 20)),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CheckOutScreen(
                                        serviceId: service.id,
                                        provider: selectedProviderIndex == null
                                            ? null
                                            : providers[selectedProviderIndex!],
                                        // provider: providers[selectedProviderIndex!],
                                        serviceData: SelectedServiceData(
                                            serviceId: service.id,
                                            serviceThumbnail: service.thumbnailImage,
                                            serviceName: service.serviceName,
                                            price: selectedPackage.price.toString(),
                                            discountPrice: selectedPackage.price.toString(),
                                            discount: selectedPackage.discount.toString(),
                                            rating: service.averageRating.toString(),
                                            review: service.totalReviews.toString(),
                                            categoryName: service.category.name,
                                            earnUpTo: service.franchiseDetails.commission,
                                            serviceGST:service.gst.toString(),
                                        ),
                                      ),
                                    ),
                                  );

                                },
                                child: Container(
                                  color:CustomColor.franchise,
                                  height: 56,
                                  child: Row(
                                    spacing: 8,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 22,),
                                      Text('Check Out',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  final serviceId = widget.serviceId;
                                  if (serviceId != null) {
                                    final shareUrl =
                                        'https://fetchtrue-service-page.vercel.app/?serviceId=$serviceId&userId=${userSession.userId}.';
                                    Share.share(
                                        'Check out this service on FetchTrue:\n$shareUrl');
                                  } else {
                                    showCustomToast('Please wait data is loading.');
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  color: CustomColor.franchise.withOpacity(0.1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share,
                                          color: CustomColor.franchise, size: 20),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.franchise,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        20.height
                      ],
                    );
                  }

                  if (providerState is ServiceWiseProviderSubscriberError) {
                    print('Provider Error ${providerState.message}');
                    return SizedBox.shrink();
                  }

                  return SizedBox.shrink();
                },
              );

            } else if (state is FranchiseServiceDetailsError) {
              print(state.message);

              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class DiamondIcon extends StatelessWidget {
  final String iconUrl;
  const DiamondIcon({super.key, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45°
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFD8DEEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Transform.rotate(
          angle: -0.785398,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.network(
              iconUrl,
              // color: Colors.blue,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _infoTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}


class RightTrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0); // left-top straight
    path.lineTo(size.width - 20, 0); // right-top cut
    path.lineTo(size.width, size.height); // right-bottom slant
    path.lineTo(0, size.height); // left-bottom straight
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
