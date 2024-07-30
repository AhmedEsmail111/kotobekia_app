class ApiConstant{
  static const baseurl='https://api.kotobekia.cloud/api';

  static const getConversation = '/v1/conversations/get';
  static const sendMessage = '/v1/messages/send-message';
  static const openConversation = '/v1/conversations/open-conversation';
  static const getSpecificCategoryMethodUrl = '/v1/levels/specific/';
  static const userCreateAccountUrl = '/v1/auth/signUp';
  static const sendReportUrl = '/v1/reports/report';
  static const userLoginUrl = '/v1/auth/logIn';
  static const notificationsUrl = '/v1/notifications/user';
  static const readNotificationsUrl = '/v1/notifications/update';
  static const verifyOtp = '/v1/auth/verify-OTP';
  static const resendOtp = '/v1/auth/reSend-OTP';
  static const signInWithGoogle = '/v1/auth/signUpWithGoogle';
  static const getFcmToken = '/v1/user/get-fcm';
  static const sendCodeOtp = '/v1/user/sendCode';
  static const verifyForgetCode = '/v1/user/verify-Forget-Code';
  static const forgetPassword = '/v1/user/forgetPassword';
  static const getHomePostMethodUrl = '/v1/levels/levels-posts';
  static const addNewPostUrlMethod = '/v1/posts';
  static const getSpecificEducationLevel = '/v1/levels/specific/';
  static const addToFavMethodUrl = '/v1/posts/add-to-favorite/';
  static const removeFromFavMethodUrl = '/v1/posts/remove-from-favorite/';
  static const getFavPostsMethodUrl = '/v1/user/favorites';
  static const getMyPostsMethodUrl = '/v1/user/my-posts';
  static const updateProfileMethodUrl = '/v1/user/update/';
  static const getUserPostsMethodUrl = '/v1/user/user-posts/';
  static const changePasswordMethodUrl = '/v1/user/changePassword';
  static const deleteAccountMethodUrl = '/v1/user/delete/';
  static const getMyProfileMethodUrl = '/v1/user/my-profile';
  static const getSearchUrl = '/v1/posts/search';
  static String getMessage(String id) => '/v1/messages/get/$id';
}
