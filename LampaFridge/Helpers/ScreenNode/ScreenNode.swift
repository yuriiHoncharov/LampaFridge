//
//  ScreenNode.swift
//  LampaARPresentationApp
//
//  Created by mac on 11/24/23.
//

import ARKit

protocol VideoPlayerProtocol {
    mutating func startPlayer() -> SCNNode?
    mutating func stopPlayer()
    mutating func playVideo(from button: SCNNode)
}

class SingleScreenPlayer {
    let idleScene: SCNScene? = {
        return SCNScene(named: BaseConstants.scene)
    }()
}

extension SingleScreenPlayer: VideoPlayerProtocol {
    
    func startPlayer() -> SCNNode? {
        let player: SCNNode? = {
            guard let idleScene else { return nil }
            guard let playerNode = idleScene.rootNode.childNode(withName: VideoConstants.plane, recursively: false) else { return nil }
            return playerNode
        }()
        return player
    }
    
    func stopPlayer() {}
    
    func playVideo(from button: SCNNode) {}
}
