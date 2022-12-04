//
//  ConnectionModel.swift
//  WebRTC-Demo-SwiftUI
//
//  Created by Sreekuttan D on 03/12/22.
//

import SwiftUI
import WebRTC

@MainActor
public class ConnectionModel: ObservableObject {
    
    private var webRTCClient: WebRTCClient
    
    private var signalClient: SignalingClient
    
    @Published public var signalingConnected: Bool = false
    
    @Published public var hasLocalSdp: Bool = false
    
    @Published public var localCandidateCount: Int = 0
    
    @Published public var hasRemoteSdp: Bool = false
    
    @Published public var remoteCandidateCount: Int = 0
    
    @Published public var speakerOn: Bool = false
    
    @Published public var mute: Bool = false
    
    @Published public var connectionState: RTCIceConnectionState = .checking
    
    @Published public var localVideoTrack: RTCVideoTrack? = nil
    
    @Published public var remoteVideoTrack: RTCVideoTrack? = nil
    
    init(webRTCClient: WebRTCClient, signalClient: SignalingClient) {
        self.webRTCClient = webRTCClient
        self.signalClient = signalClient
        
        localVideoTrack = webRTCClient.localVideoTrack
        remoteVideoTrack = webRTCClient.remoteVideoTrack
        
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
    }
    
    // start the socket connection
    public func connect() {
        if !signalingConnected {
            self.signalClient.connect()
        }
    }
    
    public func sendOffer() {
        self.webRTCClient.offer { sdp in
            Task { @MainActor in
                self.hasLocalSdp = true
            }
            self.signalClient.send(sdp: sdp)
        }
    }
    
    public func sendAnswer() {
        self.webRTCClient.answer { localSdp in
            Task{ @MainActor in
                self.hasLocalSdp = true
            }
            self.signalClient.send(sdp: localSdp)
        }
    }
    
    // Media controlls
    public func startCaptureLocalVideo() {
        self.webRTCClient.startCaptureLocalVideo()
    }
    
    public func toggleAudioMute() {
        if self.mute {
            self.webRTCClient.muteAudio()
        } else {
            self.webRTCClient.unmuteAudio()
        }
        mute.toggle()
    }
    
    public func toggleSpeakerOn() {
        if self.speakerOn {
            self.webRTCClient.speakerOff()
        }
        else {
            self.webRTCClient.speakerOn()
        }
        self.speakerOn.toggle()
    }
    
}

// MARK: - SignalClientDelegate
extension ConnectionModel: SignalClientDelegate {
    
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        Task { @MainActor in
            self.signalingConnected = true
        }
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        Task { @MainActor in
            self.signalingConnected = false
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
            Task { @MainActor in
                self.hasRemoteSdp = true
            }
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
        self.webRTCClient.set(remoteCandidate: candidate) { error in
            print("Received remote candidate")
            Task { @MainActor in
                self.remoteCandidateCount += 1
            }
        }
    }
    
}

// MARK: - WebRTCClientDelegate
extension ConnectionModel: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        Task { @MainActor in
            self.localCandidateCount += 1
        }
        self.signalClient.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        Task { @MainActor in
            self.connectionState = state
        }
    }
    
    // TODO: - Data transfer
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {

    }
}

