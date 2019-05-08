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
//  OptLabelNode.swift
//  game2048
//
//  Created by Kane on 2019/4/12.
//  Copyright © 2019 Kane. All rights reserved.
//

import SpriteKit

class OptLabelNode: SKLabelNode {
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }
    
    override var acceptsFirstResponder: Bool {
        get {
            return true
        }
        set {}
    }
      
    override func mouseEntered(with event: NSEvent) {
        print("Mice in...")
        if event.type.rawValue == UInt(8) {
            self.run(SKAction.scale(to: 1.5, duration: 0.1))
        } else {
            super.mouseEntered(with: event)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        print("Mice out...")
        if event.type.rawValue == UInt(9) {
            self.run(SKAction.scale(to: 1.0, duration: 0.1))
        } else {
            super.mouseExited(with: event)
        }
    }
}