//
//  MediaPicker.swift
//  mediaPicker
//
//  Created by Wataru Maeda on 2017/12/11.
//  Copyright © 2017 com.watarumaeda. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias VideoCallback = (_ videoPath: String) -> ()

// MARK: - MediaPicker

class MediaPicker: NSObject {
  
  static var shared = MediaPicker()
  private override init() {}
  fileprivate var videoCallback: VideoCallback?
  
  func recordVideo(_ presentViewController: UIViewController,
                   callback: @escaping VideoCallback) {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.cameraDevice = .rear
    picker.mediaTypes = [kUTTypeMovie as String]
    picker.cameraCaptureMode = .video
    picker.allowsEditing = true
    picker.delegate = self
    presentViewController.present(picker, animated: true, completion: nil)
    videoCallback = callback
  }
  
  func selectVideo(_ presentViewController: UIViewController,
                   callback: @escaping VideoCallback) {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.mediaTypes = [kUTTypeMovie as String]
    picker.allowsEditing = true
    picker.delegate = self
    presentViewController.present(picker, animated: true, completion: nil)
    videoCallback = callback
  }
}

// MARK: - UIImagePickerControllerDelegate

extension MediaPicker: UIImagePickerControllerDelegate {
  
  public func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let mediaType = info[UIImagePickerControllerMediaType] as? String else { return }
    if mediaType == kUTTypeMovie as String {
      guard let videoUrl = info[UIImagePickerControllerMediaURL] as? URL else { return }
      videoCallback?(videoUrl.path)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UINavigationControllerDelegate

extension MediaPicker: UINavigationControllerDelegate {}
