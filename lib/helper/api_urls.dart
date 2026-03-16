
class ApiUrls{

  static const String baseUrl = 'https://api.fetchtrue.com/api/';

  /// Auth api
  static const String user = '${baseUrl}users';
  static const String userUpdateInfo = '${baseUrl}users/update-info';
  static const String userUpdateProfile = '${baseUrl}users/update-profile-photo';
  static const String signUp = '${baseUrl}auth/register';
  static const String signIn = '${baseUrl}auth/login';
  static const String verifyOtp = '${baseUrl}auth/verify-otp';
  static const String forgotPassword = '${baseUrl}auth/forgot-password';


  /// Module Api
  static const String wallet = '${baseUrl}wallet/fetch-by-user';
  static const String bankKyc = '${baseUrl}wallet/payout/add-beneficiary';
  static const String packages = '${baseUrl}packages';
  static const String fiveX = '${baseUrl}fivex';
  static const String modules = '${baseUrl}modules';
  static const String modulesCategory = '${baseUrl}category';
  static const String modulesSubcategory = '${baseUrl}subcategory';
  static const String modulesService = '${baseUrl}service';
  static const String mostlyRecommended = '${baseUrl}service/mostlyrecommended';
  static const String mostlyPopular = '${baseUrl}service/mostlypopular';
  static const String mostlyTrending = '${baseUrl}service/mostlytrending';
  static const String franchiseModel = '${baseUrl}service/franchise/model';

  static const String serviceReview = '${baseUrl}service/review';
  static const String recommendedService = '${baseUrl}service/recommended';
  static const String popularService = '${baseUrl}service/popular';
  static const String topTrendingService = '${baseUrl}service/top-trending';
  static const String banner = '${baseUrl}banner';
  static const String categoryCover = '${baseUrl}categorybanner';
  static const String provider = '${baseUrl}provider';
  static const String serviceWiseProviders = '${baseUrl}provider/all/service-wise';
  static const String recommendedProviders = '${baseUrl}provider/recommended';
  static const String popularProviders = '${baseUrl}provider/popular';
  static const String trendingProviders = '${baseUrl}provider/trending';
  static const String providerReview = '${baseUrl}provider/review';
  static const String serviceCustomer = '${baseUrl}service-customer';
  static const String coupon = '${baseUrl}coupon';
  static const String checkout = '${baseUrl}checkout';
  static const String leads = '${baseUrl}checkout/lead-by-user';
  static const String leadStatus = '${baseUrl}leads';
  static const String shareOneCommission = '${baseUrl}checkout/share';
  static const String offer = '${baseUrl}offer';
  static const String ads = '${baseUrl}ads';
  static const String advisor = '${baseUrl}advisor';
  static const String understandingFetchTrue = '${baseUrl}academy/understandingfetchtrue';

  static const String myTeam = '${baseUrl}team-build/my-team';
  static const String upcomingLeadCommission = '${baseUrl}upcoming-lead-commission/find-by-checkoutId';

  static const cashfreeUrl  =  '${baseUrl}cashfree/order';
  static const payuGatewayUrl  =  '${baseUrl}pay-u/create-payment-link';
  static const String cashfreeApiKey = "";
}