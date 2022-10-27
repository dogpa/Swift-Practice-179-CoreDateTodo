//
//  ContentView.swift
//  Swift Practice 179 CoreDateTodo
//
//  Created by Dogpa's MBAir M1 on 2022/10/27.
//

import SwiftUI

struct ContentView: View {
    
    //CoreDataViewModel
    @StateObject var vm = CoreDataViewModel()
    
    var body: some View {
        
        //判斷updateState顯示不同頁面。
        VStack{
            
            if !vm.updateState {
                VStack {
                    Spacer(minLength: 20)
                    TextField("輸入電影標題", text: $vm.saveTodoString)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        vm.saveTodo(todoTitle: vm.saveTodoString)
                        vm.populateTodos()
                    } label: {
                        Text("儲存Todo")
                    }
                    Spacer(minLength: 50)
                    ScrollView {
                        ForEach(vm.todoArray, id:\.self) { todo in
                            VStack{
                                Text("\(todo.title ?? "")")
                            }
                                .onTapGesture {
                                    
                                    vm.updateTodoString = todo.title ?? ""
                                    vm.selectIndex = vm.getIndexOnTap()
                                    vm.updateState = true
                                }
                        }
                    }
                }
            }else{
                UpdateAndDeleteTodoView(vm: vm, todo: vm.todoArray[vm.selectIndex])
            }
        }
        .onAppear {
            vm.populateTodos()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
