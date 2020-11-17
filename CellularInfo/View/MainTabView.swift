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
            //MARK: - Tab 1
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
            
            
            //MARK: - Tab 2
            NavigationView{
                ZStack{
                    InteractiveMapView()
                        .edgesIgnoringSafeArea(.all).navigationBarTitle("", displayMode: .inline)
                        .navigationBarItems(leading:
                                                Image("logo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 16, alignment: .topLeading))
                    
                    VStack {
                        Spacer()
                        Text("数据渐进式加载")
                            .padding()
                            .font(.caption)
                        
                        
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "map.fill")
                Text("热力图")
            }
            
            /*
             // MARK: - Tab3
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
