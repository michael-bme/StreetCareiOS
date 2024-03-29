//
//  VisitImpactView.swift
//  StreetCare
//
//  Created by Michael on 5/1/23.
//

import SwiftUI
import FirebaseAuth



struct VisitImpactView: View {
    
    let adapter = VisitLogDataAdapter()
    @State var history = [VisitLog]()
    
    var currentUser = Auth.auth().currentUser
    
    @State var peopleHelped = 0
    @State var outreaches = 0
    @State var itemsDonated = 0
    
    @State var showActionSheet = false
    
    @State var isLoading = false

    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("VISIT LOG")
                    .font(.largeTitle)
                
                ImpactView(peopleHelped: peopleHelped, outreaches: outreaches, itemsDonated: itemsDonated)
                    .padding()                
                
                NavigationLink {
                    VisitLogEntry()
                } label: {
                    ZStack {
                        NavLinkButton(title: "Add new+", width: 120.0)
                    }
                }
                
                Text("HISTORY")
                    .font(.title)
                
                List(history) { item in
                    NavigationLink {
                        VisitLogView(log: item)
                    } label: {
                        HStack {
                            ListConnectorDecorationView()
                            VStack {
                                HStack {
                                    Text("\(item.whenVisit.formatted(date: .abbreviated, time: .omitted))")
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("\(item.whereVisit)")
                                    Spacer()
                                }
                            }
                        }
                    }

                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .loadingAnimation(isLoading: isLoading)
            .onAppear {
                print("Imact view onAppear")
                adapter.delegate = self
                
                // not sure why I need to do this, the refresh method
                // checks for no user and if so calls
                // delegate function
                // but the loading animation never goes away
                // despite the state flagging changing to false
                if Auth.auth().currentUser != nil {
                    adapter.refresh()
                    self.isLoading = true
                }
                else {
                    adapter.resetLogs()
                    history = [VisitLog]()
                    peopleHelped = 0
                    outreaches = 0
                    itemsDonated = 0
                }
            }
        }
    } // end body
    
    
    private func updateCounts() {

        self.outreaches = history.count
        
        self.peopleHelped = history.reduce(0, { partialResult, visitLog in
            partialResult + visitLog.peopleHelped
        })
        
        self.itemsDonated = history.reduce(0, { partialResult, visitLog in
            
            var newDonations = 0
            
            if visitLog.foodAndDrinks {
                newDonations += 1
            }

            if visitLog.clothes {
                newDonations += 1
            }

            if visitLog.hygine {
                newDonations += 1
            }
            
            if visitLog.wellness {
                newDonations += 1
            }

            if visitLog.other {
                newDonations += 1
            }

            return partialResult + newDonations
        })

        
    }
    
} // end struct



extension VisitImpactView: VisitLogDataAdapterProtocol {
    
    func visitLogDataRefreshed(_ logs: [VisitLog]) {
        self.history = logs
        self.updateCounts()
        self.isLoading = false
    }
}



struct VisitImpactView_Previews: PreviewProvider {
    static var previews: some View {
        VisitImpactView()
    }
}
