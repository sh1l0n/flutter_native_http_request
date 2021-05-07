#import "HttpRequestPlugin.h"
#if __has_include(<http_request/http_request-Swift.h>)
#import <http_request/http_request-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "http_request-Swift.h"
#endif

@implementation HttpRequestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHttpRequestPlugin registerWithRegistrar:registrar];
}
@end
