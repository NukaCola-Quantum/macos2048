# MacOS 2048
## 1. Introduction
This is a 2048 game for MacOS code in Swift and use SpriteKit.

## 2. Files
This project follows the MVC paradigm.

Model: Algri.swift
This file includes the core algorithm of the 2048 game. There are
only three public methods offered to users.
generate() uses to initial the number matrix and update it after
every play() executed.
play() function does the specific action depends on keyEvents instruction.
getvalue() gets back the number matrix and the total score.

View: (Two Scenes)GameScene.swift, PlayScene.swift
GameScene: Sign in UI
PlayScene: Game playing UI

Controller: ViewController.swift
A simple view controller made as a container of game scenes.
