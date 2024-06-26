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
        return Database(at: dataBasePath)
    }

    // 创建表
    func createTable<T: TableDecodable>(table: String, of type: T.Type) {
        do {
            try dataBase?.create(table: table, of: type)
        } catch {
            debugPrint("creat table error \(error.localizedDescription)")
        }
    }

    // 插入
    func insertToDB<T: TableEncodable>(objects: [T], intoTable table: String) {
        do {
            try dataBase?.insert(objects, intoTable: table)
        } catch {
            debugPrint("insert obj error \(error.localizedDescription)")
        }
    }

    // 修改
    func updateToDB<T: TableEncodable>(table _: String, on _: [PropertyConvertible], with _: T, where _: Condition? = nil) {}

    // 删除
    func deleteFromDB(fromTable: String, where condition: Condition? = nil) {
        do {
            try dataBase?.delete(fromTable: fromTable, where: condition)
        } catch {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }

    func queryFromDB<T: TableDecodable>(fromTable: String, cls _: T.Type, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where: condition, orderBy: orderList))!
            debugPrint(allObjects)
            return allObjects
        } catch {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }

    // 删除数据表
    func dropTable(table: String) {
        do {
            try dataBase?.drop(table: table)
        } catch {
            debugPrint("drop table error \(error.localizedDescription)")
        }
    }

    func removeDBFile() {
        do {
            try dataBase?.close(onClosed: {
                try self.dataBase?.removeFiles()
            })
        } catch {
            debugPrint("no close db \(error.localizedDescription)")
        }
    }
}
