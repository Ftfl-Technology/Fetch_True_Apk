import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
import '../../marketing/screen/franchise_commission_screen.dart';
import '../bloc/ai_hub_service_details/ai_hub_service_details_bloc.dart';
import '../bloc/ai_hub_service_details/ai_hub_service_details_event.dart';
import '../bloc/ai_hub_service_details/ai_hub_service_details_state.dart';
import '../repository/ai_hub_service_details_repository.dart';
import '../widget/ai_hub_documents_widget.dart';

class AiHubServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const AiHubServiceDetailsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  State<AiHubServiceDetailsScreen> createState() => _AiHubServiceDetailsScreenState();
}

class _AiHubServiceDetailsScreenState extends State<AiHubServiceDetailsScreen> {
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
        BlocProvider(
        create: (_) => AiHubServiceDetailsBloc(repository: AiHubServiceDetailsRepository())
      ..add(FetchAiHubServiceDetails(widget.serviceId))),

        BlocProvider(
          create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
          )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),
        ),
        BlocProvider(create: (_) => ServiceReviewBloc(ReviewService(),)..add(FetchServiceReviews(widget.serviceId))),

      ],
      child: Scaffold(
        backgroundColor: Color(0xFFDBE6EB),
        body: BlocBuilder<AiHubServiceDetailsBloc, AiHubServiceDetailsState>(
          builder: (context, state) {
            if (state is AiHubServiceDetailsLoading) {
              return  Center(child: CircularProgressIndicator(color: CustomColor.marketing,));
            }
            else if (state is AiHubServiceDetailsLoaded) {
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
                        Expanded(child: CustomScrollView(
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
                                                    color: CustomColor.aiHub,
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
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:  BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white,width: 0.5)
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(service.serviceName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                                              Text(service.category.name, style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                                  const SizedBox(width: 3),
                                                  Text("${service.averageRating}",
                                                      style:  TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                                                ],
                                              ),
                                              Text('(${service.totalReviews}+ reviews)', style: TextStyle(color: Colors.grey.shade700),)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    20.height,

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Starting Form',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                                        Row(
                                          spacing: 5,
                                          children: [
                                            CustomAmountText(amount: selectedPackage.discountedPrice.toStringAsFixed(0),fontSize: 20,fontWeight: FontWeight.w500 ),
                                            CustomAmountText(amount: selectedPackage.price.toStringAsFixed(0),fontSize: 12,fontWeight: FontWeight.w400 , isLineThrough: true),
                                            Text('(${selectedPackage.discount}% Off)',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                                          ],
                                        ),
                                      ],
                                    ),

                                    10.height,


                                    if(service.keyValues.isNotEmpty)
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: service.keyValues.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1/0.5,
                                            crossAxisSpacing: 5,mainAxisSpacing: 5
                                        ),
                                        itemBuilder: (context, index) {
                                          final tag = service.keyValues[index];
                                          return Row(
                                            spacing: 5,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.network(tag.icon,height: 12,),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('${tag.key}',style: TextStyle(fontSize: 10,color: Colors.grey.shade700),),
                                                    Text('${tag.value}', style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },),

                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF).withOpacity(0.5),
                                borderRadius:  BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],

                              ),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(10),
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
                                            fontWeight: FontWeight.w500
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
                                        Icon(Icons.arrow_forward_ios, size: 14,color: Colors.grey.shade700,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),


                            if (service.serviceDetails.benefits.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    10.height,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text("Benefits", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColor.aiHub)),
                                    ),

                                    ...service.serviceDetails.benefits.map(
                                          (b) => Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius:  BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white,width: 0.5)
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.all(10),
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

                            if (service.serviceDetails.aboutUs.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    10.height,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text("About Us", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColor.aiHub)),
                                    ),
                                    ...service.serviceDetails.aboutUs.map(
                                          (b) => Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius:  BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white,width: 0.5)
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.all(10),
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
                                              borderRadius:  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              image: DecorationImage(image: NetworkImage(highlightImg),fit: BoxFit.fill)
                                          ),
                                        );
                                      },),
                                  ),
                                ),
                              ),

                            if (service.serviceDetails.whyChooseUs.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    10.height,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text("Why Choose Us?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.aiHub)),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:  BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white,width: 0.5)
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      child: MasonryGridView.count(
                                        crossAxisCount: 1,
                                        mainAxisSpacing: 15,
                                        crossAxisSpacing: 15,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: service.serviceDetails.whyChooseUs.length,
                                        itemBuilder: (context, index) {
                                          final data = service.serviceDetails.whyChooseUs[index];

                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.5),
                                                borderRadius:  BorderRadius.circular(10),
                                                border: Border.all(color: Colors.white,width: 0.5)
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  spacing: 2,
                                                  children: [
                                                    CircleAvatar(radius: 10,
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
                                                  ],
                                                ),
                                                6.height,
                                                Text(
                                                  data.description,
                                                  textAlign: TextAlign.start,
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
                                    ),
                                  ],
                                ),
                              ),

                            if (service.serviceDetails.packages.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Package", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.aiHub)),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 400,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: service.serviceDetails.packages.length,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.zero,
                                          itemBuilder:(context, index) {

                                            final pkg = service.serviceDetails.packages[index];
                                            final bool isSelected = _selectedPackageIndex == index;

                                            return  GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedPackageIndex = index;
                                                });

                                              },
                                              child: Container(
                                                width: 250,
                                                decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.5),
                                                    borderRadius:  BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.white,width: 0.5)
                                                ),
                                                padding: const EdgeInsets.all(15),
                                                margin: const EdgeInsets.only(right: 20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(pkg.name, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,),),
                                                        20.height,
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Includes', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                            15.height,
                                                            Column(
                                                              spacing: 10,
                                                              children: List.generate(pkg.whatYouGet.length,
                                                                    (index) {
                                                                  final list = pkg.whatYouGet[index];
                                                                  return Row(
                                                                    spacing: 5,
                                                                    children: [
                                                                      Icon(Icons.circle,color: Colors.grey.shade700,size: 5,),
                                                                      Text('${list}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                                                                    ],
                                                                  );
                                                                },),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          spacing: 5,
                                                          children: [
                                                            CustomAmountText(amount: '${pkg.discountedPrice.toStringAsFixed(0)}', fontSize: 16,fontWeight: FontWeight.w600,color: CustomColor.aiHub),
                                                            CustomAmountText(amount: '${pkg.price.toStringAsFixed(0)}', fontSize: 10,fontWeight: FontWeight.w600,color: Colors.grey.shade700, isLineThrough: true),
                                                            Text('(${pkg.discount}% Off)', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green,fontSize: 10),),
                                                          ],
                                                        ),
                                                        Text('Per Month', style: TextStyle(fontSize: 8,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        15.height,
                                                        Container(
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: CustomColor.aiHub,
                                                          ),
                                                          padding: EdgeInsets.symmetric(vertical: 5),
                                                          child: Center(child: Text('Get It Now', style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),)),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },),
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                            SliverToBoxAdapter(child: AiHubDocumentsWidget(
                              serviceDetails: service.serviceDetails,
                            ),),


                            if (service.serviceDetails.howItWorks.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        "How It Works?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.aiHub,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        children: List.generate(
                                          service.serviceDetails.howItWorks.length,
                                              (index) {
                                            final step = service.serviceDetails.howItWorks[index];
                                            final bool isEven = index % 2 == 0;
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.5),
                                                  borderRadius:  BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.white,width: 0.5)
                                              ),
                                              padding: const EdgeInsets.all(15),
                                              margin: EdgeInsets.only(
                                                left: isEven ? 10 : 40,
                                                right: isEven ? 40 : 10,
                                                bottom: 12,
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(step.icon.toString(),height: 21,),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          step.title,
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          step.description,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
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
                                  decoration:  BoxDecoration(
                                    // color: Color(0xFF1D4699)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Assured By Fetch True",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColor.aiHub,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      MasonryGridView.count(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        itemCount: service.serviceDetails.assuredByFetchTrue.length,
                                        itemBuilder: (context, index) {
                                          final item = service.serviceDetails.assuredByFetchTrue[index];

                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5), // 50% opacity
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.white, width: 0.5),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  item.icon,
                                                  height: 30,
                                                ),
                                                10.width,
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        item.description,
                                                        style:  TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey.shade700,
                                                        ),
                                                      ),
                                                    ],
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



                            if (service.serviceDetails.termsAndConditions.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Terms & Conditions', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: CustomColor.aiHub),),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius:  BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white,width: 0.5)
                                        ),
                                        padding: const EdgeInsets.all(16),
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
                                          },),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if(providers.isEmpty)
                              SliverToBoxAdapter(
                                child:Container(
                                  padding: const EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 4,
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
                                child:Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Choose Provider',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.aiHub),
                                      ),
                                      SizedBox(height: 10),
                                      AnimatedSize(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Pick the right expert for your service',
                                                  style:
                                                  TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                                ),
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
                                                  color: CustomColor.aiHub,
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
                                        ),
                                      ),
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
                                          color: CustomColor.aiHub,
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
                                                              color: Colors.black.withOpacity(0.35),
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


                            if (service.serviceDetails.faq.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("FAQs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.aiHub)),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius:  BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white,width: 0.5)
                                        ),
                                        padding: const EdgeInsets.all(15),
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


                            SliverToBoxAdapter(child: ReviewRatingCardWidget(color: CustomColor.aiHub,cardColor:  Colors.white.withOpacity(0.5),),),

                            SliverToBoxAdapter(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:  BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white,width: 0.5)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Contact With',style: TextStyle(color: CustomColor.aiHub),),
                                        Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.aiHub,fontWeight: FontWeight.w600),),
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

                            const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          ],
                        )),

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
                                    color:CustomColor.aiHub,
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
                                    color: CustomColor.aiHub.withOpacity(0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share,
                                            color: CustomColor.aiHub, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.aiHub,
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

            } else if (state is AiHubServiceDetailsError) {
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
