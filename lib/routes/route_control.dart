/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:sweyer/sweyer.dart';
import 'package:sweyer/constants.dart' as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class to control how routes are created
abstract class RouteControl {
  /// Needed to disable animations on some routes
  static String _currentRoute = Constants.Routes.main.value;

  /// Changes the value of `_currentRoute`
  static void _setCurrentRoute(String newValue) {
    _currentRoute = newValue;
  }

  /// Check the equality of `_currentRoute` to some value
  static bool _currentRouteEquals(String value) {
    return _currentRoute == value;
  }

  static Route<dynamic> handleOnUnknownRoute(RouteSettings settings) {
    //******** Unknown ********
    return RouteStackTransition(
      checkExitAnimationEnabled: () =>
          _currentRouteEquals(Constants.Routes.settings.value) ||
          _currentRouteEquals(Constants.Routes.extendedSettings.value) ||
          _currentRouteEquals(Constants.Routes.debug.value),
      checkEntAnimationEnabled: () => false,
      maintainState: true,
      routeSystemUI: () => Constants.AppSystemUIThemes.mainScreen
          .autoBr(ThemeControl.brightness),
      checkEnterSystemUI: () => Constants.AppSystemUIThemes.mainScreen
          .autoBr(ThemeControl.brightness),
      exitIgnoreEventsForward: false,
      route: Scaffold(
        // TODO: move to separate file
        body: Center(
          child: Text("Unknown route!"),
        ),
      ),
    );
  }

  static List<Route<dynamic>> handleOnGenerateInitialRoutes(String routeName) {
    // TODO: check out why this returns a list when docs release
    return [
      //******** Initial ********
      RouteZoomTransition(
        checkExitAnimationEnabled: () =>
            _currentRouteEquals(Constants.Routes.settings.value) ||
            _currentRouteEquals(Constants.Routes.extendedSettings.value) ||
            _currentRouteEquals(Constants.Routes.debug.value),
        checkEntAnimationEnabled: () => false,
        maintainState: true,
        routeSystemUI: () => Constants.AppSystemUIThemes.mainScreen
            .autoBr(ThemeControl.brightness),
        checkEnterSystemUI: () => Constants.AppSystemUIThemes.mainScreen
            .autoBr(ThemeControl.brightness),
        exitIgnoreEventsForward: false,
        route: InitialRoute(),
      )
    ];
  }

  static Route<dynamic> handleOnGenerateRoute(RouteSettings settings) {
    _setCurrentRoute(settings.name);

    //******** Debug ********
    if (settings.name == Constants.Routes.debug.value)
      return RouteZoomTransition(
        checkEnterSystemUI: () => Constants.AppSystemUIThemes.allScreens
            .autoBr(ThemeControl.brightness),
        checkExitSystemUI: () => Constants.AppSystemUIThemes.mainScreen
            .autoBr(ThemeControl.brightness),
        route: DebugRoute(),
      );
    //******** Exif ********
    else if (settings.name == Constants.Routes.exif.value)
      return RouteZoomTransition(
        route: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Constants.AppSystemUIThemes.allScreens
              .autoBr(ThemeControl.brightness),
          child: ExifRoute(),
        ),
      );
    //******** Extended settings ********
    else if (settings.name == Constants.Routes.extendedSettings.value)
      return RouteZoomTransition(
        checkEnterSystemUI: () => Constants.AppSystemUIThemes.allScreens
            .autoBr(ThemeControl.brightness),
        checkExitSystemUI: () => Constants.AppSystemUIThemes.allScreens
            .autoBr(ThemeControl.brightness),
        route: ExtendedSettingsRoute(),
      );
    //******** Player ********
    else if (settings.name == Constants.Routes.player.value) {
      // return RouteExpandTransition(route: PlayerRoute());
      return RouteZoomTransition(
        // entCurve: Curves.fastOutSlowIn,
        // entBegin: const Offset(0.0, 1.0),
        // transitionDuration: const Duration(milliseconds: 400),
        checkExitAnimationEnabled: () =>
            _currentRouteEquals(Constants.Routes.exif.value),
        checkEnterSystemUI: () => Constants.AppSystemUIThemes.allScreens
            .autoBr(ThemeControl.brightness),
        checkExitSystemUI: () => Constants.AppSystemUIThemes.mainScreen
            .autoBr(ThemeControl.brightness),
        route: PlayerRoute(),
      );
    }
    //******** Search ********
    else if (settings.name == Constants.Routes.search.value)
      return (settings.arguments as Map<String, Route>)["route"];
    //******** Settings ********
    else if (settings.name == Constants.Routes.settings.value)
      return RouteZoomTransition(
        checkEnterSystemUI: () => Constants.AppSystemUIThemes.allScreens
            .autoBr(ThemeControl.brightness),
        checkExitSystemUI: () => Constants.AppSystemUIThemes.mainScreen
            .autoBr(ThemeControl.brightness),
        route: SettingsRoute(),
      );

    return null;
  }
}
