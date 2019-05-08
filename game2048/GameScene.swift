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
//  GameScene.swift
//  game2048
//
//  Created by Kane on 2019/4/11.
//  Copyright © 2019 Kane. All rights reserved.
//  Comment:
//  This snippet show how to use mouseEvent or keyEvent to make
//  an interactive effect with SKNode.
//  Especially, for tracking mouseEvent (mouseEnter, mouseExit or mouseMoved)
//  need to add tracking area to view that hold the current scene.
//  General there are 3 steps:
//  1. For normal SKNode objects, set 'isUserInteractionEnabled' to true
/*
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }
*/
//  2. Override mouseEvent or keyEvent functions in SKNode to respond user's
//  interactions. If necessory, add trackingArea to view. There are 2 ways to
//  do it. See article 'Controlling User Interaction on Nodes' for more details.
//  3. Make effects in *Event functions.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var trackingFrames : [CGRect] = []
    private var trackingAreas : [NSTrackingArea] = []
    private var trackingPos : [CGPoint] = []
    private var currentPos: CGPoint?
    private var lastUpdateTime : TimeInterval = 0
    private var titleNode : SKLabelNode?
    private var infoNode : SKLabelNode?
    private var copyrightNode: SKLabelNode?
    private var optNode : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var optList : [String] = ["Start", "Scoreboard", "Quit"]
    
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
    
    override func willMove(from view: SKView) {
        for trackingArea in trackingAreas {
            view.removeTrackingArea(trackingArea)
        }
    }
    
    override func sceneDidLoad() {
        let posX : CGFloat = 0
        var posY : CGFloat = -50
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.titleNode = self.childNode(withName: "//titleLabel") as? SKLabelNode
        self.infoNode = self.childNode(withName: "//infoLabel") as? SKLabelNode
        self.copyrightNode = self.childNode(withName: "//copyright") as? SKLabelNode

        if let title = self.titleNode {
            title.text = "2048"
            title.alpha = 0.0
            title.run(SKAction.fadeIn(withDuration: 2.0))
        }
        if let info = self.infoNode {
            info.text = "Move: ⬆️ ⬅️ ⬇️ ➡️    Confirm: enter ↩️"
            info.alpha = 0.0
            info.run(SKAction.fadeIn(withDuration: 2.5))
        }
        if let cright = self.copyrightNode {
            cright.text = "Copyright © 2019 Kane. All rights reserved."
        }
        // 2. Generate interactive SKNodes and add them to scene
        for optname in optList {
            let pos = CGPoint(x: posX, y: posY)
            self.optNode = SKLabelNode.init(text: optname)
            if let option = self.optNode {
                option.position = pos
                option.name = optname + "Label"
                option.fontName = "ChalkboardSE-Bold"
                option.fontSize = 36
                self.addChild(option)
                self.trackingFrames.append(option.frame)
                self.trackingPos.append(pos)
            }
            posY -= 70
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    private func selectThe(Node point: CGPoint) -> CGPoint {
        var minInterval = pow(self.size.width, 2) + pow(self.size.height, 2)
        var chosenOne = point
        // print(point)
        for candidate in self.trackingPos {
            let interval = pow(point.x - candidate.x, 2) + pow(point.y - candidate.y, 2)
            // print(candidate)
            // print(interval)
            if interval < minInterval {
                minInterval = interval
                chosenOne = candidate
            }
        }
        return chosenOne
    }
    
    // 3. Overide Event functions to respond user's interactions
    // There only use sceneNode to controll all interactions
    override func mouseEntered(with event: NSEvent) {
        if event.type.rawValue == UInt(8) {
            let nodeOrigin = selectThe(Node: event.location(in: self))
            self.currentPos = nodeOrigin
            let actNode = self.atPoint(nodeOrigin)
            actNode.run(SKAction.scale(to: 1.5, duration: 0.1))
        } else {
            super.mouseEntered(with: event)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        if event.type.rawValue == UInt(9) {
            if let nodeOrigin = self.currentPos {
                let actNode = self.atPoint(nodeOrigin)
                actNode.run(SKAction.scale(to: 1.0, duration: 0.1))
                self.currentPos = nil
            }
        } else {
            super.mouseExited(with: event)
        }
    }
    
    // Use mouseDown respond the user's instruction
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
        print(event.location(in: self))
        
        switch self.currentPos {
        case self.trackingPos[0]:
            if let playScene = GKScene(fileNamed: "PlayScene") {
                if let sceneNode = playScene.rootNode as! PlayScene? {
                    // Copy gameplay related content over to the scene
                    sceneNode.entities = playScene.entities
                    sceneNode.graphs = playScene.graphs
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    if let mainView = self.view {
                        mainView.presentScene(sceneNode, transition: .push(with: .left, duration: 0.5))
                        #if DEBUG
                        mainView.showsFPS = true
                        mainView.showsNodeCount = true
                        #endif
                    }
                }
            }
        case self.trackingPos[1]:
            print("Waiting for content...")
            if let sboard = NSDictionary.init(contentsOfFile: NSHomeDirectory() + "/scoreboard.plist") {
                //let svalue : Int = sboard["Kane"]
                //let score = SKLabelNode.init(text: String(svalue))
                print(sboard)
            }
            
        case self.trackingPos[2]:
            NSApp.terminate(self)
        default:
            self.touchDown(atPoint: event.location(in: self))
        }
    }

    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let title = self.titleNode {
                title.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
}
