import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/category/marketing/screen/franchise_commission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/custom_url_launch.dart';
import '../../../../helper/Contact_helper.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../checkout/screen/check_out_screen.dart';
import '../../../provider/bloc/service_wise_provider_subscriber/service_wise_provider_subscriber_bloc.dart';
import '../../../provider/bloc/service_wise_provider_subscriber/service_wise_provider_subscriber_event.dart';
import '../../../provider/bloc/service_wise_provider_subscriber/service_wise_provider_subscriber_state.dart';
import '../../../provider/repository/service_wise_provider_subscriber_repository.dart';
import '../../franchise/bloc/franchise_model/franchise_model_bloc.dart';
import '../../franchise/bloc/franchise_model/franchise_model_event.dart';
import '../../franchise/bloc/franchise_model/franchise_model_state.dart';
import '../../franchise/repository/franchise_repository.dart';
import '../bloc/business_service_details/business_service_details_bloc.dart';
import '../bloc/business_service_details/business_service_details_event.dart';
import '../bloc/business_service_details/business_service_details_state.dart';
import '../repository/business_service_details_repository.dart';
import 'investment_repository_screen.dart';
import 'monthly_earning_screen.dart';


class BusinessServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const BusinessServiceDetailsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  State<BusinessServiceDetailsScreen> createState() => _BusinessServiceDetailsScreenState();
}

class _BusinessServiceDetailsScreenState extends State<BusinessServiceDetailsScreen> {
  int _currentBannerIndex = 0;
  // int expandedIndex = -1;
  int expandedIndex = 0;
  int _selectedPackageIndex = 0;

