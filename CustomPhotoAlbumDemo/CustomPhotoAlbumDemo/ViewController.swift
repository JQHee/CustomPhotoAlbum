//
//  ViewController.swift
//  CustomPhotoAlbumDemo
//
//  Created by HJQ on 2018/8/4.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        guard let image = UIImage.init(named: "12") else {
            return
        }
        let timeStamp = Int(Date().timeIntervalSince1970)
        let path = saveImage(currentImage: image, persent: 1.0, imageName: "\(timeStamp).png")
        BFPhotoAlbumFMDBManager.shared.insertData(time: timeStamp, type: .safeNew, path: path)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showAlertSelectMenu()
    }

    func showAlertSelectMenu() {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "打开相机", style: .default) { [weak self](_) in
            self?.showSelectMenu(type: .camera)

        }
        let albumAction = UIAlertAction.init(title: "打开相册", style: .default) { [weak self](_) in
            self?.showSelectMenu(type: .photoLibrary)
        }

        let cancleAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(albumAction)
        alertVC.addAction(cancleAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func showSelectMenu(type: UIImagePickerControllerSourceType){
        // 先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        if type == .camera {
            let sourceType = UIImagePickerControllerSourceType.camera
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                print("当前相机不可用")
                return
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            let VC = BFPhotoAlbumViewController()
            navigationController?.pushViewController(VC, animated: true)
        }

    }

}

// MARK: - UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //保存图片至沙盒
    private func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String) -> String {
        if let imageData = UIImageJPEGRepresentation(currentImage, persent) as NSData? {
            let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! as NSString
            let path = cachesDirectory.appendingPathComponent("/ThreeBuild/ImageCache")
            if !FileManager.default.fileExists(atPath: path) {
                try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            let fullPath = path + "/" + "\(imageName)"
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
            return fullPath
        }
        return ""
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated:true, completion:nil)
        guard let image =  info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        let timeStamp = Int(Date().timeIntervalSince1970)
        let path = saveImage(currentImage: image, persent: 1.0, imageName: "\(timeStamp).png")
        BFPhotoAlbumFMDBManager.shared.insertData(time: timeStamp, type: .safeNew, path: path)
    }

    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
}

