//
//  AccountView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 14.05.2021.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @AppStorage("log_Status") var status = false
    @StateObject var accountCreation = AccountCreationViewModel()
    @EnvironmentObject var store: Store
    @State var showAlert = false
    
    var body: some View {
        
        
        if status {
            VStack (alignment: .leading) {
                NavbarTrailingButton
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Выйти из аккаунта"), message: Text("Вы уверены?"), primaryButton: .destructive(Text("Да")) {
                            withAnimation{
                                status = false
                                Store.manager.isCurrentUserAdmin = false
                                accountCreation.status = false
                                accountCreation.pageNumber = 0
                                
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                            }
                        },
                        secondaryButton: .cancel(Text("Отмена")))
                    })
                
                if store.userProfile.id == currentUser {
                Text("Имя: " + (store.userProfile.userName))
                    .padding(.leading)
                Text("Адрес доставки: " + (store.userProfile.location ?? ""))
                    .padding(.leading)
                    
                    List(store.orders, id: \.self) { order in
                        NavigationLink(
                            destination: orderDetail(order: order).environmentObject(store),
                            label: {
                            VStack (alignment: .leading) {
                                Text("Номер заказа: \(order.orderNumber)")
                                Text("Дата заказа: (" + order.date)
                                Text("Сумма заказа: \(order.totalSum)" )
                            }
                        })
                            .buttonStyle(PlainButtonStyle())
                    }
                 
                }
                Spacer()
                
             
                
            }
           
            .onAppear{
                store.fetchCurrenUser()
                store.fetchUserOrderHistory()
            }
        } else {
            LoginView()
                .environmentObject(accountCreation)
            
            if accountCreation.isLoading{
                LoadingScreen()
            }
        }
    }
    var NavbarTrailingButton: some View {
        HStack {
            Spacer()
            Button(action: {
                    withAnimation{
                        showAlert.toggle()
                    }
                }, label: {
                    HStack {
                        Text("Выйти")
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "escape")
                            .font(.title3)
                            .foregroundColor(.primary)
                       
                    }
                    .padding()
            })
        }
           
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(AccountCreationViewModel())
            .environmentObject(Store())
    }
}

struct orderDetail: View {
    var order: Order
    var body: some View {
        VStack (alignment: .leading){
            Text("Номер заказа: \(order.orderNumber)")
            Text("Дата заказа: (" + order.date)
            Text("Сумма заказа: \(order.totalSum)" )
            
            Text("Товары в заказе:" )
                .padding(.top)
                ForEach(order.item.sorted(by: >), id: \.key) {  key, value in
                    HStack {
                        Text(key)
                        Text("\(value)шт.")
                    }
                }
            Spacer()
            }
        .padding(.leading)
       
        
        }
    
}
