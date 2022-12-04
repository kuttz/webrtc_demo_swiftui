//
//  RendererView.swift
//  WebRTC-Demo-SwiftUI
//
//  Created by Sreekuttan D on 03/12/22.
//

import SwiftUI
import WebRTC

struct RendererView: UIViewRepresentable {
    
    @Binding var track: RTCVideoTrack?
    
    let videoContentMode: UIView.ContentMode
    
    func makeUIView(context: Context) -> RTCMTLVideoView {
        let videoView = RTCMTLVideoView()
        videoView.contentMode = videoContentMode
        return videoView
    }
    
    func updateUIView(_ uiView: RTCMTLVideoView, context: Context) {
        guard let track = track else {
            return
        }
        track.add(uiView)
    }
}

struct RendererView_Previews: PreviewProvider {
    static var previews: some View {
        RendererView(track: .constant(nil), videoContentMode: .scaleAspectFill)
    }
}
