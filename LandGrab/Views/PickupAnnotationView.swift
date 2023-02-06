//
//  PickupAnnotationView.swift
//  LandGrab
//
//  Created by Christopher Reese on 1/29/23.
//

import SwiftUI

struct PickupAnnotationView: View {
    let accentColor = Color("AccentColor")
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: LocationType_PickupIteam_Image)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(.green)
                .cornerRadius(36)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

struct PickupAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        PickupAnnotationView()
    }
}
