import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/bloc/app_observer.dart';
import 'package:foodapp/bloc/cubits/app_config_cubit.dart';
import 'package:foodapp/dtos/responses/order/order.dart';
import 'package:foodapp/pages/app_routes.dart';
import 'package:foodapp/pages/login/login.dart';
import 'package:foodapp/pages/order/confirm_order.dart';
import 'package:foodapp/pages/order_list/order_list.dart';
import 'package:foodapp/pages/register/register.dart';
import 'package:foodapp/pages/tab/apptab.dart';
import 'package:foodapp/pages/order_detail/order_detail_screen.dart';
import 'package:foodapp/services/order_service.dart';
import 'package:foodapp/services/user_service.dart';
import 'package:foodapp/services/coupon_service.dart';
import 'package:get_it/get_it.dart';
import 'package:foodapp/pages/splash/splash.dart';
import 'package:go_router/go_route'
    'r.dart';

import 'firebase_options.dart';
import 'pages/detail_product/detail_product.dart';
import 'services/category_service.dart';
import 'services/product_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
/*
flutter pub add http shared_preferences get_it
flutter pub add go_router
flutter pub add intl
flutter pub add build_runner
flutter pub add loading_animation_widget
flutter pub add carousel_slider
flutter pub add image_picker
flutter pub add flutter_bloc
flutter pub add flutter_facebook_auth
flutter pub add google_sign_in
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add flutter_facebook_auth
flutter pub add firebase_core_platform_interface
Enable Google signin: https://console.firebase.google.com/project/shopapp-58f10/authentication/providers

npm install -g firebase-tools
dart pub global activate flutterfire_cli

firebase login
flutterfire configure
sudo gem install drb -v 2.0.6

cd android && ./gradlew signingReport


* */
void main() async {
  //register services
  GetIt.instance.registerLazySingleton<UserService>(() => UserService());
  GetIt.instance.registerLazySingleton<ProductService>(() => ProductService());
  GetIt.instance.registerLazySingleton<CategoryService>(() => CategoryService());  
  GetIt.instance.registerLazySingleton<CouponService>(() => CouponService());
  GetIt.instance.registerLazySingleton<OrderService>(() => OrderService());
  Bloc.observer = const AppObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/*
 GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Splash();
      },
    ),
* */
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Splash();
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) {
            return Login();
          },
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (BuildContext context, GoRouterState state) {
            return Register();
          },
        ),
        GoRoute(
          path: AppRoutes.detailProduct,
          builder: (BuildContext context, GoRouterState state) {
            int productId = ((state.extra as Map)['productId'] as int?) ?? 0;
            return DetailProduct(productId: productId); //receive
          },
        ),
        GoRoute(
          path: AppRoutes.orderList,
          builder: (BuildContext context, GoRouterState state) {
            return OrderList();
          },
        ),
        GoRoute(
          path: AppRoutes.confirmOrder,
          builder: (BuildContext context, GoRouterState state) {
            return ConfirmOrder();
          },
        ),
        GoRoute(
          path: AppRoutes.appTab,
          builder: (BuildContext context, GoRouterState state) {
            return AppTab();
          },
        ),
        GoRoute(
          path: AppRoutes.orderDetail,
          builder: (BuildContext context, GoRouterState state) {
            Order order = (state.extra as Map)['order'] as Order;
            return OrderDetailScreen(order: order);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontSize: 14, // Normal text size
            // You can also set other properties like fontFamily, fontWeight, etc.
          ),
          bodyMedium: TextStyle(
            fontSize: 16, // Normal text size
          ),
          bodyLarge: TextStyle(
            fontSize: 20, // Normal text size
            // You can also set other properties like fontFamily, fontWeight, etc.
        )
      ),
    );
    return BlocProvider(
      create: (_) => AppConfigCubit(),
      child: MaterialApp.router(
          routerConfig: _router,
          theme: theme
      ),
    );
  /*
    return MaterialApp.router(
      routerConfig: _router,
      theme: theme
    );
  */
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      //home: OrderList(),
      home: ConfirmOrder(),
      //home: AppTab(),
      //home: Login()
      //home:DetailProduct()
    );
  }
}
