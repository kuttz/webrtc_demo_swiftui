//
//  VideoView.swift
//  WebRTC-Demo-SwiftUI
//
//  Created by Sreekuttan D on 03/12/22.
//

import SwiftUI

struct VideoView: View {
    
    @ObservedObject var model: ConnectionModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RendererView(track: $model.remoteVideoTrack, videoContentMode: .scaleAspectFill)
            RendererView(track: $model.localVideoTrack, videoContentMode: .scaleAspectFill)
                .frame(width: 100, height: 100, alignment: .bottomTrailing)
                .padding()
        }
        .padding()
    }
}

struct VideoView_Previews: PreviewProvider {
    
    struct Preview: View {
        @StateObject private var model = ConnectionModel(webRTCClient: WebRTCClient(iceServers: Config.default.webRTCIceServers),
                                                         signalClient: SignalingClient(webSocket: WebSocket(url: Config.default.signalingServerUrl)))
        var body: some View {
            VideoView(model: model)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
