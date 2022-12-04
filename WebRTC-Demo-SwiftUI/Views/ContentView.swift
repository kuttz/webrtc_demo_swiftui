//
//  ContentView.swift
//  WebRTC-Demo-SwiftUI
//
//  Created by Sreekuttan D on 03/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model: ConnectionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Signaling status:")
                Text(model.signalingConnected ? "Connected" : "Not connected").foregroundColor(model.signalingConnected ? .green : .red)
            }
            HStack {
                Text("Local SDP:")
                Text(model.hasLocalSdp ? "✅" : "❌")
            }
            Text("Local Candidates: \(model.localCandidateCount)")
            HStack {
                Text("Remote SDP:")
                Text(model.hasRemoteSdp ? "✅" : "❌")
            }
            Text("Local Candidates: \(model.remoteCandidateCount)")
            HStack {
                Text("WebRTC Status:")
                Text(model.connectionState.description.capitalized).bold()
            }
            Spacer()
            HStack {
                Group {
                    Spacer()
                    Button {
                        model.toggleAudioMute()
                    } label: {
                        model.mute ? Image(systemName: "mic.slash.fill") : Image(systemName: "mic.fill")
                    }
                    Spacer()
                    Spacer()
                    Button {
                        model.toggleSpeakerOn()
                    } label: {
                        model.speakerOn ? Image(systemName: "speaker.wave.3.fill") : Image(systemName: "speaker.fill")
                        
                    }
                    Spacer()
                }
                .font(.title)
            }.padding()
            Spacer()
            HStack {
                Spacer()
                Button("Send Offer") {
                    model.sendOffer()
                }
                Spacer()
                Button("Send Answer") {
                    model.sendAnswer()
                }
                Spacer()
            }
        }
        .padding()
        .onAppear {
            model.connect()
            model.startCaptureLocalVideo()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    struct Preview: View {
        @StateObject private var model = ConnectionModel(webRTCClient: WebRTCClient(iceServers: Config.default.webRTCIceServers),
                                                         signalClient: SignalingClient(webSocket: WebSocket(url: Config.default.signalingServerUrl)))
        var body: some View {
            ContentView(model: model)
        }
    }
    
    
    static var previews: some View {
        Preview()
    }
}
