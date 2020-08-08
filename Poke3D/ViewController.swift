//
//  ViewController.swift
//  Poke3D
//
//  Created by Blair Petrachek on 2020-08-08.
//  Copyright © 2020 Blair Petrachek. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Allows SceneKit to automatically add lighting to the scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration looking for a specific image
        let configuration = ARImageTrackingConfiguration()

        let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main)
        
        if let images = imagesToTrack {
            configuration.trackingImages = images
            configuration.maximumNumberOfTrackedImages = 2
            print("Images Successfully Added.")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height:  imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            if let pokeScene = SCNScene(named: "art.scnassets/\(imageAnchor.referenceImage.name!).scn") {
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    // Rotate clockwise 90 degrees on the x-axis
                    pokeNode.eulerAngles.x = .pi / 2
                    planeNode.addChildNode(pokeNode)
                }
            }
        }
        
        return node
    }
}
