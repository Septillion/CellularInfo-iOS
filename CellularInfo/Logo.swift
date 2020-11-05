//
//  Logo.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        Image("logo")
            .resizable()
        aspectRatio(contentMode: .fit)
            .frame( height: 50, alignment: .topLeading)
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
