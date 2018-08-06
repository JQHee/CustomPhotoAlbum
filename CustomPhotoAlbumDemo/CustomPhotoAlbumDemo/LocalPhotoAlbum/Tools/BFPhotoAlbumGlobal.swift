//
//  BFPhotoAlbumGlobal.swift
//  ThreeBuild
//
//  Created by Apple on 2018/8/6.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import Foundation

// 图片的类型
enum PhotoAlbumType: Int {
    /* 安全检查新增 */
    case safeNew = 0
    /* 安全检查评分新增 */
    case safeScore = 1
    /* 安全检查整改人回复 */
    case safeReply = 2
    /* 安全检查检查结论 */
    case safeResult = 3
    /* 质量技术检查新增 */
    case qulityNew = 4
    /* 质量技术检查整改人回复 */
    case qulityReply = 5
    /* 质量技术检查检查结论 */
    case qulityResult = 6
}
