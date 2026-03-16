import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/costants/custom_logo.dart';
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
import '../bloc/marketing_service_details/marketing_service_details_bloc.dart';
import '../bloc/marketing_service_details/marketing_service_details_event.dart';
import '../bloc/marketing_service_details/marketing_service_details_state.dart';
import '../repository/marketing_service_details_repository.dart';
import '../widget/marketing_documents_widget.dart';
import '../../../rating_review/widget/review_rating_card_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'franchise_commission_screen.dart';


class MarketingDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const MarketingDetailsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  State<MarketingDetailsScreen> createState() => _MarketingDetailsScreenState();
}

class _MarketingDetailsScreenState extends State<MarketingDetailsScreen> {
  int _currentBannerIndex = 0;
  // int expandedIndex = -1;
  int expandedIndex = 0;
  int _selectedPackageIndex = 0;

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
        BlocProvider(create: (_) => MarketingServiceDetailsBloc(repository: MarketingServiceRepository())..add(FetchMarketingServiceDetails(widget.serviceId))),
        BlocProvider(create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
          )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),),

          BlocProvider(create: (_) => ServiceReviewBloc(ReviewService(),)..add(FetchServiceReviews(widget.serviceId))),
      ],
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<MarketingServiceDetailsBloc, MarketingServiceDetailsState>(
            builder: (context, state) {
              if (state is MarketingServiceDetailsLoading) {
                return  Center(child: CircularProgressIndicator(color: CustomColor.marketing,));
              } else if (state is MarketingServiceDetailsLoaded) {
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
                                      bool isCollapsed = top <= kToolbarHeight + MediaQuery.of(context).padding.top;

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
                                                    autoPlay: service.bannerImages.length > 1,
                                                    autoPlayInterval: const Duration(seconds: 3),
                                                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                                    autoPlayCurve: Curves.easeInOut,
                                                    enlargeCenterPage: false,
                                                    enableInfiniteScroll: service.bannerImages.length > 1,
                                                    pauseAutoPlayOnTouch: true,
                                                    onPageChanged: (index, reason) {
                                                      setState(() {
                                                        _currentBannerIndex = index;
                                                      });
                                                    },
                                                  ),
                                                  items: service.bannerImages.map((imageUrl) {
                                                    return Image.network(
                                                      imageUrl,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    );
                                                  }).toList(),
                                                ),


                                                if(service.bannerImages.length > 1)
                                                  Positioned(
                                                    bottom: 12,
                                                    left: 15,
                                                    right: 0,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: List.generate(
                                                        service.bannerImages.length,
                                                            (index) => AnimatedContainer(
                                                          duration: const Duration(milliseconds: 300),
                                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                                          height: 6,
                                                          width: _currentBannerIndex == index ? 18 : 6,
                                                          decoration: BoxDecoration(
                                                            color: _currentBannerIndex == index
                                                                ? CustomColor.marketing
                                                                : Colors.white.withOpacity(0.5),
                                                            borderRadius: BorderRadius.circular(10),
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
                                              opacity: isCollapsed ? 0.0 : 1.0, // hide on collapse
                                              child: CircleAvatar(
                                                backgroundColor: Colors.black.withOpacity(0.1),
                                                radius: 18,
                                                child: IconButton(
                                                  icon:  Icon(Icons.arrow_back, color: CustomColor.marketing),
                                                  onPressed: () => Navigator.of(context).pop(),
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
                                              opacity: isCollapsed ? 1.0 : 0.0, // show only when collapsed
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // CircleAvatar(child: Center(child: Icon(Icons.arrow_back_ios))),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(service.serviceName,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black)),
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.star, color: Colors.amber, size: 14),
                                                            const SizedBox(width: 3),
                                                            Text("${service.averageRating} (${service.totalReviews})",
                                                                style: const TextStyle(fontSize: 12, color: Colors.black)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (service.serviceDetails.packages.isNotEmpty)
                                                    Container(
                                                      padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: CustomColor.marketing,
                                                        borderRadius: BorderRadius.circular(8),
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(service.serviceName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                                  Text(service.category.name, style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),
                                                  const SizedBox(height: 5),
                                                  Text('Starting -', style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),

                                                  Row(
                                                    spacing: 5,
                                                    children: [
                                                      CustomAmountText(amount: '${selectedPackage.discountedPrice.toStringAsFixed(0)}', fontSize: 16,fontWeight: FontWeight.w500),
                                                      CustomAmountText(amount: '${selectedPackage.price.toStringAsFixed(0)}',color: Colors.grey.shade700, fontSize: 12,fontWeight: FontWeight.w500, isLineThrough: true),
                                                      Text('(${selectedPackage.discount}% Off)', style: TextStyle(fontSize: 12,color: CustomColor.marketing),)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('${CustomLogEmoji.star} ${service.averageRating}',style: TextStyle(color: Colors.grey.shade700),),
                                                Text('(${service.totalReviews}+ Reviews)',style: TextStyle(color: Colors.grey.shade700),),
                                              ],
                                            )
                                          ],
                                        ),
                                        10.height,

                                        if(service.keyValues.isNotEmpty)
                                          SizedBox(
                                            width: double.infinity,
                                            child: Wrap(
                                              spacing: dimensions.screenWidth*0.02,
                                              runSpacing: 6,
                                              alignment: WrapAlignment.start,
                                              children: List.generate(
                                                service.keyValues.length,
                                                    (index) {
                                                  final keyValue = service.keyValues[index];
                                            
                                                  return CustomContainer(
                                                    color: Color(0xFF2164F4).withOpacity(0.1),
                                                    margin: EdgeInsets.zero,
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start, // ✔ left
                                                      children: [
                                                        Image.network(keyValue.icon, height: 15),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          keyValue.value,
                                                          style: const TextStyle(fontSize: 10),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        25.height,


                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFF8EF),
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
                                                        fontSize: 13,
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseCommissionScreen(commission: service.franchiseDetails.commission,t_and_c: service.franchiseDetails.termsAndConditions,),));
                                                },
                                                child: Row(
                                                  children:  [
                                                    Text(
                                                      'T&C',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Icon(Icons.arrow_forward_ios, size: 14,color: CustomColor.marketing,),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                                const SliverToBoxAdapter(child: SizedBox(height: 5)),


                                if (service.serviceDetails.benefits.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Benefits", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColor.marketing)),
                                          SizedBox(height: 10,),
                                          ...service.serviceDetails.benefits.map(
                                                (b) => Container(
                                              // margin: const EdgeInsets.only(bottom: 8),
                                                  padding: const EdgeInsets.all(16),
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
                                                  child: Html(
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
                                          Text("About Us", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColor.marketing)),
                                          SizedBox(height: 10,),
                                          ...service.serviceDetails.aboutUs.map(
                                                (b) => Container(
                                              // margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(16),
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
                                                  child: Html(
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                if(service.serviceDetails.highlight.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: List.generate(service.serviceDetails.highlight.length,
                                              (index) {
                                            final highlightImg = service.serviceDetails.highlight[index];
                                            return  Container(
                                              height: dimensions.screenHeight*0.2,
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
                                                  image: DecorationImage(image: NetworkImage(highlightImg))
                                              ),
                                            );
                                          },),
                                      ),
                                    ),
                                  ),

                                if (service.serviceDetails.whyChooseUs.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Why Choose Us ?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.marketing)),
                                          const SizedBox(height: 10),
                                          MasonryGridView.count(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: service.serviceDetails.whyChooseUs.length,
                                            itemBuilder: (context, index) {
                                              final data = service.serviceDetails.whyChooseUs[index];

                                              return Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    topRight: Radius.circular(20),
                                                  ),
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: CustomColor.marketing,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min, // 🔥 important
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(data.icon),
                                                    ),
                                                    8.height,
                                                    Text(
                                                      data.title,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey.shade700,
                                                      ),
                                                    ),
                                                    6.height,
                                                    Text(
                                                      data.description,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                if (service.serviceDetails.howItWorks.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("How It Works?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.marketing)),
                                          const SizedBox(height: 10),
                                          Column(
                                            children: service.serviceDetails.howItWorks.asMap().entries.map((entry) {

                                              final int index = entry.key + 1;
                                              final item = entry.value;
                                              return Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 18.0),
                                                    child: Stack(
                                                      alignment: AlignmentDirectional.topStart,
                                                      children: [
                                                        Container(
                                                          height: dimensions.screenHeight*0.1,
                                                          width: dimensions.screenHeight*0.1,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(color: CustomColor.marketing,width: 2)
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding:  EdgeInsets.only(left:dimensions.screenHeight*0.095),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              10.height,
                                                              Padding(
                                                                padding:  EdgeInsets.only(left: dimensions.screenHeight*0.01,top: dimensions.screenHeight*0.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Expanded(child: Text(item.title,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),)),

                                                                    Container(
                                                                        padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.015,vertical: dimensions.screenHeight*0.002),
                                                                        decoration: BoxDecoration(
                                                                            color: CustomColor.marketing,
                                                                            borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                            )
                                                                        ),
                                                                        child: Text('STEP 0${index}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600, color: Colors.white),))
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(color: CustomColor.marketing,height: 1.7,),
                                                              Padding(
                                                                padding:  EdgeInsets.only(left: dimensions.screenHeight*0.01),
                                                                child: Text(item.description,style: TextStyle(fontSize: 12.2,color: Colors.grey.shade700),),
                                                              )
                                                            ],
                                                          ),
                                                        ),

                                                        Positioned(
                                                          top: dimensions.screenHeight*0.034,left: dimensions.screenHeight*0.053,
                                                          child: Container(
                                                            height: dimensions.screenHeight*0.09,
                                                            width: dimensions.screenHeight*0.05,
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                shape: BoxShape.rectangle
                                                            ),
                                                          ),
                                                        ),

                                                        Positioned(
                                                          top: dimensions.screenHeight*0.01,left: dimensions.screenHeight*0.01,
                                                          child: Container(
                                                            height: dimensions.screenHeight*0.08,
                                                            width: dimensions.screenHeight*0.08,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                              image: DecorationImage(
                                                                image: NetworkImage(item.icon),
                                                                fit: BoxFit.cover,
                                                              ),
                                                              boxShadow:  [
                                                                BoxShadow(
                                                                  color: Colors.black12,
                                                                  blurRadius: 6,
                                                                  offset: Offset(0, 1),
                                                                ),
                                                              ],
                                                            ),
                                                          ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Padding(
                                                      padding:  EdgeInsets.only(left: dimensions.screenHeight*0.039),
                                                      child: Icon(Icons.arrow_downward, color:CustomColor.marketing,),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                if (service.serviceDetails.assuredByFetchTrue.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage("assets/image/marketing_assured_by_img.jpg",), // optional
                                            fit: BoxFit.cover,
                                            opacity: 0.1
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Assured By Fetch True",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: CustomColor.marketing,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 18),

                                          Column(
                                            children: List.generate(
                                              service.serviceDetails.assuredByFetchTrue.length,
                                                  (index) {
                                                final item =
                                                service.serviceDetails.assuredByFetchTrue[index];
                                                return AssuredZigZagCard(
                                                  item: item,
                                                  isLeft: index.isEven,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                if (service.serviceDetails.packages.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Packages", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.marketing)),
                                          const SizedBox(height: 10),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: List.generate(
                                                service.serviceDetails.packages.length,
                                                    (index) {
                                                  final pkg = service.serviceDetails.packages[index];
                                                  final bool isSelected = _selectedPackageIndex == index;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedPackageIndex = index;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: dimensions.screenHeight * 0.3,
                                                      margin: const EdgeInsets.only(right: 10, left: 5, bottom: 20),
                                                      padding: EdgeInsets.all(15),

                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: isSelected
                                                                ? CustomColor.marketing
                                                                : CustomColor.marketing,
                                                            width: isSelected ? 8 : 8,
                                                          ),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: isSelected
                                                                ? CustomColor.marketing.withOpacity(0.25)
                                                                : Colors.black.withOpacity(0.06),
                                                            blurRadius: 10,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ],
                                                        borderRadius: BorderRadius.circular(10)
                                                      ),

                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          15.height,
                                                          Text('${pkg.name} Plan',
                                                            style: TextStyle(
                                                              color: Colors.grey.shade700,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          10.height,


                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Colors.white,
                                                                border: Border.all(color: Color(0xFFC68D4C))
                                                            ),
                                                            padding: EdgeInsets.all(10),
                                                            margin: EdgeInsets.all(10),
                                                            child: Column(
                                                              spacing: 10,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  spacing: 10,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text('\u20B9 ${pkg.price.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey.shade700,fontSize: 12, decoration: TextDecoration.lineThrough),),
                                                                    Text('(${pkg.discount.toStringAsFixed(0)}% Off)', style: TextStyle(fontSize: 12, color: CustomColor.marketing),)
                                                                  ],
                                                                ),
                                                                Center(child: Text('\u20B9 ${pkg.discountedPrice.toStringAsFixed(0)}', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),
                                                                Center(child: Text('Onwards', style: TextStyle(fontSize:8,color: Colors.grey.shade700,),)),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),

                                                          Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'What You Get -',
                                                                style: TextStyle(
                                                                  color: Colors.grey.shade700,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 8),

                                                              ...pkg.whatYouGet.map(
                                                                    (data) => Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal: 8, vertical: 4),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Icon(Icons.check,
                                                                          color: Colors.green, size: 16),
                                                                      const SizedBox(width: 6),
                                                                      Expanded(
                                                                        child: Text(
                                                                          data,
                                                                          style: const TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                if (service.serviceDetails.weDeliver.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding:  EdgeInsets.all(16.0),
                                      child: MarketingDocumentsWidget(
                                        weDeliver: service.serviceDetails.weDeliver,
                                        weRequired: service.serviceDetails.weRequired,
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
                                              color: CustomColor.marketing,
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          Column(
                                            children: List.generate(
                                              service.serviceDetails.moreInfo.length,
                                                  (index) {
                                                final item =
                                                service.serviceDetails.moreInfo[index];
                                                final bool isExpanded = expandedIndex == index;

                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      expandedIndex = isExpanded ? -1 : index;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 10.0),
                                                    child: AnimatedSize(
                                                      duration: const Duration(milliseconds: 400),
                                                      curve: Curves.easeInOut,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
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
                                                                      Colors.black.withOpacity(0.4),
                                                                      Colors.transparent,
                                                                    ])
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned.fill(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(
                                                                    12, 12, 12, 20,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        item.title,
                                                                        style:  TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),
                                                                      ),
                                                                      if (isExpanded) ...[
                                                                        const SizedBox(height: 6),
                                                                        Text(
                                                                          item.description,
                                                                          style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.w500),
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
                                        Text('Choose Provider', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: CustomColor.marketing),),
                                        SizedBox(height: 10,),
                                        Container(
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
                                                      color: Colors.white,
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
                                                  color: CustomColor.marketing,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 4),
                                                  child: Text(
                                                    showAllProviders
                                                        ? 'See Less Providers'
                                                        : 'See All Providers',
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
                                          Text('Terms & Conditions', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: CustomColor.marketing),),
                                          SizedBox(height: 10,),
                                          Container(
                                            padding: EdgeInsets.all(16),
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
                                              child: Html(data: service.serviceDetails.termsAndConditions.join(""),
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
                                              )),
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
                                          Text("FAQs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.marketing)),
                                          const SizedBox(height: 10),
                                          Container(
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
                                              children: service.serviceDetails.faq.map((item) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(
                                                      dividerColor: Colors.transparent,
                                                    ),
                                                    child: ExpansionTile(
                                                      tilePadding: EdgeInsets.zero,
                                                      childrenPadding: EdgeInsets.zero,
                                                      expandedAlignment: Alignment.centerLeft,
                                                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                                      visualDensity: VisualDensity.compact,
                                                      collapsedShape: const RoundedRectangleBorder(
                                                        side: BorderSide.none,
                                                      ),
                                                      shape: const RoundedRectangleBorder(
                                                        side: BorderSide.none,
                                                      ),

                                                      title: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(item.question, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                      ),

                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2),
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

                                SliverToBoxAdapter(child: ReviewRatingCardWidget(color: CustomColor.marketing),),

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
                                            if(service.serviceDetails.connectWith.isNotEmpty)
                                            Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.marketing,fontWeight: FontWeight.w600),),
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

                                const SliverToBoxAdapter(child: SizedBox(height: 100)),
                              ],
                            ),
                          ),

                          Container(
                            height: 57,
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
                                      color:CustomColor.marketing,
                                      height: double.infinity,
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
                                      height: double.infinity,
                                      color: CustomColor.marketing.withOpacity(0.1),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.share,
                                              color: CustomColor.marketing, size: 20),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Share',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: CustomColor.marketing,
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

              } else if (state is MarketingServiceDetailsError) {
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

class AssuredZigZagCard extends StatelessWidget {
  final dynamic item;
  final bool isLeft;

  const AssuredZigZagCard({
    super.key,
    required this.item,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Stack(
        alignment:
        isLeft ? Alignment.centerLeft : Alignment.centerRight,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: isLeft ? 28 : 0,
              right: isLeft ? 0 : 28,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF7),
              borderRadius: BorderRadius.circular(14),
              border: Border(
                top: BorderSide(
                  color: CustomColor.marketing,
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: DiamondIcon(iconUrl: item.icon),
          ),
        ],
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
          border: Border.all(
            color: Colors.white
          ),
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
