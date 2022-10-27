//
//  UpdateAndDeleteTodoView.swift
//  Swift Practice 179 CoreDateTodo
//
//  Created by Dogpa's MBAir M1 on 2022/10/27.
//

import SwiftUI

struct UpdateAndDeleteTodoView: View {
    //接收ContentView的CoreDataViewModel
    @StateObject var vm: CoreDataViewModel
    
    //接收使用者點擊的到的todo
    let todo: Todo
    
    var body: some View {
        VStack{
            //顯示使用者點擊的todo的title並可以直接更改
            TextField(todo.title ?? "", text: $vm.updateTodoString)
                .textFieldStyle(.roundedBorder)
            
            //更改
            Button {
                if !vm.updateTodoString.isEmpty {
                    todo.title = vm.updateTodoString
                    vm.updateTodo()
                    vm.updateState = false
                }
            } label: {
                Text("修改")
            }
            
            //刪除
            Button {
                vm.deleteTodo(todo: vm.todoArray[vm.selectIndex])
                vm.updateState = false
            } label: {
                Text("刪除")
            }
        }
    }
}

struct UpdateAndDeleteTodoView_Previews: PreviewProvider {
    static var previews: some View {
        let todo = Todo()
        UpdateAndDeleteTodoView(vm: CoreDataViewModel(), todo: todo)
    }
}
