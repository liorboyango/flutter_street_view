//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_google_street_view/FlutterGoogleStreetViewPlugin.h>)
#import <flutter_google_street_view/FlutterGoogleStreetViewPlugin.h>
#else
@import flutter_google_street_view;
#endif

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<pointer_interceptor_ios/PointerInterceptorIosPlugin.h>)
#import <pointer_interceptor_ios/PointerInterceptorIosPlugin.h>
#else
@import pointer_interceptor_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterGoogleStreetViewPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterGoogleStreetViewPlugin"]];
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [PointerInterceptorIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"PointerInterceptorIosPlugin"]];
}

@end
