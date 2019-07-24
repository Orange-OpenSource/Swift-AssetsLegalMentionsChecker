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

/// The types of options to give to the program.
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 19/06/2019
///
enum ConsoleArgumentTypes: String {
    
    /// The location of the folder to process recursively
    case folderToProcess = "--folder"
    
    /// The credit / copyright / legal mention to look in metadata of images in the folder
    case lineToFind = "--mention"
    
    /// Display the help / usage
    case help = "--help"
    
    /// Display the version
    case version = "--version"
    
    /// Define the verbose mode
    case verbose = "--versbose"

    /// Undefined option
    case undefined
    
    /// Constructor
    /// - Parameters:
    ///     - value: The value given to the program as parameter
    ///
    init(value: String) {
        switch value {
        case "--folder":
            self = .folderToProcess
        case "--mention":
            self = .lineToFind
        case "--help":
            self = .help
        case "--version":
            self = .version
        case "--verbose":
            self = .verbose
        default:
            self = .undefined
        }
    }
    
}