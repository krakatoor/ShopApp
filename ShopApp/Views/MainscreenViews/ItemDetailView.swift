//
//  ItemDetailView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var basket: BasketViewModel
    @State var itemCount = 1
    var item: Item
    
    var body: some View {
        VStack (spacing: 20){
            
            Image(item.image!)
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth)
                .cornerRadius(15)
                .edgesIgnoringSafeArea(.top)
            
       
            VStack{
            Text(item.name)
                .font(.system(.title, design: .rounded))
                .bold()
                
            Text("Цена: \(item.price)₽")
                .font(.system(.title2, design: .rounded))
               
            
            HStack (spacing: 20){
                Button(action: {if itemCount > 1 {itemCount -= 1}}, label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                })

              
                
                Text("\(itemCount)шт.")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Button(action: {itemCount += 1}, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                })
              
            }
            .padding()
            }

            Button(action: {
              
                if  !basket.basket.contains(where: { $0.item == item}) {
                    basket.basket.append(BasketItem(item: item, quantity: itemCount))
                } else {
                    for index in 0..<basket.basket.count{
                        for item in basket.basket {
                            if item.item == basket.basket[index].item {
                                basket.basket[index].quantity = itemCount
                            }
                        }
                    }
                }
                
                }, label: {
                    Text(basket.basket.contains(where: { $0.item == item}) ? ( basket.basket.contains(where: { $0.quantity == itemCount}) ? "Добавлено"  : "Изменить количество"): "Добавить")
                    .font(.title2)
                    .foregroundColor(.white)
                        .fixedSize()
                .padding(.vertical, 10)
                        .frame(width: 300)
                .background(Color.primary.cornerRadius(10))
            })
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item:   Item(name: "Американо", price: 110, quantity: nil, description: nil, image: "coffee1"))
    }
}
