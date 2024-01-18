import 'package:auto_route/auto_route.dart';
import 'package:ev_cpms/modules/auth/login.dart';
import 'package:ev_cpms/modules/auth/otp.dart';
import 'package:ev_cpms/modules/auth/signup.dart';
import 'package:ev_cpms/modules/home/charger_details.dart';
import 'package:ev_cpms/modules/home/home_page.dart';
import 'package:ev_cpms/modules/order/order_page.dart';
import 'package:ev_cpms/modules/reserve/reserve_page.dart';
import 'package:ev_cpms/modules/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: SignUpPage),
    MaterialRoute(page: OtpPage),
    MaterialRoute(page: ChargerDetails),
    MaterialRoute(page: ReservePage),
    MaterialRoute(page: OrderPage),
  ],
)
class $AppRouter {}
