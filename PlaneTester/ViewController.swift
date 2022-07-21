//
//  ViewController.swift
//  PlaneTester
//
//  Created by Joe Andolina on 7/20/22.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPlaneDetection()
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        arView.debugOptions = [.showFeaturePoints, .showAnchorGeometry]
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        let touch = recognizer.location(in: arView)
        let result = arView.raycast(from: touch, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let first = result.first  {
            let worldPos = simd_make_float3(first.worldTransform.columns.3)
            let object = createObject()
            
            placeObject(object: object, at: worldPos)
        }
    }
    
    func startPlaneDetection(){
        arView.automaticallyConfigureSession = true
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
    }
    
    func createObject() -> ModelEntity {
        let object = MeshResource.generateSphere(radius: 0.15)
        let mat = SimpleMaterial(color: .green, roughness: 0, isMetallic: true)
        
        return ModelEntity(mesh: object, materials: [mat])
    }
    
    func placeObject(object:ModelEntity, at location:SIMD3<Float>){
        let anchor = AnchorEntity(world: location)
        anchor.addChild(object)
        arView.scene.addAnchor(anchor)
    }
}
