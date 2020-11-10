//
//  MainTabView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/9.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView{
            //Tab 1
            NavigationView{
                ContentView()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(leading:
                                            Image("logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 16, alignment: .topLeading))
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Text("测试")
            }
            
            
            //Tab 2
            NavigationView{
                InteractiveMapView()
                    .edgesIgnoringSafeArea(.all).navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(leading:
                                            Image(                                                       "logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 16, alignment: .topLeading))
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "map.fill")
                Text("浏览")
            }
            
            /*
             //Tab3
             Text("About")
             .tabItem {
             Image(systemName: "questionmark.circle.fill")
             Text("FAQ") }
             
             */
        }
        
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
