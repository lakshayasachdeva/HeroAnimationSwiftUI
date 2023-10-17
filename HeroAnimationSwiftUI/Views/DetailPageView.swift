//
//  DetailPageView.swift
//  HeroAnimationSwiftUI
//
//  Created by Lakshaya Sachdeva on 17/10/23.
//

import SwiftUI

struct DetailPageView: View {
    @Binding var showDetailPage: Bool
    @Binding var selectedPlayer: Player?
    @Binding var heroProgress: CGFloat
    @Binding var showHeroView: Bool
    @GestureState var isDragging: Bool = false
    @State private  var offset: CGFloat = .zero
    
    var body: some View {
        if let player = selectedPlayer {
            GeometryReader {
                let size = $0.size
                ScrollView(.vertical) {
                    Rectangle()
                        .fill(.clear)
                        .overlay {
                            if !showHeroView {
                                Image(player.profilePic)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: 400)
                                    .clipShape(.rect(cornerRadius: 25))
                                    .transition(.identity)
                            }
                            
                        }
                        .frame(height: 400)
                    // destination
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return ["Destination": anchor]
                        })
                        .visualEffect { content, geometryProxy in
                            content
                                .offset(y: geometryProxy.frame(in: .scrollView).minY > 0 ? -geometryProxy.frame(in: .scrollView).minY : 0)
                        }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea()
                .frame(width: size.width, height: size.height)
                .background {
                    Rectangle()
                        .fill(.white)
                        .ignoresSafeArea()
                }
                .overlay(alignment: .topLeading) {
                    Button(action: {
                        showHeroView = true
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0),
                                      completionCriteria: .logicallyComplete) {
                            heroProgress = 0.0
                            
                        } completion: {
                            showDetailPage = false
                            self.selectedPlayer = nil
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .contentShape(.rect)
                            .foregroundStyle(.white
                                             , .black)
                    })
                    .buttonStyle(.plain)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.snappy(duration: 0.35, extraBounce: 0), value: showHeroView)
                }
                .offset(x: size.width - (size.width * heroProgress))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 10)
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    var translation = value.translation.width
                                    translation = isDragging ? translation : .zero
                                    translation = translation > 0 ? translation : 0
                                    
                                    // converting into progress
                                    let dragProgress = 1.0 - (translation / size.width)
                                    // limiting progress between 0 to 1
                                    let cappedProg = min(max(0, dragProgress), 1)
                                    heroProgress = cappedProg
                                    offset = translation
                                    // when the gesture is started to dismiss the view, the hero layer view will be appeared and thus we can see the transition from the destination view to the source view
                                    if !showHeroView {
                                        showHeroView = true
                                    }
                                    
                                })
                                .onEnded({ value in
                                    // closing/resetting on the based of end target
                                    let velocity = value.velocity.width
                                    
                                    if (offset + velocity) > (size.width * 0.8) {
                                        // close view
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0),
                                                      completionCriteria: .logicallyComplete) {
                                            heroProgress = .zero
                                            
                                        } completion: {
                                            offset = .zero
                                            showDetailPage = false
                                            showHeroView = true
                                            self.selectedPlayer = nil
                                        }
                                    } else{
                                        // reset view
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0),
                                                      completionCriteria: .logicallyComplete) {
                                            heroProgress = 1.0
                                            offset = .zero
                                        } completion: {
                                            showHeroView = false
                                        }
                                    }
                                })
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
