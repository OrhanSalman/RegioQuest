//
//  SwiftUIView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 09.12.22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ScrollView {
            
            HStack {
                VStack {
                    Text("Siegen Stadt")
                    
                        
                }
                /*
                Image(systemName: "play.square.stack")
                    .imageScale(.large)
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.indigo)
                    .scaleEffect(3, anchor: .center)
                    .frame(width: UIScreen.main.bounds.width / 2.6)
                    .offset(y: -50)
                 */
                 
                Spacer()
                
                VStack(spacing: 20){
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            ZStack{
                                Circle()
                                    .stroke(Color.black.opacity(0.1), lineWidth: 5)
                                

                            }
                                .rotationEffect(.init(degrees: -90))
                        )
                        .clipShape(Circle())
                    
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            
                            ZStack{
                                
                                
                                
                                Circle()
                                    .stroke(Color.black.opacity(0.1), lineWidth: 5)
                                

                            }
                                .rotationEffect(.init(degrees: -90))
                        )
                        .clipShape(Circle())
                    
                    Image(systemName: "hammer.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            
                            ZStack{
                                
                                
                                
                                Circle()
                                    .stroke(Color.black.opacity(0.1), lineWidth: 5)
                                

                            }
                                .rotationEffect(.init(degrees: -90))
                        )
                        .clipShape(Circle())
                    
                    Spacer(minLength: 0)
                    

                }
                .padding(.trailing)
            }
            .overlay {
                /*
                Image("regio")
                    .resizable()
                    .shadow(color: .black.opacity(0.75), radius: 25, x: 0, y: 0)
                 */
            }

            
            .frame(height: 290)
            .background(
                Color.green.opacity(0.2)
                    .cornerRadius(25)
                    .rotation3DEffect(.init(degrees: 20), axis: (x: 0, y: -1, z: 0))
                    .padding(.vertical, 35)
                    .padding(.trailing, 25)
                
            )
            .padding(.horizontal)
        }
    }
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
