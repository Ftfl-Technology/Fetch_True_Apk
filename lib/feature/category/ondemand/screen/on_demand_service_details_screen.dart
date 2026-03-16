
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/custom_log_emoji.dart';
import '../../../../core/widgets/custom_amount_text.dart';
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
import '../../finance/model/finance_service_details_model.dart' hide CommonItem;
import '../../marketing/screen/franchise_commission_screen.dart';
import '../bloc/on_demand_service_details/on_demand_service_details_bloc.dart';
import '../bloc/on_demand_service_details/on_demand_service_details_event.dart';
import '../bloc/on_demand_service_details/on_demand_service_details_state.dart';
import '../repository/on_demand_service_details_repository.dart';
import 'package:dotted_border/dotted_border.dart';

import '../widget/on_demand_documents_widget.dart';




class OnDemandServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const OnDemandServiceDetailsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  State<OnDemandServiceDetailsScreen> createState() => _OnDemandServiceDetailsScreenState();
}

class _OnDemandServiceDetailsScreenState extends State<OnDemandServiceDetailsScreen> {
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
        create: (_) => OnDemandServiceDetailsBloc(repository: OnDemandServiceDetailsRepository())
      ..add(FetchOnDemandServiceDetails(widget.serviceId))),

        BlocProvider(
          create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
          )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),
        ),
        BlocProvider(create: (_) => ServiceReviewBloc(ReviewService())..add(FetchServiceReviews(widget.serviceId)),),

      ],
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: BlocBuilder<OnDemandServiceDetailsBloc, OnDemandServiceDetailsState>(
          builder: (context, state) {
            if (state is OnDemandServiceDetailsLoading) {
              return  Center(child: CircularProgressIndicator(color: CustomColor.marketing,));
            } else if (state is OnDemandServiceDetailsLoaded) {
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
                                      children: [
                                        Stack(
                                          alignment: AlignmentGeometry.bottomCenter,
                                          children: [
                                            Column(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,

                                                    child: CarouselSlider(
                                                      options: CarouselOptions(
                                                        viewportFraction: 1.0,
                                                        autoPlay: service.bannerImages.length > 1,
                                                        autoPlayInterval: const Duration(seconds: 3),
                                                        autoPlayAnimationDuration:
                                                        const Duration(milliseconds: 800),
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

                                                      items: service.bannerImages.map((imageUrl) {
                                                        return Container(
                                                          width: double.infinity,
                                                          height: double.infinity,

                                                          child: Image.network(
                                                            imageUrl,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Container(color: Colors.white),
                                                ),

                                              ],
                                            ),

                                            if (!isCollapsed)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.06),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),

                                                ],
                                              ),
                                              margin: EdgeInsets.symmetric(horizontal: 16),
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                                                Text('(${selectedPackage.discount.toStringAsFixed(0)}% Off)', style: TextStyle(fontSize: 12,color: CustomColor.redColor),)
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
                                                    20.height,


                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color:  Color(0xFF5B3527),width:0.4),
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
                                                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                                              style:  TextStyle(
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
                                                                  color: CustomColor.onDemand,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              SizedBox(width: 4),
                                                              Icon(Icons.arrow_forward_ios, size: 14,color: CustomColor.onDemand,),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )

                                                ],
                                              ),
                                            )
                                          ],
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
                                                      color: CustomColor.onDemand,
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


                              if (service.serviceDetails.benefits.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: "Benefits",),
                                        SizedBox(height: 10,),
                                        ...service.serviceDetails.benefits.map(
                                              (b) => Container(
                                            // margin: const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Html(
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
                                                )
                                              ],
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
                                        SymbolText(text: "About",),
                                        SizedBox(height: 10,),
                                        ...service.serviceDetails.aboutUs.map(
                                              (b) => Container(
                                            // margin: const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [

                                                Html(
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
                                                )
                                              ],
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
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: List.generate(service.serviceDetails.highlight.length,
                                            (index) {
                                          final highlightImg = service.serviceDetails.highlight[index];
                                          return  Container(
                                            height: dimensions.screenHeight*0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(image: NetworkImage(highlightImg,), fit: BoxFit.cover)
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
                                        SymbolText(text: "Why Choose Us ?",),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Column(
                                                children: List.generate(service.serviceDetails.whyChooseUs.length,
                                                      (index) {
                                                    final list = service.serviceDetails.whyChooseUs[index];
                                                    return ListTile(
                                                      minLeadingWidth: 0,
                                                      contentPadding: EdgeInsets.all(0),
                                                      minTileHeight: 0,

                                                      leading: Image.network(list.icon),
                                                      title: Text(list.title, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
                                                      subtitle: Text(list.description, style: TextStyle(fontSize: 12,color: Colors.grey.shade500),),
                                                    );
                                                  },),
                                              ),
                                            ],
                                          ),
                                        )
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
                                        SymbolText(text: 'Select Package'),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: dimensions.screenHeight*0.4,
                                          child: ListView.builder(
                                            itemCount: service.serviceDetails.packages.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder:(context, index) {
                                              final pkg = service.serviceDetails.packages[index];
                                              final bool isSelected = _selectedPackageIndex == index;

                                              return  GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedPackageIndex = index;
                                                  });
                                                },
                                                child: Stack(
                                                  alignment: AlignmentGeometry.center,
                                                  children: [
                                                    Container(
                                                      width: dimensions.screenHeight*0.3,
                                                      margin: EdgeInsets.all(10),
                                                      padding: EdgeInsets.only(bottom: 50),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFD56839),
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.06),
                                                            blurRadius: 6,
                                                            offset: const Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.06),
                                                              blurRadius: 6,
                                                              offset: const Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(pkg.name, style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w600),),
                                                            Divider(),

                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('Includes',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                                                                SizedBox(height: 10,),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  itemCount: pkg.whatYouGet.length,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  padding: EdgeInsets.zero,
                                                                  itemBuilder: (context, index) {
                                                                    final data = pkg.whatYouGet[index];
                                                                    return Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: Row(
                                                                        spacing: 5,
                                                                        children: [
                                                                          Icon(Icons.circle, color: Colors.grey.shade700,size: 5,),
                                                                          Text(data,style: TextStyle(fontSize: 12,color: Colors.grey.shade700),)
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },)
                                                              ],
                                                            ),
                                                            50.height,

                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  spacing: 10,
                                                                  children: [
                                                                    CustomAmountText(amount: pkg.discountedPrice.toStringAsFixed(0), fontSize: 16,isLineThrough: false,color: CustomColor.onDemand,fontWeight: FontWeight.w600),
                                                                    CustomAmountText(amount: pkg.price.toStringAsFixed(0), isLineThrough: true,color: Colors.grey.shade700),
                                                                    Text('(${pkg.discount}% OFF)', style: TextStyle(fontSize: 10,color: Colors.green),)
                                                                  ],
                                                                ),

                                                                Text('0-0 hrs Time',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),)
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        bottom: dimensions.screenHeight*0.03,
                                                        child: Text('Select Package',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),))
                                                  ],
                                                ),
                                              );
                                            },),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),


                              if(service.serviceDetails.include.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SymbolText(text: 'Included'),
                                      16.height,
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        // margin: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.06),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:service.serviceDetails.include.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            final data = service.serviceDetails.include[index];
                                            return  Html(
                                              data: data,
                                              style: {
                                                "p": Style(
                                                  margin: Margins.zero,
                                                  padding: HtmlPaddings.zero,
                                                  // lineHeight: LineHeight.number(1.4),
                                                ),
                                                "ul": Style(
                                                  padding: HtmlPaddings.only(left: 10),
                                                  // padding: HtmlPaddings.symmetric(horizontal: 12),
                                                ),
                                                "li": Style(
                                                  // margin: Margins.only(bottom: 6),
                                                  // listStylePosition: ListStylePosition.inside,
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
                                            );
                                          },),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if(service.serviceDetails.notInclude.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: 'Not Included'),
                                        16.height,
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          // margin: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:service.serviceDetails.notInclude.length,
                                            physics: NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              final data = service.serviceDetails.notInclude[index];
                                              return  Html(
                                                data: data,
                                                style: {
                                                  "p": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                    // lineHeight: LineHeight.number(1.4),
                                                  ),
                                                  "ul": Style(
                                                    padding: HtmlPaddings.only(left: 10),
                                                    // padding: HtmlPaddings.symmetric(horizontal: 12),
                                                  ),
                                                  "li": Style(
                                                    // margin: Margins.only(bottom: 6),
                                                    // listStylePosition: ListStylePosition.inside,
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
                                              );
                                            },),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              if(service.serviceDetails.howItWorks.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                         child: SymbolText(text: 'How It Works?'),
                                       ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.06),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: List.generate(
                                            service.serviceDetails.howItWorks.length,
                                                (index) {

                                              final list = service.serviceDetails.howItWorks[index];
                                              final indexNo = index + 1;

                                              final isLeft = indexNo % 2 != 0; // odd = left
                                              final isLast = index == service.serviceDetails.howItWorks.length - 1;

                                              return DottedBorder(
                                                options: CustomPathDottedBorderOptions(
                                                  strokeWidth: 1,
                                                  dashPattern: [6, 3],
                                                  color: CustomColor.onDemand,
                                                  customPath: (size) {
                                                    final path = Path();

                                                    // 🔝 Top border
                                                    path.moveTo(0, 0);
                                                    path.lineTo(size.width, 0);

                                                    // ⬅➡ Left or Right
                                                    if (isLeft) {
                                                      path.moveTo(0, 0);
                                                      path.lineTo(0, size.height);
                                                    } else {
                                                      path.moveTo(size.width, 0);
                                                      path.lineTo(size.width, size.height);
                                                    }

                                                    // 🔽 Bottom only for last item
                                                    if (isLast) {
                                                      path.moveTo(0, size.height);
                                                      path.lineTo(size.width, size.height);
                                                    }

                                                    return path;
                                                  },
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.white,
                                                    // borderRadius: BorderRadius.circular(10),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color: Colors.black.withOpacity(0.06),
                                                    //     blurRadius: 8,
                                                    //     spreadRadius: 1,
                                                    //     offset: const Offset(0, 3),
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        indexNo.toString(),
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              list.title,
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Text(
                                                              list.description,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.grey.shade700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                              SliverToBoxAdapter(child: SizedBox(height: 10,),),

                              if(service.serviceDetails.safetyAndAssurance.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: 'Safety & Assurance'),
                                        16.height,
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          // margin: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:service.serviceDetails.safetyAndAssurance.length,
                                            physics: NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              final data = service.serviceDetails.safetyAndAssurance[index];
                                              return  Html(
                                                data: data,
                                                style: {
                                                  "p": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                    // lineHeight: LineHeight.number(1.4),
                                                  ),
                                                  "ul": Style(
                                                    padding: HtmlPaddings.only(left: 10),
                                                    // padding: HtmlPaddings.symmetric(horizontal: 12),
                                                  ),
                                                  "li": Style(
                                                    // margin: Margins.only(bottom: 6),
                                                    // listStylePosition: ListStylePosition.inside,
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
                                              );
                                            },),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              if (service.serviceDetails.weRequired.isNotEmpty ||
                                  service.serviceDetails.weDeliver.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: OnDemandDocumentsWidget(
                                    weRequired: service.serviceDetails.weRequired
                                        .map((e) => CommonItem(title: e.title, description: e.description))
                                        .toList(),
                                    weDeliver: service.serviceDetails.weDeliver
                                        .map((e) => CommonItem(title: e.title, description: e.description))
                                        .toList(),
                                  ),
                                ),


                              if (service.serviceDetails.assuredByFetchTrue.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    decoration:  BoxDecoration(
                                        color: Color(0xFFF8EBE7)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: 'Assured By Fetch True'),
                                        const SizedBox(height: 18),

                                        MasonryGridView.count(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 14,
                                          crossAxisSpacing: 14,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: service.serviceDetails.assuredByFetchTrue.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            final data = service.serviceDetails.assuredByFetchTrue[index];

                                            return Stack(
                                              alignment: AlignmentGeometry.topCenter,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFFFBF7),
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(color: Colors.grey,width: 0.3),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.06),
                                                        blurRadius: 10,
                                                        offset: const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(top: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      20.height,
                                                      Text(
                                                        data.title,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        data.description,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Positioned(
                                                  child:   Image.network(
                                                    data.icon,
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.contain,
                                                  ),)
                                              ],
                                            );
                                          },
                                        )                          ],
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
                                        SymbolText(text: 'More Information'),


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
                                            color: CustomColor.business),
                                      ),
                                      SizedBox(height: 10),
                                      AnimatedSize(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
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
                                                    final isSelected = selectedProviderIndex == index;

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
                                                                    5.height,
                                                                    CustomContainer(
                                                                      margin: EdgeInsets.zero,
                                                                      color: Colors.green.shade400,
                                                                      padding: const EdgeInsets.symmetric(
                                                                          horizontal: 10),
                                                                      child:  Text( provider.isStoreOpen == true ?
                                                                      'Available':'Close',
                                                                        style: TextStyle(
                                                                            fontSize: 10,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                10.width,
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        provider.storeInfo.storeName,
                                                                        style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      Text(
                                                                        '⭐ ${provider.averageRating}, (${provider.totalReviews} reviews)',
                                                                        style: const TextStyle(fontSize: 12),
                                                                      ),
                                                                      Text(
                                                                        provider.storeInfo.address,
                                                                        style: TextStyle(
                                                                            fontSize: 12,
                                                                            color: Colors.grey.shade700),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Checkbox(
                                                            activeColor: Colors.green,
                                                            value: isSelected,
                                                            onChanged: (_) {
                                                              setState(() {
                                                                selectedProviderIndex = isSelected ? null : index;

                                                                if (selectedProviderIndex != null) {
                                                                  final selectedProvider = providers[selectedProviderIndex!]; // selected provider
                                                                  print("Selected Provider ID: ${selectedProvider.id}");
                                                                } else {
                                                                  print("No provider selected");
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
                                                  color: CustomColor.business,
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

                              if (service.serviceDetails.termsAndConditions.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: 'Terms & Conditions'),
                                        SizedBox(height: 10,),
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
                                            child: Column(
                                              children: [

                                                Html(data: service.serviceDetails.termsAndConditions.join(""),
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
                                              ],
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
                                        SymbolText(text: 'FAQs'),
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
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Column(
                                              children: [

                                                15.height,
                                                Column(
                                                  children: service.serviceDetails.faq.map((item) {
                                                    return Theme(
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
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              SliverToBoxAdapter(child: ReviewRatingCardWidget(color: CustomColor.onDemand,),),


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
                                          Text('Contact With',style: TextStyle(color: CustomColor.blackColor),),
                                          Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.onDemand,fontWeight: FontWeight.w600),),
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
                                          provider: selectedProviderIndex == null
                                              ? null
                                              : providers[selectedProviderIndex!],
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
                                    color:CustomColor.onDemand,
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
                                    color: CustomColor.onDemand.withOpacity(0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share,
                                            color: CustomColor.onDemand, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.onDemand,
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



            } else if (state is OnDemandServiceDetailsError) {
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


class SymbolText extends StatelessWidget {
  final String text; // Main text
  const SymbolText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text, // Main text
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CustomColor.onDemand,
            ),
          ),
        ],
      ),
    );
  }
}
