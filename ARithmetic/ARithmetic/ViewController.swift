//
//  ViewController.swift
//  ARithmetic
//
//  Created by Elana Chen-Jones on 12/25/22.
//

import Foundation
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Properties
    var sceneView: ARSCNView!
    var balloonNode: SCNNode!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the ARSCNView
        sceneView = ARSCNView(frame: view.frame)
        sceneView.delegate = self
        view.addSubview(sceneView)

        // Show the feature points and the world origin
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        // Load the balloon model
        let balloonScene = SCNScene(named: "art.scnassets/balloon.scn")!
        balloonNode = balloonScene.rootNode.childNode(withName: "balloon", recursively: true)!

        // Run the AR session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // If the anchor is a plane anchor, add the balloon to the scene
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            node.addChildNode(planeNode)

            // Add the balloon to the scene and position it above the plane
            balloonNode.position = SCNVector3Make(planeAnchor.center.x, 0.2, planeAnchor.center.z)
            node.addChildNode(balloonNode)

            // Animate the balloon to float in midair
            let floatAnimation = CABasicAnimation(keyPath: "position.y")
            floatAnimation.byValue = 0.1
            floatAnimation.repeatCount = Float.infinity
            floatAnimation.autoreverses = true
            floatAnimation.duration = 0.5
            balloonNode.addAnimation(floatAnimation, forKey: "float")
        }
    }
}
