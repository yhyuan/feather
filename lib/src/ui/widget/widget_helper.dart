import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetHelper {
  static Padding buildPadding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Padding(
        padding: buildEdgeInsets(
            left: left, top: top, right: right, bottom: bottom));
  }

  static EdgeInsets buildEdgeInsets(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  static LinearGradient buildGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.2, 0.99],
      colors: [
        // Colors are easy thanks to Flutter's Colors class.
        startColor,
        endColor,
      ],
    );
  }

  static Widget buildProgressIndicator() {
    return Center(
        key: Key("progress_indicator"),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ));
  }

  static Widget buildErrorWidget(
      {BuildContext context,
      ApplicationError applicationError,
      VoidCallback voidCallback,
      bool withRetryButton}) {
    String errorText = "";
    ApplicationLocalization localization = ApplicationLocalization.of(context);
    if (applicationError == ApplicationError.locationNotSelectedError) {
      errorText = localization.getText("error_location_not_selected");
    } else if (applicationError == ApplicationError.connectionError) {
      errorText = localization.getText("error_server_connection");
    } else if (applicationError == ApplicationError.apiError) {
      errorText = localization.getText("error_api");
    } else {
      errorText = localization.getText("error_unknown");
    }
    List<Widget> widgets = new List();
    widgets.add(Text(
      errorText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    ));
    if (withRetryButton) {
      widgets.add(FlatButton(
        child: Text(ApplicationLocalization.of(context).getText("retry"),
            style: Theme.of(context).textTheme.subtitle),
        onPressed: voidCallback,
      ));
    }

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
            key: Key("error_widget"),
            child: SizedBox(
                width: 250,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widgets))));
  }

  static LinearGradient buildGradientBasedOnDayCycle(int sunrise, int sunset) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int sunriseMs = sunrise * 1000;
    int sunsetMs = sunset * 1000;
    if (currentTime > sunriseMs && currentTime < sunsetMs) {
      return buildGradient(ApplicationColors.dayStartGradientColor,
          ApplicationColors.dayEndGradientColor);
    } else {
      return buildGradient(ApplicationColors.nightStartGradientColor,
          ApplicationColors.nightEndGradient);
    }
  }

  static LinearGradient getGradient({sunriseTime = 0, sunsetTime = 0}) {
    if (sunriseTime == 0 && sunsetTime == 0) {
      return WidgetHelper.buildGradient(
          ApplicationColors.nightStartGradientColor,
          ApplicationColors.nightEndGradient);
    } else {
      return buildGradientBasedOnDayCycle(sunriseTime, sunsetTime);
    }
  }
}
