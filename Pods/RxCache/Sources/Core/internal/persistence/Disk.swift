// Disk.swift
// RxCache
//
// Copyright (c) 2016 Victor Albertos https://github.com/VictorAlbertos
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

class Disk : Persistence {
    let path : String
    
    init() {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dirPath: String = documentsDirectory.appendingPathComponent(Locale.RxSDomain)
        
        if !fileManager.fileExists(atPath: dirPath) {
            do {
                try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        self.path = dirPath + "/"
    }
    
    func evict(_ key: String) {
        do {
            try FileManager.default.removeItem(atPath: path+key)
        } catch {
            print("Failed to delete data for key" + key)
        }
    }
    
    func evictAll() {
        let fileManager = FileManager.default
        let path = self.path
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: path)
            for pathComponent in contents {
                let path = (path as NSString).appendingPathComponent(pathComponent)
                do {
                    try fileManager.removeItem(atPath: path)
                } catch {
                    print("Failed to remove path " + path)
                }
            }
        } catch {
            print("Failed to list directory")
        }
    }
    
    func allKeys() -> [String] {
        let fileManager = FileManager.default
        let path = self.path
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: path)
            return contents
        } catch {
            return [String]()
        }
    }
    
    func storedMB() -> Int? {
        let keys = self.allKeys()
        var storedBytes : Double = 0
        var anyError = false
        
        keys.forEach { (key) -> () in
            if let fileMB = fileBytes(key) {
                storedBytes += fileMB
            } else {
                anyError = true
            }
        }
        
        let storedMB : Double = ceil(storedBytes/1024/1024)
        return anyError ? nil : Int(storedMB)
    }
    
    func fileBytes(_ key: String) -> Double? {
        let path = self.path

        let pathFile = (path as NSString).appendingPathComponent(key)
        do {
            let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: pathFile) as NSDictionary?
            
            if let _attr = attr {
                return Double(_attr.fileSize())
            }
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func retrieveRecord<T>(_ key: String) -> Record<T>? {
        NSKeyedUnarchiver.setClass(Record<T>.self, forClassName: "Record")
        
        if let record : Record<T> = NSKeyedUnarchiver.unarchiveObject(withFile: path+key) as? Record<T> {
            if let fileBytes = fileBytes(key) {
                record.sizeOnMb = fileBytes/1024/1024
            }
            return record
        }
        
        return nil
    }
    
    func saveRecord<T>(_ key: String, record : Record<T>) -> Bool {
        NSKeyedArchiver.setClassName("Record", for: Record<T>.self)
        return NSKeyedArchiver.archiveRootObject(record, toFile: path+key)
    }
}
