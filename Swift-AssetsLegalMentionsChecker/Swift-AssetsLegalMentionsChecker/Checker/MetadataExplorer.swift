/**
     Swift-AssetsLegalMentionsChecker
     Copyright (C) 2019 Orange SA
 
     MIT License
 
     Permission is hereby granted, free of charge, to any person obtaining a copy
     of this software and associated documentation files (the "Software"), to deal
     in the Software without restriction, including without limitation the rights
     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the Software is
     furnished to do so, subject to the following conditions:
     The above copyright notice and this permission notice shall be included in all
     copies or substantial portions of the Software.
     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     SOFTWARE.
 */

import Foundation

/// Structure which has the aim of reading metadata of images to look for expected details
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 27/06/2019
///
struct MetadataExplorer {
    
    // Mark: - Variables
    
    /// To display messages in the console
    let output = ConsoleOutput()
    
    // Mark: - Functions
    
    /// Reads the metadata of the all the files at these paths and looks if an expected detail is available or not.
    /// - Parameters:
    ///     - at: The array of files' paths which must contain the expected detail in metadata
    ///     - for: The detail expected in the metadata of the file at this path
    /// - Returns:
    ///     - A boolean value indicating if the detail is available in all the files(true) or not (false for at least 1 file)
    ///
    func look(at files: [String], for detail: String) -> Bool {
        output.verbose("Will process \(files.count) files")
        var allFilesAreSuitable = true
        for file in files {
            output.verbose("Processing file '\(file)")
            let isFileSuitable = look(at: file, for: detail)
            if !isFileSuitable {
                output.write("❌ It seems the file at \(file) does not have in metadata the mention")
            }
            allFilesAreSuitable = allFilesAreSuitable && isFileSuitable
        }
        return allFilesAreSuitable
    }
    
    /// Reads the metadata of the file at this path and looks if an expected detail is available or not.
    /// Will look in dedicated metadata bundles: TIFF, IPTC and PNG. These groups are defined for PNG files.
    /// - Parameters:
    ///     - at: The path to the image file (must be PNG) which must contain the expected detail in metadata
    ///     - for: The detail expected in the metadata of the file at this path
    /// - Returns:
    ///     - A boolean value indicating if the detail is available (true) or not (false)
    ///
    func look(at path: String, for detail: String) -> Bool {
        
        let url = URL(fileURLWithPath: path)
        
        guard let imageData = try? Data(contentsOf: url) else {
            output.write("A problem occured with the file at '\(path)'", to: .error)
            return false
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            output.write("A problem occured with the file at '\(path)'", to: .error)
            return false
        }
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
            as? [AnyHashable : Any] else {
            output.write("It seems no metadata are avaialble for file at '\(path)'", to: .error)
            return false
        }
    
        var areDetailsDefined = false
        if processTIFF(bundle: metadata["{TIFF}"] as? [String : String]) == detail {
            areDetailsDefined = true
        } else {
            output.verbose("⚠️  Warning: Legal mentions are not defined in TIFF metadata field")
        }
        if processIPTC(bundle: metadata["{IPTC}"] as? [String : String]) == detail {
            areDetailsDefined = true
        } else {
            output.verbose("⚠️  Warning: Legal mentions are not defined in IPTC metadata field")
        }
        if processPNG(bundle: metadata["{PNG}"] as? [String : Any]) == detail {
            areDetailsDefined = true
        } else {
            output.verbose("⚠️  Warning: legal mentions are not defined in PNG metadata field")
        }
        
        return areDetailsDefined
        
    }
    
    /// Parses the group of metadata assuming the group is reated to TIFF field.
    /// Returns the value of the field which should contain the legal mentions
    /// - Parameters:
    ///     - data: The bunch of data to process
    /// - Returns:
    ///     - The value of the field which should contain the legal mention, or nil if undefined
    ///
    private func processTIFF(bundle data: [String : String]?) -> String? {
        guard let data = data else {
            return nil
        }
        return data["Copyright"]
    }
    
    /// Parses the group of metadata assuming the group is reated to IPTC field.
    /// Returns the value of the field which should contain the legal mentions
    /// - Parameters:
    ///     - data: The bunch of data to process
    /// - Returns:
    ///     - The value of the field which should contain the legal mention, or nil if undefined
    ///
    private func processIPTC(bundle data: [String : String]?) -> String? {
        guard let data = data else {
            return nil
        }
        return data["CopyrightNotice"]
    }
 
    /// Parses the group of metadata assuming the group is reated to PNG field.
    /// Returns the value of the field which should contain the legal mentions
    /// - Parameters:
    ///     - data: The bunch of data to process
    /// - Returns:
    ///     - The value of the field which should contain the legal mention, or nil if undefined
    ///
    private func processPNG(bundle data: [String : Any]?) -> String? {
        guard let data = data else {
            return nil
        }
        return data["Copyright"] as? String
    }
    
}
