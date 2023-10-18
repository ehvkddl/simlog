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
        
        let fileURL = directoryURL.appendingPathComponent(fileName)

        do {
            try image.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }

}
