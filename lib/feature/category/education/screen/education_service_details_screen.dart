
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
import '../../../rating_review/widget/review_rating_card_widget.dart';
import '../../marketing/screen/franchise_commission_screen.dart';
import '../bloc/education_service_details/education_service_details_bloc.dart';
import '../bloc/education_service_details/education_service_details_event.dart';
import '../bloc/education_service_details/education_service_details_state.dart';
import '../repository/education_service_details_repository.dart';
import '../widget/education_course_curriculum_widget.dart';



class EducationServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const EducationServiceDetailsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  State<EducationServiceDetailsScreen> createState() => _EducationServiceDetailsScreenState();
}

class _EducationServiceDetailsScreenState extends State<EducationServiceDetailsScreen> {
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
        create: (_) => EducationServiceDetailsBloc(repository: EducationServiceDetailsRepository())
      ..add(FetchEducationServiceDetails(widget.serviceId))),

        BlocProvider(
          create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
          )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<EducationServiceDetailsBloc, EducationServiceDetailsState>(
          builder: (context, state) {
            if (state is EducationServiceDetailsLoading) {
              return  Center(child: CircularProgressIndicator(color: CustomColor.marketing,));
            } else if (state is EducationServiceDetailsLoaded) {
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
                                            alignment: AlignmentDirectional.bottomEnd,
                                            children: [
                                              Column(
                                                children: [
                                                  Expanded(
                                                    child: Stack(
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
                                                    ),
                                                  ),
                                                  20.height
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.06), // light shadow
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      spacing: 5,
                                                      children: [
                                                        Icon(Icons.circle,size: 12,color: Colors.green,),
                                                        const Text(
                                                          'Online Mode',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  if(service.serviceDetails.duration.weeks != null)
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.06), // light shadow
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      spacing: 5,
                                                      children: [
                                                        const Text(
                                                          'Duration',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                         Row(
                                                           spacing: 5,
                                                           children: [
                                                             Text('${service.serviceDetails.duration.weeks} Weeks', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey,),),
                                                             Text('${service.serviceDetails.duration.hours} Hours', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey,),),
                                                           ],
                                                         ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
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
                                                      color: CustomColor.education,
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
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(service.serviceName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              Text(service.category.name, style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),
                                              const SizedBox(height: 10),

                                              Text('Price', style: TextStyle(color: Colors.grey),),
                                              Row(
                                                spacing: 5,
                                                children: [
                                                  CustomAmountText(amount: selectedPackage.discountedPrice.toStringAsFixed(0), fontSize: 16,fontWeight: FontWeight.w500),
                                                  CustomAmountText(amount: selectedPackage.price.toStringAsFixed(0), color: Colors.grey.shade700, fontSize: 12,fontWeight: FontWeight.w500,isLineThrough: true),
                                                  Text('${selectedPackage.discount}% OFF',style: TextStyle(fontSize: 10,color: CustomColor.appColor,fontWeight: FontWeight.w500),)
                                                ],
                                              )
                                            ],
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

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('EMI option available', style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),
                                          10.height,
                                          // GridView.builder(
                                          //   itemCount: service.serviceDetails.emiAvailable.length,
                                          //   shrinkWrap: true,
                                          //   physics: NeverScrollableScrollPhysics(),
                                          //   padding: EdgeInsets.zero,
                                          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //       crossAxisCount: 3,
                                          //       crossAxisSpacing: 10,
                                          //       mainAxisSpacing: 10,
                                          //       childAspectRatio: 1/0.19
                                          //   ),
                                          //   itemBuilder: (context, index) {
                                          //     final tag = service.serviceDetails.emiAvailable[index];
                                          //     return CustomContainer(
                                          //       margin: EdgeInsets.zero,
                                          //       color: Color(0xFFE2E9F1),
                                          //       // color: Colors.blue.shade50.withOpacity(0.6),
                                          //       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                          //       child: Center(child: Text(tag, style: TextStyle(fontSize: 12,color: Colors.grey.shade700),)),
                                          //     );
                                          //   },),
                                          // 10.height,

                                          Wrap(
                                            spacing: 10,       // horizontal gap (crossAxisSpacing jaisa)
                                            runSpacing: 10,    // vertical gap (mainAxisSpacing jaisa)
                                            children: List.generate(service.keyValues.length, (index) {
                                              final tag = service.keyValues[index];

                                              return CustomContainer(
                                                margin: EdgeInsets.zero,
                                                color: const Color(0xFFE2E9F1),
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min, // content ke hisaab se width
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      tag.icon,
                                                      height: 14,
                                                    ),

                                                    const SizedBox(width: 5),

                                                    Text(
                                                      tag.value,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                      ),
                                                      softWrap: false,
                                                      overflow: TextOverflow.visible, // ek line me pura text
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),

                                          10.height,
                                          Row(
                                            children: [
                                              Chip(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50), // circular shape
                                                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                                                ),
                                                label: Row(
                                                    spacing: 5,
                                                  children: [
                                                    Icon(Icons.school, size: 14,color: Colors.grey.shade700,),
                                                    Text(
                                                      'Level: ${service.serviceDetails.level}',
                                                      style: TextStyle(fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              ),
                                              const SizedBox(width: 8), // spacing between chips
                                              Chip(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50), // circular shape
                                                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                                                ),
                                                label: Row(
                                                  spacing: 5,
                                                  children: [
                                                    Icon(Icons.folder_copy_rounded, size: 14,color: Colors.grey.shade700,),
                                                    Text(
                                                      'Sections: ${service.serviceDetails.lessonCount}',
                                                      style: TextStyle(fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              ),
                                            ],
                                          )

                                        ],
                                      ),

                                      25.height,


                                      Row(
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
                                      )

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

                                                _buildCircle(),


                                                15.height,
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
                                                _buildCircle(),
                                                15.height,
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
                                              _buildCircle(),
                                              15.height,
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

                              if (service.serviceDetails.whatYouWillLearn.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: "What You'll Learn",),
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
                                              _buildCircle(),
                                              15.height,
                                              Column(
                                                spacing: 5,
                                                children: List.generate(service.serviceDetails.whatYouWillLearn.length,
                                                      (index) {
                                                    final list = service.serviceDetails.whatYouWillLearn[index];
                                                    return Text(list,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),);
                                                  },),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),


                              if (service.serviceDetails.eligibleFor.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: "Eligible For",),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildCircle(),
                                              15.height,
                                              Column(
                                                spacing: 5,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: List.generate(service.serviceDetails.eligibleFor.length,
                                                      (index) {
                                                    final list = service.serviceDetails.eligibleFor[index];
                                                    return Text(list,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),);
                                                  },),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              if(service.serviceDetails.courseCurriculum.isNotEmpty)
                                SliverToBoxAdapter(child: EducationCourseCurriculumWidget(courseCurriculum: service.serviceDetails.courseCurriculum,),),


                              if (service.serviceDetails.courseIncludes.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: "This course includes",),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildCircle(),
                                              15.height,
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: service.serviceDetails.courseIncludes.map((item) {
                                                  return CustomContainer(
                                                    border: true,
                                                    color: Colors.white,
                                                    margin: EdgeInsets.zero,
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade500,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),

                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                if (service.serviceDetails.certificateImage != null && service.serviceDetails.certificateImage.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SymbolText(text: 'Certification'),
                                          const SizedBox(height: 15),
                                          Row(
                                            spacing: 5,
                                            children: [
                                              Icon(Icons.circle,size: 6,color: Colors.grey.shade500,),
                                              Text('Professional Certificate on completion', style: TextStyle(fontSize: 12,color: Colors.grey.shade500),),
                                            ],
                                          ),

                                          15.height,
                                          SizedBox(
                                            height: 200,
                                            child: PageView.builder(
                                              itemCount: service.serviceDetails.certificateImage.length,
                                              itemBuilder: (context, index) {
                                                final image = service.serviceDetails.certificateImage[index];

                                                if (image.isEmpty) {
                                                  return const SizedBox();
                                                }

                                                return ClipRRect(
                                                  borderRadius: BorderRadiusGeometry.circular(10),
                                                  child: Image.network(image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __, ___) =>
                                                     Center(child: Icon(Icons.image_not_supported_outlined,size: 50,color: Colors.grey.shade500,)),
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
                                        color: Color(0xFFE2E1EA)
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

                              if (service.serviceDetails.packages.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SymbolText(text: 'Package'),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: dimensions.screenHeight*0.3,
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
                                                child: Container(
                                                  width: dimensions.screenHeight*0.22,
                                                  margin: EdgeInsets.only(right: 10,left: 5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? CustomColor.blackColor
                                                            : Colors.grey.shade300,
                                                        width: isSelected ? 0.3 : 0.1,
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
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(pkg.name, style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w600),),
                                                      CustomContainer(
                                                        border: true,
                                                        borderColor: Colors.orange,
                                                        color: Colors.white,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              spacing: 10,
                                                              children: [
                                                                CustomAmountText(amount: pkg.price.toStringAsFixed(0), isLineThrough: true,color: Colors.grey.shade700),
                                                                Text('(${pkg.discount.toStringAsFixed(0)}% OFF)', style: TextStyle(fontSize: 12),)
                                                              ],
                                                            ),
                                                            Align(
                                                                alignment: Alignment.center,
                                                                child: CustomAmountText(amount: pkg.discountedPrice.toStringAsFixed(0))),
                                                            Text('Onwards',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),)
                                                          ],
                                                        ),
                                                      ),

                                                      Column(
                                                        children: [
                                                          Text('What You Get -',style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w500),),
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
                                                                  children: [
                                                                    Icon(Icons.check, color: Colors.green,size: 16,),
                                                                    Text(data,style: TextStyle(fontSize: 12),)
                                                                  ],
                                                                ),
                                                              );
                                                            },)
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

                              // if(providers.isNotEmpty)
                              // SliverToBoxAdapter(
                              //   key: providerSectionKey,
                              //   child:Padding(
                              //     padding: const EdgeInsets.all(16),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           'Choose Provider',
                              //           style: TextStyle(
                              //               fontSize: 16,
                              //               fontWeight: FontWeight.w600,
                              //               color: CustomColor.business),
                              //         ),
                              //         SizedBox(height: 10),
                              //         AnimatedSize(
                              //           duration: const Duration(milliseconds: 400),
                              //           curve: Curves.easeInOut,
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //               color: Colors.white,
                              //               borderRadius: BorderRadius.circular(10),
                              //               boxShadow: [
                              //                 BoxShadow(
                              //                   color: Colors.black.withOpacity(0.08),
                              //                   blurRadius: 4,
                              //                   offset: const Offset(0, 2),
                              //                 ),
                              //               ],
                              //             ),
                              //             child: Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 Padding(
                              //                   padding: const EdgeInsets.all(10.0),
                              //                   child: Text(
                              //                     'Pick the right expert for your service',
                              //                     style:
                              //                     TextStyle(fontSize: 14, color: Colors.grey.shade700),
                              //                   ),
                              //                 ),
                              //
                              //                 Column(
                              //                   children: List.generate(
                              //                     showAllProviders ? providers.length : 1,
                              //                         (index) {
                              //                       final provider = providers[index];
                              //                       final isSelected = selectedProviderIndex == index;
                              //
                              //                       return CustomContainer(
                              //                         color: Colors.white,
                              //                         border: true,
                              //                         child: Row(
                              //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                           crossAxisAlignment: CrossAxisAlignment.start,
                              //                           children: [
                              //                             Expanded(
                              //                               child: Row(
                              //                                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                                 children: [
                              //                                   Column(
                              //                                     children: [
                              //                                       CircleAvatar(
                              //                                         radius: 25,
                              //                                         backgroundColor: CustomColor
                              //                                             .marketing.withOpacity(0.1),
                              //                                         backgroundImage:
                              //                                         provider.storeInfo.logo != null &&
                              //                                             provider.storeInfo.logo!
                              //                                                 .isNotEmpty
                              //                                             ? NetworkImage(provider.storeInfo.logo!)
                              //                                             : null,
                              //                                         child: (provider.storeInfo.logo == null ||
                              //                                             provider.storeInfo.logo!.isEmpty)
                              //                                             ? const Icon(Icons.store,
                              //                                             color: Colors.white)
                              //                                             : null,
                              //                                       ),
                              //                                       5.height,
                              //                                       CustomContainer(
                              //                                         margin: EdgeInsets.zero,
                              //                                         color: Colors.green.shade400,
                              //                                         padding: const EdgeInsets.symmetric(
                              //                                             horizontal: 10),
                              //                                         child:  Text( provider.isStoreOpen == true ?
                              //                                         'Available':'Close',
                              //                                           style: TextStyle(
                              //                                               fontSize: 10,
                              //                                               color: Colors.white),
                              //                                         ),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                   10.width,
                              //                                   Expanded(
                              //                                     child: Column(
                              //                                       crossAxisAlignment:
                              //                                       CrossAxisAlignment.start,
                              //                                       mainAxisAlignment: MainAxisAlignment.start,
                              //                                       children: [
                              //                                         Text(
                              //                                           provider.storeInfo.storeName,
                              //                                           style: const TextStyle(
                              //                                               fontSize: 14,
                              //                                               fontWeight: FontWeight.w600),
                              //                                         ),
                              //                                         Text(
                              //                                           '⭐ ${provider.averageRating}, (${provider.totalReviews} reviews)',
                              //                                           style: const TextStyle(fontSize: 12),
                              //                                         ),
                              //                                         Text(
                              //                                           provider.storeInfo.address,
                              //                                           style: TextStyle(
                              //                                               fontSize: 12,
                              //                                               color: Colors.grey.shade700),
                              //                                         ),
                              //                                       ],
                              //                                     ),
                              //                                   ),
                              //                                 ],
                              //                               ),
                              //                             ),
                              //                             Checkbox(
                              //                               activeColor: Colors.green,
                              //                               value: isSelected,
                              //                               onChanged: (_) {
                              //                                 setState(() {
                              //                                   selectedProviderIndex = isSelected ? null : index;
                              //
                              //                                   if (selectedProviderIndex != null) {
                              //                                     final selectedProvider = providers[selectedProviderIndex!]; // selected provider
                              //                                     print("Selected Provider ID: ${selectedProvider.id}");
                              //                                   } else {
                              //                                     print("No provider selected");
                              //                                   }
                              //                                 });
                              //                               },
                              //                             ),
                              //
                              //                           ],
                              //                         ),
                              //                       );
                              //                     },
                              //                   ),
                              //                 ),
                              //
                              //                 Center(
                              //                   child: CustomContainer(
                              //                     color: CustomColor.business,
                              //                     padding: EdgeInsets.symmetric(
                              //                         horizontal: 20, vertical: 4),
                              //                     child: Text(
                              //                       showAllProviders
                              //                           ? 'See Less Provider'
                              //                           : 'See All Provider',
                              //                       style: const TextStyle(
                              //                         color: Colors.white,
                              //                         fontWeight: FontWeight.w500,
                              //                       ),
                              //                     ),
                              //                     onTap: () {
                              //                       setState(() {
                              //                         showAllProviders = !showAllProviders;
                              //                       });
                              //
                              //                       WidgetsBinding.instance.addPostFrameCallback((_) {
                              //                         final context = providerSectionKey.currentContext;
                              //                         if (context != null) {
                              //                           Scrollable.ensureVisible(
                              //                             context,
                              //                             duration: const Duration(milliseconds: 500),
                              //                             curve: Curves.easeInOut,
                              //                             alignment: 0.5,
                              //                           );
                              //                         }
                              //                       });
                              //                     },
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

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
                                                _buildCircle(),
                                                15.height,
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
                                                _buildCircle(),
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
                                          Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.education,fontWeight: FontWeight.w600),),
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
                                    color:CustomColor.education,
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
                                    color: CustomColor.education.withOpacity(0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share,
                                            color: CustomColor.education, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.education,
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



            } else if (state is EducationServiceDetailsError) {
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
            text: '"', // Left side symbol
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              // color: color,
              color: Colors.grey
            ),
          ),
          TextSpan(
            text: ' ', // space between symbol and text
            style: TextStyle(fontSize: 14),
          ),
          TextSpan(
            text: text, // Main text
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CustomColor.education,
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildCircle(){
  return  Row(
  spacing: 5,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: List.generate(
    14,
        (index) => Container(
      padding:  EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: Color(0xFFBEBEBE),width: 3),
            top: BorderSide(color: Color(0xFFBEBEBE),width: 3),
          )
      ),
    ),
  ),
  );
}