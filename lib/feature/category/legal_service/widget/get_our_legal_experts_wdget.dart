import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';

class GetOurLegalExpertsWidget extends StatelessWidget {
  const GetOurLegalExpertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Container(
      color: Color(0xFFF9F5EE),
      child: Column(
        children: [
          SizedBox(height: dimensions.screenHeight * 0.02),

          const Text(
            'Get our Legal Experts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: dimensions.screenHeight * 0.02),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4D2D21),
                  Color(0xFFB3694D),
                ],
              ),
            ),

            child: SizedBox(
              height: dimensions.screenHeight*0.25,
              child: ListView.builder(
                itemCount: 3,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: dimensions.screenHeight*0.2,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(CustomImage.nullImage),
                            ),
                            5.height,
                            Text('Adv. Aditi Sharma',style: TextStyle(),),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star,color: Colors.amber,size: 18,),
                                Icon(Icons.star,color: Colors.amber,size: 18,),
                                Icon(Icons.star,color: Colors.amber,size: 18,),
                                Icon(Icons.star,color: Colors.amber,size: 18,),
                                Icon(Icons.star,color: Colors.amber,size: 18,),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pune',style: TextStyle(fontWeight: FontWeight.w500),),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,size: 16,color: Colors.grey,),
                                    Text('Location',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey),),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('10 Year',style: TextStyle(fontWeight: FontWeight.w500),),
                                Row(
                                  children: [
                                    Icon(Icons.work_outline,size: 16,color: Colors.grey,),
                                    Text('Experience',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),


                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFFB3694D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text('Book Now', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),)),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
