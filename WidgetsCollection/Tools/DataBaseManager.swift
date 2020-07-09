//
//  DataBaseManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/29.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import WCDBSwift

struct DataBasePath {
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/DB/DB.db"
}

class DataBaseManager: NSObject {
    static let share = DataBaseManager()
    let dataBasePath = URL(fileURLWithPath: DataBasePath().dbPath)
    var dataBase: Database?
        
    override init() {
        super.init()
        dataBase = creatDB()
    }
    
    private func creatDB() -> Database {
        debugPrint("数据库路径==\(dataBasePath.absoluteURL)")
        return Database(withFileURL: dataBasePath)
    }
    
    // 创建表
    func createTable<T: TableDecodable>(table: String, of type: T.Type) {
        do {
            try dataBase?.create(table: table, of: type)
        } catch let error {
            debugPrint("creat table error \(error.localizedDescription)")
        }
    }
    
    // 插入
    func insertToDB<T: TableEncodable>(objects: [T], intoTable table: String) {
        do {
            try dataBase?.insert(objects: objects, intoTable: table)
        } catch let error {
            debugPrint("insert obj error \(error.localizedDescription)")
        }
    }
    
    // 修改
    func updateToDB<T: TableEncodable>(table: String, on propertys: [PropertyConvertible], with object: T, where condition: Condition? = nil) {
        
    }
    
    // 删除
    func deleteFromDB(fromTable: String, where condition: Condition? = nil) {
        do {
            try dataBase?.delete(fromTable: fromTable, where: condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    
    func queryFromDB<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where: condition, orderBy: orderList))!
            debugPrint(allObjects)
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    // 删除数据表
    func dropTable(table: String) {
        do {
            try dataBase?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error.localizedDescription)")
        }
    }
    
    func removeDBFile() {
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
            })
        } catch let error {
            debugPrint("no close db \(error.localizedDescription)")
        }
    }
    
}
