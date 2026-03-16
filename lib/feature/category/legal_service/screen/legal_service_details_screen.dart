import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/feature/category/marketing/screen/franchise_commission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/custom_log_emoji.dart';
import '../../../../core/costants/custom_logo.dart';
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
import '../../../rating_review/widget/review_rating_card_widget.dart';
import '../../../service/repository/service_review_service.dart';
import '../bloc/legal_service_details/legal_service_details_bloc.dart';
import '../bloc/legal_service_details/legal_service_details_event.dart';
import '../bloc/legal_service_details/legal_service_details_state.dart';
import '../repository/legal_service_details_repository.dart';
import '../widget/legal_documents_widget.dart';
import '../widget/legal_howIt_works_widget.dart';


class LegalServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const LegalServiceDetailsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  State<LegalServiceDetailsScreen> createState() => _LegalServiceDetailsScreenState();
}

class _LegalServiceDetailsScreenState extends State<LegalServiceDetailsScreen> {
  int _currentBannerIndex = 0;
  // int expandedIndex = -1;
  int expandedIndex = 0;
  int _selectedPackageIndex = 0;
  int? _expandedFranchiseModelIndex;

  int? selectedProviderIndex;
  bool showAllProviders = false;
  final ScrollController scrollController = ScrollController();
  final GlobalKey providerSectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context, listen: false);


    return MultiBlocProvider(
      providers: [
         BlocProvider(create: (_) => LegalServiceDetailsBloc(repository: LegalServiceDetailsRepository())..add(FetchLegalServiceDetails(widget.serviceId))),
        BlocProvider(create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
        )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),),
        BlocProvider(create: (_) => ServiceReviewBloc(ReviewService())..add(FetchServiceReviews(widget.serviceId)),),


      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<LegalServiceDetailsBloc, LegalServiceDetailsState>(
          builder: (context, state) {
            if (state is LegalServiceDetailsLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: CustomColor.marketing,
              ));
            } else if (state is LegalServiceDetailsLoaded) {
              final service = state.service;

              final selectedPackage = service.serviceDetails.packages[_selectedPackageIndex];

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
                                                // if (service.serviceDetails.franchiseOperatingModel.isNotEmpty)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: CustomColor.legal,
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    "₹ ${selectedPackage.discountedPrice.toStringAsFixed(0)}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),

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

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  service.serviceName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  service.category.name,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${CustomLogEmoji.star} ${service.averageRating}',
                                                style: TextStyle(color: Colors.grey.shade700),
                                              ),
                                              Text(
                                                '(${service.totalReviews}+ Reviews)',
                                                style: TextStyle(color: Colors.grey.shade700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      10.height,

                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: List.generate(service.keyValues.length, (index) {
                                          final data = service.keyValues[index];

                                          return CustomContainer(
                                            color: const Color(0xFFBC9958).withOpacity(0.15),
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                            margin: EdgeInsets.zero,

                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start, // 👈 left se start
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  data.icon,
                                                  height: 12,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons.image_not_supported_outlined,
                                                      size: 12,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),

                                                const SizedBox(width: 6),

                                                Text(
                                                  data.value,
                                                  softWrap: false,
                                                  overflow: TextOverflow.visible,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),

                                      15.height,

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CustomContainer(
                                              border: true,
                                              color: Colors.white,
                                              margin: EdgeInsets.zero,
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text('Starting From',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '\u20B9 ${selectedPackage.discountedPrice.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Row(
                                                    spacing: 10,
                                                    children: [
                                                      CustomAmountText(amount: '${selectedPackage.price.toStringAsFixed(0)}',isLineThrough: true, fontSize: 14,color: Colors.grey.shade700),
                                                      CustomContainer(
                                                        color: Color(0xFFBC9958),
                                                        margin: EdgeInsets.zero,
                                                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                                        child: Text('${selectedPackage.discount}% OFF',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.white),),)
                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: CustomContainer(
                                              border: true,
                                              color: Colors.white,
                                              margin: EdgeInsets.zero,
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Time Required',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '${service.serviceDetails.timeRequired.first.range}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '${service.serviceDetails.timeRequired.first.parameters}',
                                                    style: TextStyle(fontSize: 14,
                                                        color:Colors.grey.shade700,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      15.height,
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                color: CustomColor.legal, width: 0.3)),
                                        padding: const EdgeInsets.all(16),
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
                                                      fontSize: 14,
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
                                            color: CustomColor.legal,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ...service.serviceDetails.benefits.map(
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

                              if (service.serviceDetails.aboutUs.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("About Us",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.legal,
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
                                              borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(highlightImg),fit: BoxFit.cover)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.whyChooseUs.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        15.height,
                                        Text('Why Choose Us?',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: CustomColor.legal),),
                                        10.height,
                                        Text('Trusted by hundreds of businesses across India for reliable and professional legal services.'),
                                        10.height,
                                        GridView.builder(
                                          itemCount: service.serviceDetails.whyChooseUs.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1/0.8,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10
                                          ),
                                          itemBuilder: (context, index) {
                                            final wcu = service.serviceDetails.whyChooseUs[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: CustomColor.legal,width: 1)
                                              ),
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(wcu.title, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 2,),
                                                  Expanded(child: Image.network(wcu.icon,)),
                                                  Text(wcu.description, style: TextStyle(color: Colors.grey, fontSize: 12),textAlign: TextAlign.center,maxLines: 3,),
                                                ],
                                              ),
                                            );
                                          },)
                                      ],
                                    ),
                                  ),
                                ),

                              if(service.serviceDetails.howItWorks.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        15.height,
                                        Text("How it works?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.legal)),
                                        15.height,
                                        LegalHowItWorksWidget(
                                          items: service.serviceDetails.howItWorks,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.assuredByFetchTrue.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.black,
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


                              if(service.serviceDetails.packages.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pricing Plans",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.legal,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        SizedBox(
                                          height: 400,
                                          child: PageView.builder(
                                            itemCount: service.serviceDetails.packages.length,
                                            itemBuilder: (context, index) {
                                              final list = service.serviceDetails.packages[index];
                                              return  Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.08),
                                                      blurRadius: 12,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                padding: EdgeInsets.all(16),
                                                margin: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      spacing: 10,
                                                      children: [
                                                        CustomAmountText(amount: list.discountedPrice.toStringAsFixed(0),fontSize: 24,fontWeight: FontWeight.w500),
                                                        CustomAmountText(amount: list.price.toStringAsFixed(0),fontSize: 16,fontWeight: FontWeight.w400, color: Colors.grey.shade700,isLineThrough: true),
                                                        CustomContainer(
                                                          color: Color(0xFFBC9958),
                                                          margin: EdgeInsets.zero,
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          child: Text('${list.discount.toStringAsFixed(0)}% Off',style: TextStyle(color: Colors.white),),)
                                                      ],
                                                    ),
                                                    10.height,
                                                    Text('Basic', style: TextStyle(fontSize:24,fontWeight: FontWeight.w500),),

                                                    Text('Perfect for individuals and small businesses,',style: TextStyle(fontSize: 12),),
                                                    15.height,
                                                    Column(
                                                      children: List.generate(list.whatYouGet.length, (index) {
                                                        final listData = list.whatYouGet[index];
                                                        return Row(
                                                          spacing: 5,
                                                          children: [
                                                            Icon(Icons.check_circle_outline_outlined,size: 14,color: Colors.green,),
                                                            Text(listData, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),

                                                          ],
                                                        );
                                                      },),
                                                    ),

                                                    Spacer(),

                                                    Center(
                                                      child: CustomContainer(
                                                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                                          color: Color(0xFF5B3527),
                                                          child: Text('Get Started', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),),
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedPackageIndex = index;
                                                            });

                                                          }
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),


                              SliverToBoxAdapter(
                                child: LegalDocumentsWidget(
                                  weDeliver: service.serviceDetails.weDeliver,
                                  weRequired: service.serviceDetails.weRequired,
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
                                            color: CustomColor.legal,
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
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      begin: AlignmentGeometry.topCenter,
                                                                      end: AlignmentGeometry.bottomCenter,
                                                                      colors: [
                                                                    Colors.black54,
                                                                    Colors.transparent
                                                                  ])
                                                                ),
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
                                                                                .white,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w400),
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

                              if(providers.isEmpty)
                                SliverToBoxAdapter(
                                  child:Container(
                                    padding:  EdgeInsets.all(10.0),
                                    margin: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border(
                                        top: BorderSide(
                                          color: CustomColor.marketing,
                                          width: 1.5,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),

                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(CustomLogo.fetchTrueLogo),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'This Service Provided By Fetch True',
                                            style:
                                            TextStyle(fontSize: 16, color: CustomColor.aiHub,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if(providers.isNotEmpty)
                                SliverToBoxAdapter(
                                  key: providerSectionKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Choose Provider",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.legal,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text('Pick the right expert for your service', style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                                              ),

                                              Column(
                                                children: List.generate(
                                                  showAllProviders ? providers.length : 1,
                                                      (index) {
                                                    final provider = providers[index];

                                                    // final isSelected = selectedProviderIndex == index;
                                                    final isSelected = selectedProviderIndex == index ||
                                                        (selectedProviderIndex == null && index == 0);

                                                    return CustomContainer(
                                                      color: Colors.white.withOpacity(0.5),
                                                      border: true,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Column(
                                                                      spacing: 5,
                                                                      children: [
                                                                        CircleAvatar(
                                                                          radius: 25,
                                                                          backgroundColor: CustomColor
                                                                              .marketing.withOpacity(0.1),
                                                                          backgroundImage:
                                                                          provider.storeInfo.logo != null &&
                                                                              provider.storeInfo.logo!
                                                                                  .isNotEmpty
                                                                              ? NetworkImage(provider.storeInfo.logo!)
                                                                              : null,
                                                                          child: (provider.storeInfo.logo == null ||
                                                                              provider.storeInfo.logo!.isEmpty)
                                                                              ? const Icon(Icons.store,
                                                                              color: Colors.white)
                                                                              : null,
                                                                        ),
                                                                        CustomContainer(
                                                                          margin: EdgeInsets.zero,
                                                                          color: Colors.green,
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 10),
                                                                          child:  Text('Promoted',
                                                                            style: TextStyle(
                                                                                fontSize: 10,color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                                10.width,
                                                                Expanded(
                                                                  child: Column(
                                                                    spacing: 5,
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        spacing: 10,
                                                                        children: [
                                                                          Text(
                                                                            provider.storeInfo.storeName,
                                                                            style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                          Icon(Icons.verified,color: CustomColor.appColor,size: 14,)
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        '⭐ ${provider.averageRating}, (${provider.totalReviews} reviews)',
                                                                        style: const TextStyle(fontSize: 12),
                                                                      ),
                                                                      CustomContainer(
                                                                        margin: EdgeInsets.zero,
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal: 10),
                                                                        child:  Text( provider.isStoreOpen == true ?
                                                                        'Available':'Close',
                                                                          style: TextStyle(
                                                                            fontSize: 10,),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Checkbox(
                                                            activeColor: Colors.green,
                                                            side: const BorderSide(
                                                              color: Colors.green,
                                                              width: 2,
                                                            ),
                                                            value: isSelected,
                                                            onChanged: (_) {
                                                              setState(() {
                                                                selectedProviderIndex = isSelected ? null : index;

                                                                if (selectedProviderIndex != null) {
                                                                  final selectedProvider = providers[selectedProviderIndex!];
                                                                  print("Selected Provider ID: ${selectedProvider.id}");
                                                                }
                                                              });
                                                            },
                                                          ),

                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),

                                              if(providers.length>1)
                                                Center(
                                                  child: CustomContainer(
                                                    color: CustomColor.legal,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 20, vertical: 4),
                                                    child: Text(
                                                      showAllProviders
                                                          ? 'See Less Provider'
                                                          : 'See All Provider',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        showAllProviders = !showAllProviders;
                                                      });

                                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                                        final context = providerSectionKey.currentContext;
                                                        if (context != null) {
                                                          Scrollable.ensureVisible(
                                                            context,
                                                            duration: const Duration(milliseconds: 500),
                                                            curve: Curves.easeInOut,
                                                            alignment: 0.5,
                                                          );
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),


                                            ],
                                          ),
                                        )
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
                                            color: CustomColor.legal,
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
                                                  color: Colors.black.withOpacity(0.08),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
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
                                            color: CustomColor.legal,
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
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
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

                              SliverToBoxAdapter(child: ReviewRatingCardWidget(color: CustomColor.legal,),),

                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:  BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white,width: 0.5),
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
                                          Text('Contact With',style: TextStyle(color: CustomColor.blackColor),),
                                          Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.blackColor,fontWeight: FontWeight.w600),),
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
                                              color: CustomColor.legal,
                                            ),
                                          ),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 50)),
                            ],
                          ),
                        ),

                        Container(
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CheckOutScreen(
                                          serviceId: service.id,
                                          provider: providers.isEmpty
                                              ? null
                                              : providers[selectedProviderIndex ?? 0],
                                          // provider: selectedProviderIndex == null
                                          //     ? null
                                          //     : providers[selectedProviderIndex!],
                                          serviceData: SelectedServiceData(
                                              serviceId: service.id,
                                              serviceThumbnail: service.thumbnailImage,
                                              serviceName: service.serviceName,
                                              price: selectedPackage.price.toString(),
                                              discountPrice: selectedPackage.discountedPrice.toString(),
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
                                    color:CustomColor.legal,
                                    height: double.infinity,
                                    child: Row(
                                      spacing: 8,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 22,),
                                        Text('Check Out',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,),
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
                                    height: double.infinity,
                                    color: CustomColor.legal.withOpacity(0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share,
                                            color: CustomColor.legal, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.legal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        20.height,
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

            } else if (state is LegalServiceDetailsError) {
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
