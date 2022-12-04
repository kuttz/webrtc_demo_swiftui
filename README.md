
# WebRTC-Demo-SwiftUI

Sample code to create a WebRTC based video conferencing interface in SwiftUI. This is not a production
ready code!. 






![App Screenshot](https://raw.githubusercontent.com/kuttz/webrtc_demo_swiftui/main/ScreenShot.jpg)


## Requirements


1. Xcode 12.1 or later
2. iOS 14.1 or later
## Setup Project

1. Setup a signaling server.

You can use the [SignalingServer](https://github.com/kuttz/signaling_server) to create a local server.

2. Open the `Config.swift` and set the `defaultSignalingServerUrl` variable to your signaling server ip/host. Don't use `localhost` or `127.0.0.1`.

3. Build and run on device or on a simulator (simulator does not support video capture)


## Demo

https://raw.githubusercontent.com/kuttz/webrtc_demo_swiftui/main/Demo.gif
## Related

Here is a related project

[SignalingServer](https://github.com/kuttz/signaling_server)


## Reference

- [WebRTC website](https://webrtc.org/)
- [WebRTC source code](https://webrtc.googlesource.com/src)
- [WebRTC iOS compile guide](https://webrtc.github.io/webrtc-org/native-code/ios/)
- [WebRTC Binaries for iOS and macOS](https://github.com/stasel/WebRTC)
- [WebRTC-iOS](https://github.com/stasel/WebRTC-iOS)
## Credits

Orginal code reference [WebRTC-iOS](https://github.com/stasel/WebRTC-iOS) by [@stasel](https://github.com/stasel)