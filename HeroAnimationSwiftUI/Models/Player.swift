//
//  Player.swift
//  HeroAnimationSwiftUI
//
//  Created by Lakshaya Sachdeva on 17/10/23.
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    let userName: String
    let profilePic: String
    let msg: String
}

var players = [
    Player(userName: "Virat Kohli", profilePic: "virat", msg: "Chase master"),
    Player(userName: "Rohit Sharma", profilePic: "rohit", msg: "Hitman"),
    Player(userName: "KL Rahul", profilePic: "rahul", msg: "Class Rahul"),
    Player(userName: "Jasprit Bumrah", profilePic: "bumrah", msg: "National treasure"),
    Player(userName: "Mohammad Siraj", profilePic: "siraj", msg: "No.1 ranked bowler in ODIs")
]