  int? selectedProviderIndex;
  int? _expandedFranchiseModelIndex;

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
        create: (_) => BusinessServiceDetailsBloc(repository: BusinessServiceDetailsRepository())
      ..add(FetchBusinessServiceDetails(widget.serviceId))),

        BlocProvider(
          create: (_) => ServiceWiseProviderSubscriberBloc(ServiceWiseProviderSubscriberRepository(),
          )..add(FetchServiceWiseProviderSubscriber(widget.serviceId)),
        ),

        BlocProvider(create: (_) => FranchiseModelBloc(FranchiseRepository())..add(FetchFranchiseModel(widget.serviceId)),),


      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<BusinessServiceDetailsBloc, BusinessServiceDetailsState>(
          builder: (context, state) {
            if (state is BusinessServiceDetailsLoading) {
              return  Center(child: CircularProgressIndicator(color: CustomColor.marketing,));
            } else if (state is BusinessServiceDetailsLoaded) {
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
                                                          // const Icon(Icons.star, color: Colors.amber, size: 14),
                                                          // const SizedBox(width: 3),
                                                          Text("${service.category!.name.toString()}",
                                                              style: const TextStyle(fontSize: 12, color: Colors.black)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                  Container(
                                                    padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: CustomColor.business,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      "₹ ${selectedPackage.price}",
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(service.serviceName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          Text(service.category!.name.toString(), style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),
                                        ],
                                      ),
                                      10.height,

                                      Row(
                                        spacing: 10,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              color: Color(0xFFDFE5E7).withOpacity(0.2),
                                              child: InkWell(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Investment\nrange',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                                    5.height,
                                                    Row(
                                                      spacing: 5,
                                                      children: [
                                                        Text('${service.franchiseDetails.investmentRange[0].range}', style: TextStyle(fontSize: 16),),
                                                        Text('${service.franchiseDetails.investmentRange[0].parameters}', style: TextStyle(fontSize: 10, color: Colors.grey),),
                                                      ],
                                                    ),
                                                    10.height,

                                                    Text('View Breakup',style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: CustomColor.business),),
                                                    20.height,
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => InvestmentRepositoryScreen(
                                                    serviceId: service.id,
                                                    serviceImage: service.thumbnailImage,
                                                    serviceName: service.serviceName,
                                                  ),));
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                            color: Color(0xFFDFE5E7).withOpacity(0.2),
                                            child: InkWell(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Monthly Earning\nPotential',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                                  5.height,
                                                  Row(
                                                    spacing: 5,
                                                    children: [
                                                      Text('${service.franchiseDetails.monthlyEarnPotential[0].range}', style: TextStyle(fontSize: 16),),
                                                      Text('${service.franchiseDetails.monthlyEarnPotential[0].parameters}', style: TextStyle(fontSize: 10, color: Colors.grey),),
                                                    ],
                                                  ),
                                                  10.height,

                                                  Text('View Breakup',style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: CustomColor.business),),
                                                  20.height,
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyEarningScreen(

                                                ),));
                                              },
                                            ),
                                          )),

                                          if(service.serviceDetails.roi.isNotEmpty)
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                            color: Color(0xFFDFE5E7).withOpacity(0.2),
                                            child: Column(
                                              children: [
                                                Text('ROI\n',style: TextStyle(fontSize: 12, color: Colors.grey),),
                                                5.height,
                                                Text('${service.serviceDetails.roi.first}',style: TextStyle(fontSize: 16),)
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                      10.height,

                                      Row(
                                        spacing: 5,
                                        children: [
                                          Icon(Icons.notes,size: 14,),
                                          Text('EMI Options Available',style: TextStyle(fontSize: 10,color: Colors.grey.shade900,fontWeight: FontWeight.w600),)
                                        ],
                                      ),
                                      10.height,

                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF8EF),
                                          borderRadius:  BorderRadius.circular(10),
                                          border: Border.all(
                                            color: CustomColor.marketing,
                                            width: 0.6,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
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
                                      ),
                                      15.height,

                                      Container(
                                          decoration: BoxDecoration(
                                            // color: const Color(0xFFFFF8EF),
                                            borderRadius:  BorderRadius.circular(10),
                                            border: Border.all(
                                              color: CustomColor.marketing,
                                              width: 0.6,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child:InkWell(
                                            onTap: () {
                                              CustomUrlLaunch('${service.bannerImages.first}');
                                            },
                                            child: Row(
                                              spacing: 10,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.save_alt, size: 18,color: CustomColor.business,),
                                                Text('Free Brochure', style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: CustomColor.business),)
                                              ],
                                            ),
                                          )
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
                                        Text("Benefits", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColor.business)),
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
                                            child:  Html(
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
                                        Text("About Us", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColor.business)),
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
                                            child:  Html(
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Why Choose This Business?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.business)),
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
                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.weDeliver.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("What We Provides", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.business)),
                                        const SizedBox(height: 10),
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
                                            children: service.serviceDetails.weDeliver.map((item) {
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                visualDensity: const VisualDensity(
                                                  horizontal: VisualDensity.minimumDensity,
                                                  vertical: VisualDensity.minimumDensity,
                                                ),
                                                title: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.check_circle_outline_outlined,
                                                      size: 18,
                                                      color: Colors.green,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      item.title,
                                                      style: const TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),

                                                subtitle: item.description.isNotEmpty ? Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: Text(
                                                    item.description,
                                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                                  ),
                                                ):null,
                                              );

                                            }).toList(),
                                          ),
                                        ),
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
                                        Text("What You Need to Provide", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.business)),
                                        const SizedBox(height: 10),
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
                                            children: service.serviceDetails.weRequired.map((item) {
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                visualDensity: const VisualDensity(
                                                  horizontal: VisualDensity.minimumDensity,
                                                  vertical: VisualDensity.minimumDensity,
                                                ),
                                                title: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.check_circle_outline_outlined,
                                                      size: 18,
                                                      color: Colors.green,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      item.title,
                                                      style: const TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                          
                                                subtitle: item.description.isNotEmpty ? Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: Text(
                                                    item.description,
                                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                                  ),
                                                ):null,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (service.serviceDetails.completeSupportSystem.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text('Complete Support System',style: TextStyle(fontSize: 16,color: CustomColor.business,fontWeight: FontWeight.w600),),
                                      ),

                                      Container(
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
                                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: List.generate(service.serviceDetails.completeSupportSystem.length, (index) {
                                                final data = service.serviceDetails.completeSupportSystem[index];
                                                return Column(
                                                  children: [
                                                    Row(
                                                      spacing: 8,
                                                      children: [
                                                        Image.network(
                                                          data.icon,
                                                          height:40,
                                                          width: 40,
                                                          errorBuilder: (_, __, ___) =>
                                                          SizedBox.shrink()
                                                        ),
                                                        // CircleAvatar(radius: 10,backgroundColor: CustomColor.marketing.withOpacity(0.1),),

                                                        Text(data.title, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),

                                                    GridView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: data.lists.length,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 5,
                                                          crossAxisSpacing: 5,
                                                          childAspectRatio: 1/0.2,
                                                      ), itemBuilder: (context, index) {
                                                      final dataDec = data.lists[index];
                                                      return Row(
                                                        spacing: 4,
                                                        children: [
                                                          20.width,
                                                          Icon(Icons.circle,size: 8,color: Colors.grey,),
                                                          Text(dataDec, style: TextStyle(fontSize: 10,color: Colors.grey),),
                                                        ],
                                                      );
                                                    },),
                                                    Divider(color: Colors.grey,thickness: 0.2,)
                                                  ],
                                                );
                                              },),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              SliverToBoxAdapter(child: SizedBox(height: 10,),),

                              if(service.serviceDetails.trainingDetails.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        10.height,
                                        Text('Training Details',style: TextStyle(fontSize: 16,color: CustomColor.business, fontWeight: FontWeight.w600),),
                                        10.height,
                                        Container(
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
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            children: List.generate(service.serviceDetails.trainingDetails.length, (index) {
                                              final trainingDetails = service.serviceDetails.trainingDetails[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Icon(Icons.circle,size: 6,),
                                                    ),
                                                    Expanded(child: Text(trainingDetails,style: TextStyle(fontSize: 14),)),
                                                  ],
                                                ),
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
                                        Text("Packages", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.business)),
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
                                                          color: CustomColor.business,
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

                              if (service.serviceDetails.assuredByFetchTrue.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    decoration:  BoxDecoration(
                                        color: Color(0xFF1D4699)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Assured By Fetch True",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: CustomColor.whiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 18),

                                        GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: service.serviceDetails.assuredByFetchTrue.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1/0.55,
                                              crossAxisSpacing: 10,
                                            mainAxisSpacing: 10
                                          ),
                                          itemBuilder: (context, index) {
                                            final item = service.serviceDetails.assuredByFetchTrue[index];
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.network(item.icon,height: 30,color: Colors.white,),
                                                10.width,
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(item.title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14, color: Colors.white, overflow: TextOverflow.ellipsis,),maxLines: 2,),
                                                      Text(item.description,style: TextStyle(fontSize: 12, color: Colors.white, overflow: TextOverflow.ellipsis,),maxLines: 3,),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          },)
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
                                            color: CustomColor.business,
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
                                        Text('Terms & Conditions', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: CustomColor.business),),
                                        SizedBox(height: 10,),
                                        Container(
                                          padding: EdgeInsets.all(16),
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
                                            },),
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
                                        Text("FAQs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.business)),
                                        const SizedBox(height: 10),
                                        Container(
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


                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
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
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Contact With'),
                                          Text('${service.serviceDetails.connectWith.first.name}', style: TextStyle(color: CustomColor.business,fontWeight: FontWeight.w600),),
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
                                              // discountPrice: selectedPackage.discountedPrice.toString(),
                                              discountPrice: '0',
                                              discount: selectedPackage.discount.toString(),
                                              rating: service.averageRating.toString(),
                                              review: service.totalReviews.toString(),
                                              categoryName: service.category!.name,
                                              earnUpTo: service.franchiseDetails.commission,
                                             serviceGST:service.gst.toString(),
                                          ),
                                        ),
                                      ),
                                    );

                                  },

                                  child: Container(
                                    color:CustomColor.business,
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
                                    color: CustomColor.business.withOpacity(0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share,
                                            color: CustomColor.business, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.business,
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

            } else if (state is BusinessServiceDetailsError) {
              print('Service Error ${state.message}');
              return Center(child: Text(state.message));
            }
            return Container();
          },
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
