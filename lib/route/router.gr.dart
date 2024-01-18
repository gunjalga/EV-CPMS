// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:cloud_firestore/cloud_firestore.dart' as _i12;
import 'package:flutter/cupertino.dart' as _i11;
import 'package:flutter/material.dart' as _i10;

import '../modules/auth/login.dart' as _i3;
import '../modules/auth/otp.dart' as _i5;
import '../modules/auth/signup.dart' as _i4;
import '../modules/home/charger_details.dart' as _i6;
import '../modules/home/home_page.dart' as _i2;
import '../modules/order/order_page.dart' as _i8;
import '../modules/reserve/reserve_page.dart' as _i7;
import '../modules/splash/splash_page.dart' as _i1;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SplashPageRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    LoginPageRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    SignUpPageRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpPageRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.SignUpPage(
          key: args.key,
          phone: args.phone,
        ),
      );
    },
    OtpPageRoute.name: (routeData) {
      final args = routeData.argsAs<OtpPageRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.OtpPage(
          key: args.key,
          verificationId: args.verificationId,
          fromSignup: args.fromSignup,
          data: args.data,
        ),
      );
    },
    ChargerDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ChargerDetailsRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.ChargerDetails(
          key: args.key,
          chargerDetails: args.chargerDetails,
          distance: args.distance,
        ),
      );
    },
    ReservePageRoute.name: (routeData) {
      final args = routeData.argsAs<ReservePageRouteArgs>(
          orElse: () => const ReservePageRouteArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.ReservePage(
          key: args.key,
          data: args.data,
        ),
      );
    },
    OrderPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderPageRouteArgs>(
          orElse: () => const OrderPageRouteArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.OrderPage(key: args.key),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          SplashPageRoute.name,
          path: '/',
        ),
        _i9.RouteConfig(
          HomePageRoute.name,
          path: '/home-page',
        ),
        _i9.RouteConfig(
          LoginPageRoute.name,
          path: '/login-page',
        ),
        _i9.RouteConfig(
          SignUpPageRoute.name,
          path: '/sign-up-page',
        ),
        _i9.RouteConfig(
          OtpPageRoute.name,
          path: '/otp-page',
        ),
        _i9.RouteConfig(
          ChargerDetailsRoute.name,
          path: '/charger-details',
        ),
        _i9.RouteConfig(
          ReservePageRoute.name,
          path: '/reserve-page',
        ),
        _i9.RouteConfig(
          OrderPageRoute.name,
          path: '/order-page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashPageRoute extends _i9.PageRouteInfo<void> {
  const SplashPageRoute()
      : super(
          SplashPageRoute.name,
          path: '/',
        );

  static const String name = 'SplashPageRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomePageRoute extends _i9.PageRouteInfo<void> {
  const HomePageRoute()
      : super(
          HomePageRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginPageRoute extends _i9.PageRouteInfo<void> {
  const LoginPageRoute()
      : super(
          LoginPageRoute.name,
          path: '/login-page',
        );

  static const String name = 'LoginPageRoute';
}

/// generated route for
/// [_i4.SignUpPage]
class SignUpPageRoute extends _i9.PageRouteInfo<SignUpPageRouteArgs> {
  SignUpPageRoute({
    _i11.Key? key,
    required String phone,
  }) : super(
          SignUpPageRoute.name,
          path: '/sign-up-page',
          args: SignUpPageRouteArgs(
            key: key,
            phone: phone,
          ),
        );

  static const String name = 'SignUpPageRoute';
}

class SignUpPageRouteArgs {
  const SignUpPageRouteArgs({
    this.key,
    required this.phone,
  });

  final _i11.Key? key;

  final String phone;

  @override
  String toString() {
    return 'SignUpPageRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [_i5.OtpPage]
class OtpPageRoute extends _i9.PageRouteInfo<OtpPageRouteArgs> {
  OtpPageRoute({
    _i11.Key? key,
    required String verificationId,
    required bool fromSignup,
    required Map<String, dynamic> data,
  }) : super(
          OtpPageRoute.name,
          path: '/otp-page',
          args: OtpPageRouteArgs(
            key: key,
            verificationId: verificationId,
            fromSignup: fromSignup,
            data: data,
          ),
        );

  static const String name = 'OtpPageRoute';
}

class OtpPageRouteArgs {
  const OtpPageRouteArgs({
    this.key,
    required this.verificationId,
    required this.fromSignup,
    required this.data,
  });

  final _i11.Key? key;

  final String verificationId;

  final bool fromSignup;

  final Map<String, dynamic> data;

  @override
  String toString() {
    return 'OtpPageRouteArgs{key: $key, verificationId: $verificationId, fromSignup: $fromSignup, data: $data}';
  }
}

/// generated route for
/// [_i6.ChargerDetails]
class ChargerDetailsRoute extends _i9.PageRouteInfo<ChargerDetailsRouteArgs> {
  ChargerDetailsRoute({
    _i11.Key? key,
    required _i12.DocumentSnapshot<Object?> chargerDetails,
    required double distance,
  }) : super(
          ChargerDetailsRoute.name,
          path: '/charger-details',
          args: ChargerDetailsRouteArgs(
            key: key,
            chargerDetails: chargerDetails,
            distance: distance,
          ),
        );

  static const String name = 'ChargerDetailsRoute';
}

class ChargerDetailsRouteArgs {
  const ChargerDetailsRouteArgs({
    this.key,
    required this.chargerDetails,
    required this.distance,
  });

  final _i11.Key? key;

  final _i12.DocumentSnapshot<Object?> chargerDetails;

  final double distance;

  @override
  String toString() {
    return 'ChargerDetailsRouteArgs{key: $key, chargerDetails: $chargerDetails, distance: $distance}';
  }
}

/// generated route for
/// [_i7.ReservePage]
class ReservePageRoute extends _i9.PageRouteInfo<ReservePageRouteArgs> {
  ReservePageRoute({
    _i11.Key? key,
    dynamic data,
  }) : super(
          ReservePageRoute.name,
          path: '/reserve-page',
          args: ReservePageRouteArgs(
            key: key,
            data: data,
          ),
        );

  static const String name = 'ReservePageRoute';
}

class ReservePageRouteArgs {
  const ReservePageRouteArgs({
    this.key,
    this.data,
  });

  final _i11.Key? key;

  final dynamic data;

  @override
  String toString() {
    return 'ReservePageRouteArgs{key: $key, data: $data}';
  }
}

/// generated route for
/// [_i8.OrderPage]
class OrderPageRoute extends _i9.PageRouteInfo<OrderPageRouteArgs> {
  OrderPageRoute({_i11.Key? key})
      : super(
          OrderPageRoute.name,
          path: '/order-page',
          args: OrderPageRouteArgs(key: key),
        );

  static const String name = 'OrderPageRoute';
}

class OrderPageRouteArgs {
  const OrderPageRouteArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'OrderPageRouteArgs{key: $key}';
  }
}
