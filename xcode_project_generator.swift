import Foundation

#!/usr/bin/env swift


// MARK: - Xcode Project Generator

struct XcodeProjectGenerator {
    private let workspaceURL: URL
    private let projectName = "NovaMind"
    private let fileManager = FileManager.default
    
    init(workspacePath: String) {
        self.workspaceURL = URL(fileURLWithPath: workspacePath)
    }
    
    func generateProject() {
        print("🎯 Generating new Xcode project structure...")
        
        // Remove old project file
        removeOldProject()
        
        // Create new project structure
        createProjectStructure()
        
        // Generate project.pbxproj
        generateProjectFile()
        
        print("✅ Xcode project generated successfully!")
    }
    
    private func removeOldProject() {
        let oldProjectURL = workspaceURL.appendingPathComponent("\(projectName).xcodeproj")
        if fileManager.fileExists(atPath: oldProjectURL.path) {
            try? fileManager.removeItem(at: oldProjectURL)
            print("🗑️ Removed old project file")
        }
    }
    
    private func createProjectStructure() {
        let projectURL = workspaceURL.appendingPathComponent("\(projectName).xcodeproj")
        try? fileManager.createDirectory(at: projectURL, withIntermediateDirectories: true)
        
        let workspaceURL = projectURL.appendingPathComponent("project.xcworkspace")
        try? fileManager.createDirectory(at: workspaceURL, withIntermediateDirectories: true)
        
        let contentsURL = workspaceURL.appendingPathComponent("contents.xcworkspacedata")
        let workspaceData = """
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
"""
        try? workspaceData.write(to: contentsURL, atomically: true, encoding: .utf8)
        print("📁 Created project structure")
    }
    
    private func generateProjectFile() {
        let projectURL = workspaceURL.appendingPathComponent("\(projectName).xcodeproj")
        let pbxprojURL = projectURL.appendingPathComponent("project.pbxproj")
        
        // Scan for Swift files in the correct structure
        let swiftFiles = findSwiftFiles()
        
        let projectContent = generatePBXProj(swiftFiles: swiftFiles)
        
        do {
            try projectContent.write(to: pbxprojURL, atomically: true, encoding: .utf8)
            print("📄 Generated project.pbxproj with \(swiftFiles.count) Swift files")
        } catch {
            print("❌ Failed to write project file: \(error)")
        }
    }
    
    private func findSwiftFiles() -> [String] {
        var swiftFiles: [String] = []
        
        let novaMindURL = workspaceURL.appendingPathComponent("NovaMind")
        if let enumerator = fileManager.enumerator(at: novaMindURL, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator {
                if fileURL.pathExtension == "swift" {
                    let relativePath = String(fileURL.path.dropFirst(workspaceURL.path.count + 1))
                    swiftFiles.append(relativePath)
                }
            }
        }
        
        return swiftFiles.sorted()
    }
    
