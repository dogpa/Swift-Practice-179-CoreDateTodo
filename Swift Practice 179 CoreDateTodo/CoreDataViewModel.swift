//
//  CoreDataViewModel.swift
//  Swift Practice 179 CoreDateTodo
//
//  Created by Dogpa's MBAir M1 on 2022/10/27.
//

import Foundation
import CoreData

final class CoreDataViewModel: ObservableObject {
    
    //儲存所有Todo的Array
    @Published var todoArray = [Todo]()
    
    //儲存新增的todo string
    @Published var saveTodoString: String = ""
    
    //儲存更新或刪除的title
    @Published var updateTodoString: String = "" 
    
    //判斷是否跳到更新刪除頁面
    @Published var updateState: Bool = false
    
    //透過使用者點擊改變selectIndex的值
    @Published var selectIndex: Int = 0 {
        didSet {
            print("selectIndex改變：\(self.selectIndex)")
        }
    }
    
    let persistentContainer: NSPersistentContainer
    init() {
        persistentContainer = NSPersistentContainer(name: "TodoDataModel")
        persistentContainer.loadPersistentStores { NSEntityDescription, error in
            if let error = error {
                fatalError("Core data 讀取失敗 \(error.localizedDescription)")
            }
        }
    }
    
    func populateTodos() {
        todoArray = getTodos()
    }
    
    ///讀取todo
    func getTodos() -> [Todo] {
        print("try to fetch todos...")
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }catch{
            return []
        }
    }
    
    ///儲存todo
    func saveTodo(todoTitle: String) {
        print("try to save todo....")
        let todo = Todo(context: persistentContainer.viewContext)
        todo.title = todoTitle
        do {
            try persistentContainer.viewContext.save()
        }catch{
            print("Failed to save todo \(error.localizedDescription) 儲存失敗....")
        }
        selectIndex = getIndexOnTap()
        saveTodoString = ""
    }
    
    ///更新todo
    func updateTodo() {
        print("try to update Todo...")
        do {
            try persistentContainer.viewContext.save()
        }catch {
            persistentContainer.viewContext.rollback()
        }
        updateTodoString = ""
    }
    
    ///刪除todo
    func deleteTodo(todo:Todo) {
        print("嘗試刪除")
        persistentContainer.viewContext.delete(todo)
        do{
            try persistentContainer.viewContext.save()
        }catch{
            persistentContainer.viewContext.rollback()
            print("刪除後重新取得失敗....\(error.localizedDescription)")
        }
    }
    
    //updateTodoString找到使用者點擊到的todo去搜尋在array內的位置後將位置儲存到selectIndex
    func getIndexOnTap() -> Int {
        var index: Int = 0
        for i in 0..<todoArray.count {
            if todoArray[i].title ?? "" == updateTodoString {
                index = i
            }
        }
        return index
    }
}
