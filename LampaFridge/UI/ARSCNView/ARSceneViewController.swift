//
//  ARSceneViewController.swift
//  LampaFrig
//
//  Created by Yurii Honcharov on 01.12.2023.
//

import UIKit
import ARKit
import SceneKit

class ARSceneViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: property
    var videoNodeManager: VideoNodeManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecognizers()
        setupScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        videoNodeManager?.stopVideo()
        videoNodeManager = nil
    }

    private func setupRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        sceneView.addGestureRecognizer(tap)
    }

    private func setupScene() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }

    private func configureSession() {
        let configuration = ARImageTrackingConfiguration()
        if let targetImages = ARReferenceImage.referenceImages(inGroupNamed: "Targets", bundle: .main) {
            configuration.trackingImages = targetImages
            configuration.maximumNumberOfTrackedImages = 10

            videoNodeManager = .init(sceneView: sceneView)
        }
        sceneView.session.run(configuration)
    }

    private func prepareTouch(_ tapLocation: CGPoint?) {
        guard let touchLocation = tapLocation else  {
            print("Touch location not found")
            return
        }
        let hitTest = sceneView.hitTest(touchLocation)
        if let hit = hitTest.first {
            videoNodeManager?.playVideo(for: hit.node)
        } else {
            print("no match")
        }
    }

    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if let sceneView = sender.view as? ARSCNView {
            let tapLocation = sender.location(in: sceneView)
            prepareTouch(tapLocation)
        }
    }

    @objc private func playerItemDidReachEnd(notification: NSNotification) {
        videoNodeManager?.stopVideo()
    }
}


extension ARSceneViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        if let imageAnchor = anchor as? ARImageAnchor {

            if let anchorName = imageAnchor.referenceImage.name {
                if let videoName: EventVideos = EventVideos(rawValue: anchorName) {
                    return videoNodeManager?.updateVideoNode(imageAnchor, videoName: videoName)
                }
                return nil
            }
            return nil
        }
        return nil
    }

    func addDefaultPlane(anchor: ARImageAnchor) -> SCNNode {
        let newNode = SCNNode()
        let planeMain = SCNPlane(width: anchor.referenceImage.physicalSize.width , height: anchor.referenceImage.physicalSize.height)
        planeMain.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)

        let planeNode = SCNNode(geometry: planeMain)
        planeNode.eulerAngles.x = -.pi / 2
        newNode.addChildNode(planeNode)

        return newNode
    }
}
