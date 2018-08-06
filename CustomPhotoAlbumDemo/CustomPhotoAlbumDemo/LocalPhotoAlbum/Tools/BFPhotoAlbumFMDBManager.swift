//
//  BFFMDBManager.swift
//  ThreeBuild
//
//  Created by Apple on 2018/3/20.
//  Copyright © 2018年 广西建工三建. All rights reserved.
//

import UIKit
import FMDB

private let kPhotoAlbumDBName = "tb_photoAlbum"
class BFPhotoAlbumFMDBManager {
    
    static let shared = BFPhotoAlbumFMDBManager()
    private init () {}
    
    var dbQueue: FMDatabaseQueue?
    
    // 创建数据库（多线程创建默认是已经打开的）
    func createDB(dbName: String) {
        let path = "\(dbName).sqlite".docDirAlbum()
        dbQueue = FMDatabaseQueue.init(path: path)
    }
    
    // 创建数据库表
    @discardableResult
    func createTable() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS `\(kPhotoAlbumDBName)`( \n" +
        "`id` INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
        "`time` INTEGER, \n" +
        "`type` INTEGER, \n" +
        "`image_path` TEXT \n" +
        "); \n"
        var isCreateResult = false
        dbQueue?.inDatabase { (db) in
            let result = db.executeUpdate(sql, withArgumentsIn: [])
            if result {
                print("建表成功")
                isCreateResult = true
            } else {
                print("建表失败")
                isCreateResult = false
            }
        }
        return isCreateResult
    }
    
    /// 插入数据
    ///
    /// - Parameters:
    ///   - time: 时间戳
    ///   - type: 图片类型
    ///   - path: 本地的图片路径
    func insertData(time: Int,  type: PhotoAlbumType, path: String) {
        let  sql = "INSERT INTO `\(kPhotoAlbumDBName)` (`time`,`type`,`image_path`) VALUES(?,?,?);"
        dbQueue?.inTransaction({ (db, rollback) in
            let res = db.executeUpdate(sql, withArgumentsIn: [time, type.rawValue, path])
            if !res {
                rollback.pointee = true
            }
        })
    }
    
    /// 根据类型查询对应的图片数据
    ///
    /// - Parameters:
    ///   - type: 图片类型
    ///   - finished: 回调
    func queryDatas(type: PhotoAlbumType, finished: ([BFPhotoAlbumModel]) -> ()) {

        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: date)
        guard let timeDate = calendar.date(from: components) else {
            return
        }
        let dateStamp: TimeInterval = timeDate.timeIntervalSince1970
        let dateSt: Int = Int(dateStamp)
        let startTimeStamp = dateSt
        let endTimeStamp = dateSt + 24 * 60 * 60
        let sql = "SELECT * FROM `\(kPhotoAlbumDBName)` WHERE `time`>=\(startTimeStamp) AND `time`<\(endTimeStamp) AND `type`=\(type.rawValue) ORDER BY `time` DESC; \n"
        dbQueue?.inDatabase({ (db) -> Void in
            var dataList = [BFPhotoAlbumModel]()
            if let res = db.executeQuery(sql, withArgumentsIn: []) {
                // 2.2遍历取出查询到的数据
                while res.next() {
                    let model = BFPhotoAlbumModel()
                    model.id = Int(res.int(forColumn: "id"))
                    model.type = Int(res.int(forColumn: "type")) 
                    model.time = Int(res.int(forColumn: "time"))
                    model.path = res.string(forColumn: "image_path") ?? ""
                    dataList.append(model)
                }
            }
            finished(dataList)
        })
    }
    
    /// 根据id删除数据库中对应的数据
    ///
    /// - Parameter id: 主键
    func deleteData(id: String) {
        let sql = "DELETE FROM `\(kPhotoAlbumDBName)` WHERE `id`  = '\(id)';"
        dbQueue?.inDatabase({ (db) -> Void in
            db.executeUpdate(sql, withArgumentsIn: [])
        })
    }
    
    /// 删除数据库中的所有数据
    func deleteAllData() {
        let sql = "DELETE * FROM `\(kPhotoAlbumDBName)`;"
        dbQueue?.inDatabase({ (db) -> Void in
            db.executeUpdate(sql, withArgumentsIn: [])
        })
    }
}
