//
//  VideoNodeManager.swift
//  LampaARPresentationApp
//
//  Created by mac on 11/8/23.
//

import ARKit

enum EventVideos: String {
    case zeroImage = "IMAGE0"
    case firstImage = "IMAGE1"
    case secondImage = "IMAGE2"
    case thirdImage = "IMAGE3"
    case fourthImage = "IMAGE4"
    case fifthImage = "IMAGE5"
    case sixthImage = "IMAGE6"
    case seventhImage = "IMAGE7"
    case eighthImage = "IMAGE8"
    case ninthImage = "IMAGE9"
    case tenthImage = "IMAGE10"
    case eleventhImage = "IMAGE11"
    case twelfthImage = "IMAGE12"
    case thirteenthImage = "IMAGE13"
    case fourteenthImage = "IMAGE14"
    case fifteenthImage = "IMAGE15"
    case sixteenthImage = "IMAGE16"
    case seventeenthImage = "IMAGE17"
    case eighteenthImage = "IMAGE18"
    case nineteenthImage = "IMAGE19"
    case twentiethImage = "IMAGE20"
    case twentyFirstImage = "IMAGE21"
    case twentySecondImage = "IMAGE22"
    case twentyThirdImage = "IMAGE23"
    case twentyFourthImage = "IMAGE24"
    case twentyFifthImage = "IMAGE25"
    case twentySixthImage = "IMAGE26"
    case twentySeventhImage = "IMAGE27"
    case twentyEighthImage = "IMAGE28"
    case twentyNinthImage = "IMAGE29"
    case thirtiethImage = "IMAGE30"
    case thirtyFirstImage = "IMAGE31"
    case thirtySecondImage = "IMAGE32"
    case thirtyThirdImage = "IMAGE33"
    case thirtyFourthImage = "IMAGE34"
    case thirtyFifthImage = "IMAGE35"
    case thirtySixthImage = "IMAGE36"

    var videoName: String {
        switch self {
        case .zeroImage:
            return "VIDEO0.mp4"
        case .firstImage:
            return "VIDEO1.mp4"
        case .secondImage:
            return "VIDEO2.mp4"
        case .thirdImage:
            return "VIDEO3.mp4"
        case .fourthImage:
            return "VIDEO4.mp4"
        case .fifthImage:
            return "VIDEO5.mp4"
        case .sixthImage:
            return "VIDEO6.mp4"
        case .seventhImage:
            return "VIDEO7.mp4"
        case .eighthImage:
            return "VIDEO8.mp4"
        case .ninthImage:
            return "VIDEO9.mp4"
        case .tenthImage:
            return "VIDEO10.mp4"
        case .eleventhImage:
            return "VIDEO11.mp4"
        case .twelfthImage:
            return "VIDEO12.mp4"
        case .thirteenthImage:
            return "VIDEO13.mp4"
        case .fourteenthImage:
            return "VIDEO14.mp4"
        case .fifteenthImage:
            return "VIDEO15.mp4"
        case .sixteenthImage:
            return "VIDEO16.mp4"
        case .seventeenthImage:
            return "VIDEO17.mp4"
        case .eighteenthImage:
            return "VIDEO13.mp4"
        case .nineteenthImage:
            return "VIDEO19.mp4"
        case .twentiethImage:
            return "VIDEO20.mp4"
        case .twentyFirstImage:
            return "VIDEO21.mp4"
        case .twentySecondImage:
            return "VIDEO22.mp4"
        case .twentyThirdImage:
            return "VIDEO23.mp4"
        case .twentyFourthImage:
            return "VIDEO24.mp4"
        case .twentyFifthImage:
            return "VIDEO25.mp4"
        case .twentySixthImage:
            return "VIDEO26.mp4"
        case .twentySeventhImage:
            return "VIDEO27.mp4"
        case .twentyEighthImage:
            return "VIDEO28.mp4"
        case .twentyNinthImage:
            return "VIDEO29.mp4"
        case .thirtiethImage:
            return VideoConstants.defaultVideoName
        case .thirtyFirstImage:
            return VideoConstants.defaultVideoName
        case .thirtySecondImage:
            return VideoConstants.defaultVideoName
        case .thirtyThirdImage:
            return VideoConstants.defaultVideoName
        case .thirtyFourthImage:
            return VideoConstants.defaultVideoName
        case .thirtyFifthImage:
            return VideoConstants.defaultVideoName
        case .thirtySixthImage:
            return VideoConstants.defaultVideoName
        }
    }
}

struct VideoNodeManager {
    weak var sceneView: ARSCNView?
    var singleScreenPlayer: VideoPlayerProtocol?
    var videoNodes: [ARImageAnchor : SCNNode] = [:]
    var videoPlayers: [String : AVPlayer] = [:]

