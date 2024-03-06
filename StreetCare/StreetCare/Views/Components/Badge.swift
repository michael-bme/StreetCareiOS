//
//  AchievementBadge.swift
//  StreetCare
//
//  Created by Michael on 5/1/23.
//

import SwiftUI


struct Badge: View {
    
    var description: String
    var title: String
    var imageName: String
    
    var body: some View {
            HStack(alignment: .top) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8.0)
                        .strokeBorder(lineWidth: 0.0)
                        .foregroundColor(.gray).background(.gray)
                        .frame(width: 60.0, height: 60.0)
                    Image(imageName).resizable().aspectRatio(contentMode: .fit).frame(width: 50.0,height: 50.0).cornerRadius(15.0)
                }
                VStack{
                    Text(title + "\n" + description)
                        .foregroundColor(Color("TextColor"))  .multilineTextAlignment(.leading).listRowSeparator(.hidden)

                }
                Spacer()
            }.padding(.horizontal, 10).padding(.vertical, 10)
        }
    } // end body

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(description: "24", title: "People helped", imageName: "HelpingHands")
    }
}