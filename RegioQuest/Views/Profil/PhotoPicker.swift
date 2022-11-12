//
//  PhotoPicker.swift
//  RegioQuest
//
//  Created by Orhan Salman on 11.11.22.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @AppStorage("userImage", store: UserDefaults(suiteName: "group.com.regioquest.data")) private var selectedImageData: Data?
    
    var body: some View {
        
        if(selectedImageData == nil) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    
                    Text("Foto hochladen")
                        .foregroundColor(Color(.blue).opacity(50))
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
        } else {
            
            let frameSize = UIScreen.main.bounds.width * 0.45      // 750
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(Circle()
                        .fill(Color.primary))
                    .frame(width: frameSize, height: frameSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 4)
            }
        }
    }
}
