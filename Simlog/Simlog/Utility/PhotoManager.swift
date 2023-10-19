//
//  FileManager.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/13.
//

import UIKit

class PhotoManager {

    static let shared = PhotoManager()
    private init() {}

    let fileManager = FileManager.default
    
    func saveImageToDocument(date: String, fileName: String, image: Data) {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let directoryURL = documentDirectory.appendingPathComponent("DailyLog/\(date)/Diary")
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
        
        let fileURL = directoryURL.appendingPathComponent("\(fileName).jpg")

        do {
            try image.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(date: String, fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let directoryURL = documentDirectory.appendingPathComponent("DailyLog/\(date)/Diary")
        
        let fileURL = directoryURL.appendingPathComponent("\(fileName).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }

}
