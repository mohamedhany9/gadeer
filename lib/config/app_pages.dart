import 'package:gadeer/config/routes.dart';
import 'package:gadeer/layout/main_navigation.dart';
import 'package:gadeer/modules/account/account.page.dart';
import 'package:gadeer/modules/account/widgets/edit_account_screen.dart';
import 'package:gadeer/modules/chat/chat_page.dart';
import 'package:gadeer/modules/consulting/pages/consulting_details.page.dart';
import 'package:gadeer/modules/consulting/pages/edit_consulting_form.dart';
import 'package:gadeer/modules/login/login.page.dart';
import 'package:gadeer/modules/notifications/notifications_screen.dart';
import 'package:gadeer/modules/profile/profile.page.dart';
import 'package:gadeer/modules/register/register.page.dart';
import 'package:gadeer/modules/register/widgets/enter_phone.dart';
import 'package:gadeer/modules/register/widgets/verification_code.dart';
import 'package:gadeer/modules/splash/splash.page.dart';
import 'package:get/get.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(name: Routes.splash, page: () => SplashPage()),
    GetPage(name: Routes.main, page: () => MainNavigation()),
    GetPage(name: Routes.register, page: () => RegisterPage()),
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.enterPhone, page: () => EnterPhone()),
    GetPage(name: Routes.verificationCode, page: () => VerificationCode()),
    GetPage(name: Routes.showAccount, page: () => AccountPage()),
    GetPage(name: Routes.editAccount, page: () => EditAccountScreen()),
    GetPage(name: Routes.profile, page: () => ProfilePage()),
    GetPage(
        name: Routes.consultingEdit, page: () => EditConsultingFormWidget()),
    GetPage(
        name: Routes.consultingDetails, page: () => ConsultingDetailsPage()),
    GetPage(name: Routes.notificationsPage, page: () => NotificationsPage()),
    GetPage(name: Routes.chatPage, page: () => ChatPage()),
  ];
}
