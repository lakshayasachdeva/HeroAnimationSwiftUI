//
//  LandingScreen.swift
//  HeroAnimationSwiftUI
//
//  Created by Lakshaya Sachdeva on 17/10/23.
//

import SwiftUI

struct LandingScreen: View {
    @State private var allPlayers: [Player] = players
    @State private var selectedPlayer: Player?
    @State var showDetailPage: Bool = false
    @State var heroProgress: CGFloat = 0
    @State private var showHeroView: Bool = true

    var body: some View {
        NavigationStack{
            List(allPlayers) { player in
                HStack(spacing: 12) {
                    Image(player.profilePic)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.circle)
                        .opacity(selectedPlayer?.id == player.id ? 0 : 1)
                    // source
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return [player.id.uuidString: anchor]
                        })
                    VStack(alignment: .leading, spacing: 6, content: {
                        
                        Text(player.userName)
                            .fontWeight(.bold)
                        
                        Text(player.msg)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    )}
                .contentShape(.rect)
                .onTapGesture {
                    selectedPlayer = player
                    showDetailPage = true
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                        heroProgress = 1.0
                    } completion: {
                        Task {
                            try? await Task.sleep(for: .seconds(0.1))
                            showHeroView = false
                        }
                    }
                }
            }
            .navigationTitle("Team India")
        }
        .overlay {
            DetailPageView(
                showDetailPage: $showDetailPage,
                selectedPlayer: $selectedPlayer,
                heroProgress: $heroProgress, 
                showHeroView: $showHeroView
            )
        }
        // Hero animation layer
        .overlayPreferenceValue(AnchorKey.self, { value in
            GeometryReader { geometry in
                if let player = selectedPlayer, let source = value[player.id.uuidString], let destination = value["Destination"] {
                    let sourceRect = geometry[source]
                    let radius = sourceRect.height / 2
                    let destRect = geometry[destination]
                    
                    let diffRect = CGSize(
                        width: destRect.width - sourceRect.width,
                        height: destRect.height - sourceRect.height
                    )
                    
                    let diffOrigin = CGPoint(
                        x: destRect.minX - sourceRect.minX,
                        y: destRect.minY - sourceRect.minY
                    )
                    
                    // our hero view goes here, in this case it is image
                    Image(player.profilePic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: sourceRect.width + (diffRect.width * heroProgress),
                            height: sourceRect.height + (diffRect.height * heroProgress)
                        )
                        .clipShape(.rect(cornerRadius: radius - (radius * heroProgress)))
                        .offset(
                            x: sourceRect.minX + (diffOrigin.x * heroProgress),
                            y:sourceRect.minY + (diffOrigin .y * heroProgress)
                        )
                        .opacity(showHeroView ? 1 : 0)
                    
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
