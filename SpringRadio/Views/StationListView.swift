//
//  ContentView.swift
//  SpringRadio
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import AVFoundation

struct StationListView: View {
    
//    @State var currentStationIndex : Int = 0
    @EnvironmentObject var items : RadioItems
    
    var body: some View {
        
        GeometryReader { g in
            self.makeNavigationView(g: g)
        }
    }
    
    func makeNavigationView(g:GeometryProxy) -> some View {
       screenWidth = g.frame(in: .global).width
       screenHeight = g.frame(in: .global).height
       let view = NavigationView {
            ZStack{
                List {
                    ForEach (self.items.values.indices) { i in
                        StationCell().environmentObject(self.items.values[i]).frame(height: 44)
                        .onTapGesture {
                            let item = self.items.values[i]
                            item.isPlaying = !item.isPlaying
                            if item.isPlaying && self.items.currentStationIndex != i {
                                self.items.currentStationIndex = i
                            }
                        }
                    }
                    Spacer(minLength: listSpacer())
                }
                
                VStack {
                    Spacer()
                    MiniPlayerControl(previousStation: self.items.previousStation, nextStation: self.items.nextStation)
                        .environmentObject(self.items.values[self.items.currentStationIndex])
                        .frame(height:TrapezoidParameters.trapezoidHeight)
                }.edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle(Text("Stations"))
        }.navigationViewStyle(StackNavigationViewStyle())
        return view
    }
    
    func listSpacer() -> CGFloat {
        self.items.values[self.items.currentStationIndex].isPlaying ? TrapezoidParameters.trapezoidHeight - 32 : 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StationListView().environmentObject(RadioItems())
    }
}


