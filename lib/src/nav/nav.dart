import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/index.dart';
import '../core/pillkaboo_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: PKBAppState().isFirstLaunch ? '/accessibilityChoicePage' : '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Center(
                  child: Image.asset(
                    'assets/images/Screenshot_2024-01-30_at_9.58.21_AM.png',
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : const MainMenuPageWidget(),
      routes: <RouteBase>[
        GoRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Image.asset(
                        'assets/images/Screenshot_2024-01-30_at_9.58.21_AM.png',
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        height: MediaQuery.sizeOf(context).height * 1.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : const MainMenuPageWidget(),
        ),
        GoRoute(
          name: 'MedRecognitionPage',
          path: '/medRecognitionPage',
          builder: (BuildContext context, GoRouterState state) {
            return const MedRecognitionPageWidget();
          }
        ),
        GoRoute(
          name: 'ControlTTSPage',
          path: '/controlTTSPage',
          builder: (BuildContext context, GoRouterState state) {
            return const ControlTTSPageWidget();
          }
        ),
        GoRoute(
          name: 'AccessibilityChoicePage',
          path: '/accessibilityChoicePage',
          builder: (BuildContext context, GoRouterState state) {
            return const AccessibilityChoicePageWidget();
          }
        ),
        GoRoute(
          name: 'MainMenuPage',
          path: '/mainMenuPage',
          builder: (BuildContext context, GoRouterState state) {
            return const MainMenuPageWidget();
          }
        ),
        GoRoute(
          name: 'MedInfoPage',
          path: '/medInfoPage',
          builder: (BuildContext context, GoRouterState state) {
            return const MedInfoPageWidget();
          }
        ),
        GoRoute(
          name: 'SettingsMenuPage',
          path: '/settingsMenuPage',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsMenuPageWidget();
          }
        ),
        GoRoute(
          name: 'PickColorPage',
          path: '/pickColorPage',
          builder: (BuildContext context, GoRouterState state) {
            return const PickColorPageWidget();
          }
        ),
        GoRoute(
          name: 'AllergyListPage',
          path: '/allergyListPage',
          builder: (BuildContext context, GoRouterState state) {
            return const AllergyListPageWidget();
          }
        ),
        GoRoute(
          name: 'AllergyAddPage',
          path: '/allergyAddPage',
          builder: (BuildContext context, GoRouterState state) {
            return const AllergyAddPageWidget();
          }
        ),
        GoRoute(
          name: 'HelpPage',
          path: '/helpPage',
          builder: (BuildContext context, GoRouterState state) {
            return const HelpPageWidget();
          }
        ),
        GoRoute(
          name: 'PrescribedMedRecognitionPage',
          path: '/prescribedMedRecognitionPage',
          builder: (BuildContext context, GoRouterState state) {
            return const PrescribedMedRecognitionPageWidget();
          }
        ),
        GoRoute(
          name: 'PrescribedMedResultPage',
          path: '/prescribedMedResultPage',
          builder: (BuildContext context, GoRouterState state) {
            return const PrescribedMedResultPageWidget();
          }
        ),
      ],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class PKBParameters {
  PKBParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};


  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    if (param is! String) {
      return param;
    }
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class PKBRoute {
  const PKBRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, PKBParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final pkbParams = PKBParameters(state, asyncParams);
          final page = pkbParams.hasFutures
              ? FutureBuilder(
                  future: pkbParams.completeFutures(),
                  builder: (context, _) => builder(context, pkbParams),
                )
              : builder(context, pkbParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}