//
//  WebRTC_Demo_SwiftUIApp.swift
//  WebRTC-Demo-SwiftUI
//
//  Created by Sreekuttan D on 03/12/22.
//

import SwiftUI

@main
struct WebRTC_Demo_SwiftUIApp: App {
    
    @StateObject private var model = ConnectionModel(webRTCClient: WebRTCClient(iceServers: Config.default.webRTCIceServers),
                                                     signalClient: SignalingClient(webSocket: WebSocket(url: Config.default.signalingServerUrl)))
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(model: model)
                VideoView(model: model)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
