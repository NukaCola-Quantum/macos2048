# MacOS 2048
## Introduction
This is a 2048 style game coding with Swift for MacOS and used SpriteKit as 2-D AppDev Framework.

## Files
This project follows the MVC paradigm.

### Model: Algri.swift

This file includes the core algorithm of the 2048 game. There are
three public methods offered to users.

- generate() uses to initial the number matrix and update it after
every play() executed.
- play() function exacutes the specific action depends on keyEvents instruction.
- getvalue() gets back the number matrix and the total score.

### View: (Two Scenes) Layout on GameScene.swift, PlayScene.swift

GameScene: Sign in UI

<p align="center">
  <img src="https://github.com/NukaCola-Quantum/macos2048/raw/master/screenshot/2048gamescene.png" />
</p>

PlayScene: Game playing UI

<p align="center">
  <img src="https://github.com/NukaCola-Quantum/macos2048/raw/master/screenshot/2048playscene.png" />
</p>

Replaced numbers in the grid with foreign alphabet images made the game more savor.

### Controller: ViewController.swift
Use a simple view controller to controll behaviors of game scenes.

## License
2048 game is involved under the [MIT LICENSE](https://github.com/NukaCola-Quantum/macos2048/edit/master/LICENSE).
