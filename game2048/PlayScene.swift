//
// MIT License
//
// Copyright (c) 2019 Yang Song
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  PlayScene.swift
//  game2048
//
//  Created by Kane on 2019/4/12.
//

import SpriteKit
import GameplayKit

class PlayScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private let row : Int = 4
    private let col : Int = 4
    private let Matrix : Algri = Algri.init()
    private var lastUpdateTime : TimeInterval = 0
    private var trackingAreas : [NSTrackingArea] = []
    private var trackingFrames : [CGRect] = []
    private var currentPos : CGPoint?
    private var backLabel : SKLabelNode?
    private var scoreLabel : SKLabelNode?
    private var played : Bool = false
    private var textures : [SKTexture] = []
    
    // 1. Add trackingArea to skView and remove them after scene changed
    override func didMove(to view: SKView) {
        for frame in trackingFrames {
            let areaOrigin = view.convert(frame.origin, from: self)
            let areaSize = CGSize(width: frame.size.width*0.7, height: frame.size.height*0.7)
            let viewFrame = CGRect.init(origin: areaOrigin, size: areaSize)
            let optlist = [.mouseEnteredAndExited, .activeInKeyWindow] as NSTrackingArea.Options
            let setTracking = NSTrackingArea.init(rect: viewFrame, options: optlist, owner: self, userInfo: nil)
            trackingAreas.append(setTracking)
            view.addTrackingArea(setTracking)
        }
    }
    // 2. Remove TrackingArea when scene switch out
    override func willMove(from view: SKView) {
        for trackingArea in trackingAreas {
            view.removeTrackingArea(trackingArea)
        }
    }
    
    override func sceneDidLoad() {
        var metaBall : SKSpriteNode
        var texture : SKTexture
        var suffix : String
        var x : CGFloat = 0
        var y : CGFloat = 180
        let step : CGFloat = 120
        
        self.lastUpdateTime = 0
        // Get label node from scene and store it for use later
        self.backLabel = self.childNode(withName: "backLabel") as? SKLabelNode
        self.trackingFrames.append(self.backLabel!.frame)
        self.currentPos = self.backLabel?.position
        self.scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        // Generate textures for metaball
        for s in 0...16 {
            suffix = String(s)
            texture = SKTexture.init(imageNamed: "Metaball-" + suffix)
            textures.append(texture)
        }
        // Generate 16 metaballs SKNodes
        for r in 0..<row {
            x = -180
            for c in 0..<col {
                metaBall = SKSpriteNode.init(imageNamed: "Metaball-0")
                metaBall.name = String(r) + String(c)
                metaBall.position = CGPoint(x: x, y: y)
                metaBall.xScale = 0.5
                metaBall.yScale = 0.5
                self.addChild(metaBall)
                x += step
            }
            y -= step
        }
        // Generate Matrix and update score
        if self.Matrix.generate() == 1 {
            self.updateMetaballs()
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        let actNode = self.atPoint(self.currentPos!)
        actNode.run(SKAction.scale(to: 1.5, duration: 0.1))
    }
    
    override func mouseExited(with event: NSEvent) {
        let actNode = self.atPoint(self.currentPos!)
        actNode.run(SKAction.scale(to: 1.0, duration: 0.1))
    }
    
    override func mouseDown(with event: NSEvent) {
        let eventPos = event.location(in: self)
        let currentNode = self.atPoint(eventPos) as? SKLabelNode
        if let label = currentNode?.text, label == "Back" {
            if let scene = GKScene(fileNamed: "GameScene") {
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    // Copy gameplay related content over to the scene
                    sceneNode.entities = scene.entities
                    sceneNode.graphs = scene.graphs
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    // Present the scene
                    if let view = self.view {
                        view.presentScene(sceneNode, transition: .push(with: .right, duration: 0.5))
                        view.ignoresSiblingOrder = true
                        #if DEBUG
                        view.showsFPS = true
                        view.showsNodeCount = true
                        #endif
                    }
                }
            }
        } else {
            #if DEBUG
            print(eventPos)
            #endif
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x7B:  // kVK_LeftArrow
            Matrix.play(with: "left")
            self.played = true
        case 0x7C:   // kVK_RightArrow
            Matrix.play(with: "right")
            self.played = true
        case 0x7D:   // kVK_DownArrow
            Matrix.play(with: "down")
            self.played = true
        case 0x7E:   // kVK_UpArrow
            Matrix.play(with: "up")
            self.played = true
        case 0x31: // Space
            print("Display number")
        default:
            #if DEBUG
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
            #endif
        }
    }
    
    // Use template function of scene update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.scoreLabel?.run(SKAction.scale(to: 1.0, duration: 0.2))
        if played {
            switch self.Matrix.generate() {
            case 0:
                let deadLabel = SKLabelNode.init(text: "YOU DEAD ☠️")
                deadLabel.fontName = "BradleyHandITCTT-Bold"
                deadLabel.fontSize = 40
                deadLabel.fontColor = NSColor.red
                deadLabel.position = CGPoint(x: 0, y: 0)
                self.addChild(deadLabel)
                deadLabel.run(SKAction.scale(to: 2.0, duration: 0.5))
            case 1:
                self.updateMetaballs()
                self.scoreLabel?.run(SKAction.scale(to: 1.5, duration: 0.1))
            default:
                print("play a stack audio")
            }
            played = false
        }
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        self.lastUpdateTime = currentTime
    }
    
    private func updateMetaballs() {
        var power2 : Float
        var index : Int
        var score : Int
        var values : [[Int]]

        (values, score) = Matrix.getvalue()
        self.scoreLabel?.text = "Score: " + String(score)
        #if DEBUG
        for r in 0..<row {
            print(values[r])
        }
        print("-------------------------")
        #endif
        for r in 0..<row {
            for c in 0..<col {
                values[r][c] == 0 ? power2 = 0 : (power2 = log2(Float(values[r][c])))
                index = Int(power2)
                if let ball = self.childNode(withName: String(r) + String(c)) as? SKSpriteNode {
                    ball.texture = textures[index]
                }
            }
        }
    }

}