    private func generatePBXProj(swiftFiles: [String]) -> String {
        let buildFileRefs = swiftFiles.enumerated().map { index, file in
            let cleanName = URL(fileURLWithPath: file).lastPathComponent
            return """
\t\t670\(String(format: "%04X", index + 1000))2E34E7EC00B79643 /* \(cleanName) in Sources */ = {isa = PBXBuildFile; fileRef = 670\(String(format: "%04X", index + 2000))2E34E7EC00B79643 /* \(cleanName) */; };"""
        }.joined(separator: "\n")
        
        let fileRefs = swiftFiles.enumerated().map { index, file in
            let cleanName = URL(fileURLWithPath: file).lastPathComponent
            return """
\t\t670\(String(format: "%04X", index + 2000))2E34E7EC00B79643 /* \(cleanName) */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \(cleanName); sourceTree = "<group>"; };"""
        }.joined(separator: "\n")
        
        let buildPhases = swiftFiles.enumerated().map { index, _ in
            "\t\t\t\t670\(String(format: "%04X", index + 1000))2E34E7EC00B79643"
        }.joined(separator: ",\n")
        
        return """
// !$*UTF8*$!
{
\tarchiveVersion = 1;
\tclasses = {
\t};
\tobjectVersion = 77;
\tobjects = {

/* Begin PBXBuildFile section */
\(buildFileRefs)
\t\t6708C7912E34E14E0047D2EB /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 6708C78D2E34E14E0047D2EB /* Assets.xcassets */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
\(fileRefs)
\t\t6708C7752E34DB600047D2EB /* NovaMind.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = NovaMind.app; sourceTree = BUILT_PRODUCTS_DIR; };
\t\t6708C78D2E34E14E0047D2EB /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
\t\t6708C7942E34E2B80047D2EB /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
\t\t6708C7952E34E2B80047D2EB /* NovaMind.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = NovaMind.entitlements; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t6708C7722E34DB600047D2EB /* Frameworks */ = {
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t6708C76C2E34DB600047D2EB = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t6708C7772E34DB600047D2EB /* NovaMind */,
\t\t\t\t6708C78D2E34E14E0047D2EB /* Assets.xcassets */,
\t\t\t\t6708C7762E34DB600047D2EB /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
\t\t6708C7762E34DB600047D2EB /* Products */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t6708C7752E34DB600047D2EB /* NovaMind.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t};
\t\t6708C7772E34DB600047D2EB /* NovaMind */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t6708C7942E34E2B80047D2EB /* Info.plist */,
\t\t\t\t6708C7952E34E2B80047D2EB /* NovaMind.entitlements */,
\t\t\t);
\t\t\tpath = NovaMind;
\t\t\tsourceTree = "<group>";
\t\t};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t6708C7742E34DB600047D2EB /* NovaMind */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = 6708C7822E34DB610047D2EB /* Build configuration list for PBXNativeTarget "NovaMind" */;
\t\t\tbuildPhases = (
\t\t\t\t6708C7712E34DB600047D2EB /* Sources */,
\t\t\t\t6708C7722E34DB600047D2EB /* Frameworks */,
\t\t\t\t6708C7732E34DB600047D2EB /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = NovaMind;
\t\t\tproductName = NovaMind;
\t\t\tproductReference = 6708C7752E34DB600047D2EB /* NovaMind.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t6708C76D2E34DB600047D2EB /* Project object */ = {
\t\t\tisa = PBXProject;
\t\t\tattributes = {
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1600;
\t\t\t\tLastUpgradeCheck = 1600;
\t\t\t\tTargetAttributes = {
\t\t\t\t\t6708C7742E34DB600047D2EB = {
\t\t\t\t\t\tCreatedOnToolsVersion = 16.0;
\t\t\t\t\t};
\t\t\t\t};
\t\t\t};
\t\t\tbuildConfigurationList = 6708C7702E34DB600047D2EB /* Build configuration list for PBXProject "NovaMind" */;
\t\t\tcompatibilityVersion = "Xcode 15.3";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = 6708C76C2E34DB600047D2EB;
\t\t\tproductRefGroup = 6708C7762E34DB600047D2EB /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t6708C7742E34DB600047D2EB /* NovaMind */,
\t\t\t);
\t\t};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t6708C7732E34DB600047D2EB /* Resources */ = {
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t\t6708C7912E34E14E0047D2EB /* Assets.xcassets in Resources */,
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t6708C7712E34DB600047D2EB /* Sources */ = {
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\(buildPhases),
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t6708C7802E34DB610047D2EB /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tASYNC_COMPILATION_REQUIREMENTS = YES;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;
\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_COMMA = YES;
\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;
\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;
\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;
\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;
\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;
\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;
\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;
\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$(inherited)",
\t\t\t\t);
\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;
\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;
\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;
\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;
\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 14.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = macosx;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t6708C7812E34DB610047D2EB /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tASYNC_COMPILATION_REQUIREMENTS = YES;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;
\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_COMMA = YES;
\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;
\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;
\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;
\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;
\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;
\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;
\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;
\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;
\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;
\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;
\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;
\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;
\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 14.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tSDKROOT = macosx;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t};
\t\t\tname = Release;
\t\t};
\t\t6708C7832E34DB610047D2EB /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tCODE_SIGN_ENTITLEMENTS = NovaMind/NovaMind.entitlements;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCOMBINE_HIDPI_IMAGES = YES;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "\"NovaMind/Preview Content\"";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_FILE = NovaMind/Info.plist;
\t\t\t\tINFOPLIST_KEY_NSHumanReadableCopyright = "";
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/../Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.novamind.NovaMind;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t6708C7842E34DB610047D2EB /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tCODE_SIGN_ENTITLEMENTS = NovaMind/NovaMind.entitlements;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCOMBINE_HIDPI_IMAGES = YES;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "\"NovaMind/Preview Content\"";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_FILE = NovaMind/Info.plist;
\t\t\t\tINFOPLIST_KEY_NSHumanReadableCopyright = "";
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/../Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.novamind.NovaMind;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t};
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t6708C7702E34DB600047D2EB /* Build configuration list for PBXProject "NovaMind" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t6708C7802E34DB610047D2EB /* Debug */,
\t\t\t\t6708C7812E34DB610047D2EB /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
\t\t6708C7822E34DB610047D2EB /* Build configuration list for PBXNativeTarget "NovaMind" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t6708C7832E34DB610047D2EB /* Debug */,
\t\t\t\t6708C7842E34DB610047D2EB /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
/* End XCConfigurationList section */
\t};
\trootObject = 6708C76D2E34DB600047D2EB /* Project object */;
}
"""
    }
}

// MARK: - Main Execution
let generator = XcodeProjectGenerator(workspacePath: "/Users/kristoffersodersten/NovaMind")
generator.generateProject()
