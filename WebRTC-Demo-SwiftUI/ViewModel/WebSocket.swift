//
//  WebSocket.swift
//  WebRTC-Demo-SwiftUI
//
//  Created by Sreekuttan D on 03/12/22.
//

import Foundation

protocol WebSocketDelegate: AnyObject {
    func webSocketDidConnect(_ webSocket: WebSocket)
    func webSocketDidDisconnect(_ webSocket: WebSocket)
    func webSocket(_ webSocket: WebSocket, didReceiveData data: Data)
}

/// handle the socket connections
class WebSocket: NSObject {
    
    weak var delegate: WebSocketDelegate?
    private let url: URL
    private var socket: URLSessionWebSocketTask?
    private lazy var urlSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

    init(url: URL) {
        self.url = url
        super.init()
    }

    func connect() {
        let socket = urlSession.webSocketTask(with: url)
        socket.resume()
        self.socket = socket
        self.readMessage()
    }

    func send(data: Data) {
        self.socket?.send(.data(data)) { _ in }
    }
    
    private func readMessage() {
        self.socket?.receive { [weak self] message in
            guard let self = self else { return }
            
            switch message {
            case .success(.data(let data)):
                self.delegate?.webSocket(self, didReceiveData: data)
                self.readMessage()
                
            case .success:
                debugPrint("Warning: Expected to receive data format but received a string. Check the websocket server config.")
                self.readMessage()

            case .failure:
                self.disconnect()
            }
        }
    }
    
    private func disconnect() {
        self.socket?.cancel()
        self.socket = nil
        self.delegate?.webSocketDidDisconnect(self)
    }
}

extension WebSocket: URLSessionWebSocketDelegate, URLSessionDelegate  {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.webSocketDidConnect(self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.disconnect()
    }
}
