//
//  CustomARView.swift
//  ARithmetic
//
//  Created by Elana Chen-Jones on 12/28/22.
//

import ARKit
import RealityKit
import SwiftUI

class CustomARView: ARView, ObservableObject {
    @Published var count = Int()
    var anchor1 = AnchorEntity(plane: .horizontal)
    var anchor2 = AnchorEntity(plane: .horizontal)
    var anchor3 = AnchorEntity(plane: .horizontal)
    var blocks = [ModelEntity]()
    var blocksInPlane = false
    var planeEntity = ModelEntity()
    var addition = false
    var subtraction = false
    var num1 = 0
    var num2 = 0
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This is the init that is actually used
    convenience init(addition: Bool, subtraction: Bool) {
        self.init(frame: UIScreen.main.bounds)
        reset(addition: addition, subtraction: subtraction)
    }
    
    func reset(addition: Bool, subtraction: Bool) {
        self.count = 0
        self.addition = addition
        self.subtraction = subtraction
        
        self.blocks.removeAll()
        scene.removeAnchor(anchor1)
        scene.removeAnchor(anchor2)
        scene.removeAnchor(anchor3)
        anchor1 = AnchorEntity(plane: .horizontal)
        anchor2 = AnchorEntity(plane: .horizontal)
        anchor3 = AnchorEntity(plane: .horizontal)
        
        num1 = Int.random(in: 1...5)
        num2 = Int.random(in: 1...5)
        if subtraction {
            while num1 == num2 {
                num2 = Int.random(in: 1...5)
            }
            if num1 < num2 {
                print("switching num1 (\(num1)) and num2 (\(num2))!")
                let temp = num1
                num1 = num2
                num2 = temp
            }
        }
        else if addition {
            placeBlockBehindPlane(num: num2)
        }
        print("num1 = \(num1)")
        print("num2 = \(num2)")
        
        placeBlockOnPlane(num: num1)
        placePlane()
        checkBlocks()
    }
    
    func placeBlockBehindPlane(num: Int) {
        if (num > 5) {
            print("You're not ready to count to 11 yet")
        }
        else if (num < 0) {
            print("You're not ready to count below 0 yet")
        }
        else {
            let size = 0.1
            var offset: Double = 0.05
            let x: Double = -3 / 4 * size * Double(num)
            //let anchor = AnchorEntity(plane: .horizontal)
            for _ in 1...num {
                let block = MeshResource.generateBox(size: 0.1)
                //let material = SimpleMaterial(color: UIColor(Color.random()), isMetallic: false)
                let material = SimpleMaterial(color: UIColor(Color("BlueColor")), isMetallic: false)
                let entity = ModelEntity(mesh: block, materials: [material])
                entity.transform = Transform()
                entity.transform.translation = SIMD3<Float>(x: Float(x + offset), y: 0.05, z: -0.5)
                anchor1.addChild(entity)
                offset += 3 * size / 2
                
                entity.generateCollisionShapes(recursive: true)
                installGestures([.translation, .rotation], for: entity)
                
                blocks.append(entity)
            }
            scene.addAnchor(anchor1)
        }
    }
    
    func placeBlockOnPlane(num: Int) {
        if (num > 5) {
            print("You're not ready to count to 11 yet")
        }
        else if (num < 0) {
            print("You're not ready to count below 0 yet")
        }
        else {
            let size = 0.1
            var offset: Double = 0.05
            let x: Double = -3 / 4 * size * Double(num)
            //let anchor = AnchorEntity(plane: .horizontal)
            for _ in 1...num {
                let block = MeshResource.generateBox(size: 0.1)
                //let material = SimpleMaterial(color: UIColor(Color.random()), isMetallic: false)
                let material = SimpleMaterial(color: UIColor(Color("BlueColor")), isMetallic: false)
                let entity = ModelEntity(mesh: block, materials: [material])
                entity.transform = Transform()
                entity.transform.translation = SIMD3<Float>(x: Float(x + offset), y: 0.05, z: 0)
                anchor2.addChild(entity)
                offset += 3 * size / 2
                
                entity.generateCollisionShapes(recursive: true)
                installGestures([.translation, .rotation], for: entity)
                
                blocks.append(entity)
            }
            scene.addAnchor(anchor2)
        }
    }
    
    func placePlane() {
        let plane = MeshResource.generatePlane(width: 0.8, depth: 0.5)
        let material = SimpleMaterial(color: UIColor(Color("GrayColor")), isMetallic: false)
        planeEntity = ModelEntity(mesh: plane, materials: [material])
        //let anchor = AnchorEntity(plane: .horizontal)
        anchor3.addChild(planeEntity)
        scene.addAnchor(anchor3)
    }
    
    func checkBlocks() {
        for block in self.blocks {
            if (block.position.x >= self.planeEntity.position.x - (0.75 / 2)) &&
                (block.position.z >= self.planeEntity.position.z - (0.5 / 2)) &&
                (block.position.x <= self.planeEntity.position.x + (0.75 / 2)) &&
                (block.position.z <= self.planeEntity.position.z + (0.5 / 2)) {
                self.count += 1
                print("count = \(self.count)\n")
            }
        }
    }
    
    override dynamic func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.count = 0
            self.checkBlocks()
            if self.addition {
                if self.count == self.num1 + self.num2 {
                    self.blocksInPlane = true
                    print("\(self.num1) + \(self.num2) = \(self.count)")
                }
            }
            else if self.subtraction {
                if self.count == self.num1 - self.num2 {
                    self.blocksInPlane = true
                    print("\(self.num1) - \(self.num2) = \(self.count)")
                }
            }
        }
    }
}

public extension Color {
    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