    var activePlayerName: String?

    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }

    mutating func updateVideoNode(_ anchor: ARImageAnchor, videoName: EventVideos) -> SCNNode {
        let node: SCNNode = {
            if let existingNode = videoNodes[anchor] {
                return existingNode
            }

            let newNode = SCNNode()
            singleScreenPlayer = SingleScreenPlayer()

            if let player = singleScreenPlayer?.startPlayer() {
                let planeMain = SCNPlane(width: anchor.referenceImage.physicalSize.width, height: anchor.referenceImage.physicalSize.height)
                let screenMaterial = SCNMaterial()
                screenMaterial.name = BaseConstants.screen
                screenMaterial.diffuse.contents = UIColor.white
                planeMain.firstMaterial = screenMaterial

                planeMain.firstMaterial?.diffuse.contents = addThumbnail()
                player.geometry = planeMain
                player.name = videoName.rawValue

                newNode.addChildNode(player)
                videoNodes[anchor] = newNode
            }

            return newNode
        }()

        return node
    }

    mutating func playVideo(for node: SCNNode) {
        guard let name = node.name else {
            print("Not found node name")
            return
        }

        if activePlayerName != nil && name != activePlayerName {
            stopVideo()
        }

        if name == activePlayerName {
            stopVideo()
        } else {
            guard let videoName = EventVideos(rawValue: name) else { return }

            let material: SCNMaterial? = node.geometry?.material(named: BaseConstants.screen)
            material?.diffuse.contents = createVideoMaterial(for: videoName, fallbackImage: AssetsConstants.lampaLogo)

            let playNode = node.parent?.childNode(withName: BaseConstants.play, recursively: true)
            playNode?.isHidden = true

            let player = videoPlayers[videoName.rawValue]
            activePlayerName = videoName.rawValue
            player?.play()
        }
    }

    mutating func stopVideo() {
        guard let activePlayerName else { return }

        if let player = videoPlayers[activePlayerName] {
            player.pause()
        }

        videoNodes.values.forEach({
            if let screen = $0.childNode(withName: activePlayerName, recursively: true) {
                if let material = screen.geometry?.material(named: BaseConstants.screen) {
                    let playNode = screen.parent?.childNode(withName: BaseConstants.play, recursively: true)
                    playNode?.isHidden = false
                    material.diffuse.contents = addThumbnail()
                }
            }
        })
        videoPlayers[activePlayerName] = nil
        self.activePlayerName = nil
    }

    private mutating func createVideoMaterial(for video: EventVideos, fallbackImage: UIImage? = nil) -> SKScene {
        guard let videoURL = Bundle.main.url(forResource: video.videoName, withExtension: nil) else {
            return createFallbackScene(fallbackImage: fallbackImage)
        }
        return createVideoScene(videoURL: videoURL, video: video)
    }

    private func createFallbackScene(fallbackImage: UIImage?) -> SKScene {
        let screenSize = UIScreen.main.bounds.size

        if let fallbackImage = fallbackImage {
            let fallbackScene = SKScene(size: CGSize(width: screenSize.width * 4.5, height: screenSize.height * 4))
            fallbackScene.backgroundColor = .baseWhite
            let imageNode = createImageNode(with: fallbackImage, scene: fallbackScene)

            fallbackScene.addChild(imageNode)
            return fallbackScene
        }

        return SKScene(size: screenSize)
    }

    private func createImageNode(with image: UIImage, scene: SKScene) -> SKSpriteNode {
        let imageNode = SKSpriteNode(texture: SKTexture(image: image))
        imageNode.yScale = -1
        imageNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        return imageNode
    }

    private mutating func createVideoScene(videoURL: URL, video: EventVideos) -> SKScene {
        let size = CGSize(width: 1920, height: 1080)
        let resolution = resolutionForLocalVideo(url: videoURL)
        let videoScene = SKScene(size: resolution ?? size)
        videoScene.scaleMode = .aspectFit

        let videoNode = createVideoNode(with: videoURL, scene: videoScene, video: video)

        videoScene.addChild(videoNode)
        return videoScene
    }

    private mutating func createVideoNode(with videoURL: URL, scene: SKScene, video: EventVideos) -> SKVideoNode {
        let player = AVPlayer(url: videoURL)
        let videoNode = SKVideoNode(avPlayer: player)
        videoNode.yScale = -1
        videoNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)

        videoPlayers[video.rawValue] = player

        return videoNode
    }

    private mutating func addThumbnail() -> UIColor {
        let thumb = UIImage(systemName: BaseConstants.playCircle)
        thumb?.ciImage?.transformed(by: CGAffineTransform(scaleX: 2, y: 3))
        return UIColor.white.withAlphaComponent(0.5)
    }

    private mutating func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

extension CAAnimation {
    class func animationWithSceneName(name: String) -> CAAnimation? {
        var animation: CAAnimation?
        if let scene = SCNScene(named: name) {
            scene.rootNode.enumerateChildNodes { child, stop in
                if child.animationKeys.count > 0 {
                    if let animationKey = child.animationKeys.first {
                        animation = child.value(forKey: animationKey) as? CAAnimation
                        stop.initialize(to: true)
                    }
                }
            }
        }
        return animation
    }
}
