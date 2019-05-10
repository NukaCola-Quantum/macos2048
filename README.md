# MacOS 2048
## Introduction
This is a 2048 game for MacOS code in Swift and use SpriteKit.

## Files
This project follows the MVC paradigm.

### Model: Algri.swift

This file includes the core algorithm of the 2048 game. There are
only three public methods offered to users.

- generate() uses to initial the number matrix and update it after
every play() executed.
- play() function does the specific action depends on keyEvents instruction.
- getvalue() gets back the number matrix and the total score.

### View: (Two Scenes)GameScene.swift, PlayScene.swift

GameScene: Sign in UI

<p align="center">
  <img src="https://github.com/NukaCola-Quantum/macos2048/tree/master/screenshot/2048gamescene.png" width="128" hight="128"/>
</p>

PlayScene: Game playing UI

<p align="center">
  <img src="https://github.com/NukaCola-Quantum/macos2048/tree/master/screenshot/2048playscene.png" width="128" hight="128"/>
</p>

### Controller: ViewController.swift
A simple view controller made as a container of game scenes.
