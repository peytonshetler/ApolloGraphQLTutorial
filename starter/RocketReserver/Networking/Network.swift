//
//  Network.swift
//  RocketReserver
//
//  Created by Peyton Shetler on 1/22/24.
//

import Foundation
import Apollo
import ApolloWebSocket

// Apollo Docs say it's best for this to be a singleton
class Network {
  static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        
        // Websocket / Subscription support
        let webSocket = WebSocket(
            url: URL(string: "wss://apollo-fullstack-tutorial.herokuapp.com/graphql")!,
            protocol: .graphql_ws
        )
        let webSocketTransport = WebSocketTransport(websocket: webSocket)
        let splitTransport = SplitNetworkTransport(
            uploadingNetworkTransport: transport,
            webSocketNetworkTransport: webSocketTransport
        )
        
        return ApolloClient(networkTransport: splitTransport, store: store)
    }()
}
