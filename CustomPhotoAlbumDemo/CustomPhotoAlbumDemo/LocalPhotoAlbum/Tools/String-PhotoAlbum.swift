//
//  String-PhotoAlbum.swift
//  ThreeBuild
//
//  Created by Apple on 2018/8/6.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import Foundation

extension String {
    
    /**
     将当前字符串拼接到doc目录后面
     */
    func docDirAlbum() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
}
