
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:fetchtrue/feature/profile/screen/add_address_screen.dart';
import 'package:fetchtrue/feature/profile/screen/additional_details_screen.dart';
import 'package:fetchtrue/feature/profile/screen/bank_kyc_screen.dart';
import 'package:fetchtrue/feature/profile/screen/update_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../package/screen/package_screen.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        // Compress the image before uploading
        final compressedPath = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          '${pickedFile.path}_compressed.jpg',
          quality: 70,
        );

        if (compressedPath != null) {
          context.read<UserBloc>().add(
            UpdateProfilePhoto(widget.userId, compressedPath.path),
          );
        } else {
          // fallback if compression fails
          context.read<UserBloc>().add(
            UpdateProfilePhoto(widget.userId, pickedFile.path),
          );
        }
      } catch (e) {
        print('Error compressing/uploading image: $e');
        // fallback if any error
        context.read<UserBloc>().add(
          UpdateProfilePhoto(widget.userId, pickedFile.path),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', showBackButton: true),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UpdateProfilePhoto) {
            print('Uploaded profile');
          } else if (state is UserError) {
            print(state.massage);
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              context.read<UserBloc>().add(GetUserById(widget.userId));
              return shimmerProfileView(context);
            }

            if (state is UserLoading) {
              return shimmerProfileView(context);
            }

            UserModel? user;

            if (state is UserLoaded) {
              user = state.user;
            } else if (state is ProfilePhotoUpdated) {
              user = state.user;
            }

            if (user == null) return const SizedBox();

            final profilePhoto = user.profilePhoto;

            return Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  color: Colors.grey,
                  child: profilePhoto != null && profilePhoto.isNotEmpty
                      ? Image.network(profilePhoto, fit: BoxFit.cover)
                      : Image.asset(CustomImage.nullImage, fit: BoxFit.cover),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      250.height,
                      CustomContainer(
                        border: false,
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Personal Details',
                                    style: textStyle16(context)),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        if (widget.userId != null) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateInfoScreen(user: user!),),);
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.mode_edit_outline_outlined),
                                    ),
                                    IconButton(
                                      onPressed: widget.userId != null ?_pickAndUploadPhoto:()=>null,
                                      icon:
                                          const Icon(Icons.camera_alt_outlined),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName != null && user.fullName!.isNotEmpty
                                          ? user.fullName![0].toUpperCase() + user.fullName!.substring(1)
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    Text(
                                      user.mobileNumber != null
                                          ? '+91 ${user.mobileNumber}'
                                          : 'Mobile Number',
                                      style: textStyle14(context,
                                          color: CustomColor.descriptionColor),
                                    ),
                                    Text(
                                      user.email ?? 'Email ID',
                                      style: textStyle14(context,
                                          color: CustomColor.descriptionColor),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PackageScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: CustomColor.appColor,
                                      border: Border.all(color: CustomColor.appColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:  Row(
                                      children: [
                                        Icon(Icons.verified_outlined, size: 16, color: CustomColor.whiteColor,),
                                        SizedBox(width: 5),
                                        Text(user.packageActive == true ? '${user.packageStatus}' :'Package', style: textStyle12(context, color: CustomColor.whiteColor)),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      10.height,
                      CustomContainer(
                        border: false,
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          minVerticalPadding: 0,
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.all(0),
                          title: const Text('Additional Details'),
                          subtitle: const Text('Age, gender, and more'),
                          trailing: const Icon(Icons.add,
                              size: 20, color: Colors.grey),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailsScreen(user: user!.id.toString(),),)),
                      ),
                      10.height,
                      CustomContainer(
                        border: false,
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          minVerticalPadding: 0,
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.all(0),
                          title: const Text('Address'),
                          subtitle: const Text('Add Address'),
                          trailing: const Icon(Icons.add, color: Colors.grey),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen(user: user!),)),
                      ),
                      10.height,

                      CustomContainer(
                        border: false,
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          minVerticalPadding: 0,
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.all(0),
                          title: const Text('Bank KYC'),
                          subtitle: const Text('Complete Bank KYC'),
                          trailing: const Icon(Icons.add, color: Colors.grey),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BankKycScreen(userId: user!.id.toString()),)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget shimmerProfileView(BuildContext context) {
  return Stack(
    alignment: AlignmentDirectional.topStart,
    children: [
      // Cover Image
      Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ShimmerBox(height: 280, width: double.infinity)),

      // Profile Container
      Padding(
        padding: const EdgeInsets.only(top: 250.0, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Details Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(height: 16, width: 120),
                        Row(
                          children: [
                            ShimmerBox(
                                height: 24,
                                width: 24,
                                borderRadius: BorderRadius.circular(4)),
                            const SizedBox(width: 8),
                            ShimmerBox(
                                height: 24,
                                width: 24,
                                borderRadius: BorderRadius.circular(4)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Name, Phone, Email + KYC
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(height: 18, width: 160),
                            const SizedBox(height: 6),
                            ShimmerBox(height: 14, width: 100),
                            const SizedBox(height: 4),
                            ShimmerBox(height: 14, width: 140),
                          ],
                        ),
                        ShimmerBox(
                          height: 28,
                          width: 60,
                          borderRadius: BorderRadius.circular(20),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Additional Details
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 16, width: 140),
                        const SizedBox(height: 4),
                        ShimmerBox(height: 12, width: 100),
                      ],
                    ),
                    ShimmerBox(
                        height: 20,
                        width: 20,
                        borderRadius: BorderRadius.circular(4)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Address
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 16, width: 100),
                        const SizedBox(height: 4),
                        ShimmerBox(height: 12, width: 80),
                      ],
                    ),
                    ShimmerBox(
                        height: 20,
                        width: 20,
                        borderRadius: BorderRadius.circular(4)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}
