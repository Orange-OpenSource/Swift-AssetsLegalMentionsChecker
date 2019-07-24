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

/// Program which has the aim of finding in images if metadata contain legal mentions line.
/// Indeed we might need to be sure all the assets included in a project have the legal mentions like
/// copyrights or licenses. These kinds of details are stored in the metadata of images.
///
/// For now only the PNG messages are managed. Such details are expected in metadata fields named TIFF, IPTC and PNG.
///
/// Program exists:
///     - (-1): something wrong occured (command line options for example)
///     - (0): no error appeared, normal exit without image processing (e.g. display help)
///     - (+1): normal exit but failure occured during check of images (i.e. at least 1 file does not have legal mention in credits)
///     - (+2): normal exit, all files contain the legam mention
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 19/06/2019
///

import Foundation

// Mark: - Configuration

public let VERSION = "1.0.0"
public var VERBOSE = false

private let consoleWritter = ConsoleOutput()
private let argumentsParser = ConsoleArgumentsParser()

// Mark: - Deal with options

consoleWritter.printWelcome()

let parameters = ConsoleInput().processProgram(arguments: &CommandLine.arguments)

guard argumentsParser.areWellDefined(arguments: parameters) else {
    consoleWritter.printBadCommandLineErrorMessage()
    exit(-1)
}

if argumentsParser.isForHelp(arguments: parameters) {
    consoleWritter.printUsage()
    consoleWritter.printBye()
    exit(0)
}

if argumentsParser.isForVersion(arguments: parameters) {
    consoleWritter.printVersion()
    consoleWritter.printBye()
    exit(0)
}

if argumentsParser.isVerboseDefined(in: parameters) {
    VERBOSE = true
}

let folderToProcess = parameters.filter { $0.0 == .folderToProcess }[0].1
let mentionToFind = parameters.filter { $0.0 == .lineToFind }[0].1

if folderToProcess.isEmpty {
    consoleWritter.write("The folder to process is undefined", to: .error)
    exit(-1)
}

if !FileManager.default.fileExists(atPath: folderToProcess) {
    consoleWritter.write("The folder to process does not exist, please check its path", to: .error)
    exit(-1)
}

if mentionToFind.isEmpty {
    consoleWritter.write("The credit line to look for is undefined", to: .error)
    exit(-1)
}

// Mark: - Instructions to check files

consoleWritter.write("Will look in folder '\(folderToProcess)' for mention '\(mentionToFind)'", to: .standard)

let areAllResourcesSuitable = AssetsLegalMentionsChecker("png|PNG").lookIn(folder: folderToProcess, for: mentionToFind)

// Mark: - Check of results

if !areAllResourcesSuitable {
    consoleWritter.write("🚨 FAILURE 🚨: There is at least one file without legal mention in metadata")
    consoleWritter.printBye()
    exit(1)
} else {
    consoleWritter.write("✅ SUCCESS ✅: All files contain legal mention in metadata")
    consoleWritter.printBye()
    exit(2)
}


