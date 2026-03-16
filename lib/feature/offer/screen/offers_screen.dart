import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../bloc/offer_bloc.dart';
import '../bloc/offer_event.dart';
import '../bloc/offer_state.dart';
import '../repository/offer_repository.dart';
import 'offers_details_screen.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => OfferBloc(OfferRepository())..add(FetchOffersEvent()),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Offers',),
        body: BlocBuilder<OfferBloc, OfferState>(
          builder: (context, state) {
            if (state is OfferLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is OfferLoaded) {
              final offers = state.offers;

              if(offers.isEmpty){
                return Padding(
                    padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                    child:  Center(child: Column(
                      children: [
                        Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                        Text('No Offer'),
                      ],
                    )));
              }


              return ListView.builder(
                padding:  EdgeInsets.all(dimensions.screenHeight*0.010),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return CustomNetworkImage(
                    height: dimensions.screenHeight*0.2,
                    imageUrl: offer.thumbnailImage,
                    borderRadius: BorderRadius.circular(10),
                    fit: BoxFit.fill,
                    margin: EdgeInsets.only(bottom: dimensions.screenHeight*0.010),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OffersDetailsScreen(offersFuture: offer,),)),
                  );
                },
              );
            } else if (state is OfferError) {
              print('Error: ${state.message}');
              return Padding(
                  padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                  child:  Center(child: Column(
                    children: [
                      Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                      Text('No Offer'),
                    ],
                  )));
            }
            return Padding(
                padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                child:  Center(child: Column(
                  children: [
                    Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                    Text('No Offer'),
                  ],
                )));
          },
        ),
      ),
    );
  }
}
