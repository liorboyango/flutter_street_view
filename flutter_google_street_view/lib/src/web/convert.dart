import 'dart:core';
import 'dart:js_interop';

import 'package:google_maps/google_maps.dart' as gmaps;
import 'package:google_maps/google_maps_streetview.dart' as street_view;

/// Convert StreetViewPanoramaOptions to StreetViewPanoramaOptions of street_view
Future<street_view.StreetViewPanoramaOptions> toStreetViewPanoramaOptions(
    Map<String, dynamic> arg,
    {street_view.StreetViewPanorama? current}) async {
  final result = street_view.StreetViewPanoramaOptions();
  String? errorMsg;
  var request;
  double? raduis = arg['radius'] as double?;
  String? source = arg['source'] as String?;
  gmaps.LatLng? location;
  String? pano;
  if (arg['panoId'] != null) {
    pano = arg['panoId'];
    request = street_view.StreetViewPanoRequest()..pano = pano;
  } else {
    location = gmaps.LatLng(arg['position'][0], arg['position'][1]);
    final sourceTmp = source == "outdoor"
        ? street_view.StreetViewSource.OUTDOOR
        : street_view.StreetViewSource.DEFAULT;
    request = street_view.StreetViewLocationRequest()
      ..location = location
      ..radius = raduis
      ..source = sourceTmp;
  }

  final data = await street_view.StreetViewService().getPanorama(request);
  if (data.data.location == null) {
    errorMsg = location != null
        ? "Oops..., no valid panorama found with position:${location.lat}, ${location.lng}, try to change `position`, `radius` or `source`."
        : pano != null
            ? "Oops..., no valid panorama found with panoId:$pano, try to change `panoId`."
            : "setPosition, catch unknown error.";
  } else {
    if (location != null) {
      result.position = data.data.location!.latLng;
    } else {
      result.pano = data.data.location!.pano;
    }
  }

  result.showRoadLabels = arg['streetNamesEnabled'] as bool? ?? true;
  result.clickToGo = arg['clickToGo'] as bool? ?? true;
  result.zoomControl = arg['zoomControl'] as bool? ?? true;

  result.addressControl = arg['addressControl'] as bool? ?? true;
  result.addressControlOptions = toStreetViewAddressControlOptions(arg);
  result.disableDefaultUI = arg['disableDefaultUI'] as bool? ?? true;
  result.disableDoubleClickZoom =
      arg['disableDoubleClickZoom'] as bool? ?? true;
  result.enableCloseButton = arg['enableCloseButton'] as bool? ?? true;
  result.fullscreenControl = arg['fullscreenControl'] as bool? ?? true;
  result.fullscreenControlOptions = toFullscreenControlOptions(arg);
  result.linksControl = arg['linksControl'] as bool? ?? true;
  result.motionTracking = arg['motionTracking'] as bool? ?? true;
  result.motionTrackingControl = arg['motionTrackingControl'] as bool? ?? true;
  result.motionTrackingControlOptions = toMotionTrackingControlOptions(arg);
  result.scrollwheel = arg['scrollwheel'] as bool? ?? true;
  result.panControl = arg['panControl'] as bool? ?? true;
  result.panControlOptions = toPanControlOptions(arg);
  result.zoomControlOptions = toZoomControlOptions(arg);
  result.visible = arg['visible'] as bool? ?? true;

  final currentPov = current?.pov;
  result.pov = street_view.StreetViewPov()
    ..heading = arg['bearing'] ?? currentPov?.heading ?? 0
    ..pitch = arg['tilt'] ?? currentPov?.pitch ?? 0;
  result.zoom = arg['zoom'] as double?;
  if (errorMsg != null) {
    throw NoStreetViewException(options: result, errorMsg: errorMsg);
  } else {
    return result;
  }
}

street_view.StreetViewSource toStreetSource(Map<String, dynamic> arg) {
  final source = arg['source'];
  return source == "outdoor"
      ? street_view.StreetViewSource.OUTDOOR
      : street_view.StreetViewSource.DEFAULT;
}

street_view.StreetViewAddressControlOptions? toStreetViewAddressControlOptions(
    dynamic arg) {
  final pos = arg is Map ? arg["addressControlOptions"] : arg;
  return street_view.StreetViewAddressControlOptions()
    ..position = toControlPosition(pos);
}

gmaps.FullscreenControlOptions? toFullscreenControlOptions(dynamic arg) {
  final pos = arg is Map ? arg["fullscreenControlOptions"] : arg;
  return gmaps.FullscreenControlOptions()..position = toControlPosition(pos);
}

gmaps.MotionTrackingControlOptions? toMotionTrackingControlOptions(
    dynamic arg) {
  final pos = arg is Map ? arg["motionTrackingControlOptions"] : arg;
  return gmaps.MotionTrackingControlOptions()
    ..position = toControlPosition(pos);
}

gmaps.PanControlOptions? toPanControlOptions(dynamic arg) {
  final pos = arg is Map ? arg["panControlOptions"] : arg;
  return gmaps.PanControlOptions()..position = toControlPosition(pos);
}

gmaps.ZoomControlOptions? toZoomControlOptions(dynamic arg) {
  final pos = arg is Map ? arg["zoomControlOptions"] : arg;
  return gmaps.ZoomControlOptions()..position = toControlPosition(pos);
}

gmaps.ControlPosition? toControlPosition(String? position) {
  return position == "bottom_center"
      ? gmaps.ControlPosition.BOTTOM_CENTER
      : position == "bottom_left"
          ? gmaps.ControlPosition.BOTTOM_LEFT
          : position == "bottom_right"
              ? gmaps.ControlPosition.BOTTOM_RIGHT
              : position == "left_bottom"
                  ? gmaps.ControlPosition.LEFT_BOTTOM
                  : position == "left_center"
                      ? gmaps.ControlPosition.LEFT_CENTER
                      : position == "left_top"
                          ? gmaps.ControlPosition.LEFT_TOP
                          : position == "right_bottom"
                              ? gmaps.ControlPosition.RIGHT_BOTTOM
                              : position == "right_center"
                                  ? gmaps.ControlPosition.RIGHT_CENTER
                                  : position == "right_top"
                                      ? gmaps.ControlPosition.RIGHT_TOP
                                      : position == "top_center"
                                          ? gmaps.ControlPosition.TOP_CENTER
                                          : position == "top_left"
                                              ? gmaps.ControlPosition.TOP_LEFT
                                              : position == "top_right"
                                                  ? gmaps
                                                      .ControlPosition.TOP_RIGHT
                                                  : null;
}

Map<String, dynamic> streetViewPanoramaLocationToJson(
        street_view.StreetViewPanorama panorama) =>
    linkToJson(panorama.links.toDart)
      ..["panoId"] = panorama.pano
      ..addAll(positionToJson(panorama.position));

Map<String, dynamic> streetViewPanoramaCameraToJson(
        street_view.StreetViewPanorama panorama) =>
    {
      "bearing": panorama.pov.heading,
      "tilt": panorama.pov.pitch,
      "zoom": panorama.zoom
    };

Map<String, dynamic> positionToJson(gmaps.LatLng? position) => {
      "position": (position != null ? [position.lat, position.lng] : null)
    };

Map<String, dynamic> linkToJson(List<street_view.StreetViewLink?>? links) {
  List links1 = [];
  if (links != null) {
    links.forEach((l) {
      if (l != null) links1.add([l.pano, l.heading]);
    });
  }
  return {"links": links1};
}

class NoStreetViewException implements Exception {
  final street_view.StreetViewPanoramaOptions options;
  final String errorMsg;

  NoStreetViewException({required this.options, required this.errorMsg});
}
