import Foundation

// MARK: - Simple Xcode Project Builder

struct XcodeProjectBuilder {
    let projectName = "NovaMind"
    let fileManager = FileManager.default
    let workspaceURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    
    func buildProject() {
        print("🚀 Building clean Xcode project for \(projectName)...")
        
        organizeFiles()
        generateXcodeProject()
        
        print("✅ Project structure created successfully!")
    }
    
    private func organizeFiles() {
        print("📁 Organizing project files...")
        
        // Create necessary directories
        let directories = [
            "\(projectName)/App",
            "\(projectName)/Views", 
            "\(projectName)/Models",
            "\(projectName)/Services",
            "\(projectName)/Core",
            "\(projectName)/UI",
            "\(projectName)/Resources",
            "\(projectName)/Supporting Files"
        ]
        
        for directory in directories {
            let dirURL = workspaceURL.appendingPathComponent(directory)
            try? fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
    }
    
    private func generateXcodeProject() {
        print("🔨 Generating Xcode project...")
        
        let projectURL = workspaceURL.appendingPathComponent("\(projectName).xcodeproj")
        try? fileManager.createDirectory(at: projectURL, withIntermediateDirectories: true)
        
        let pbxprojURL = projectURL.appendingPathComponent("project.pbxproj")
        let content = generatePBXContent()
        
        try? content.write(to: pbxprojURL, atomically: true, encoding: .utf8)
    }
    
    private func generatePBXContent() -> String {
        return """
// !$*UTF8*$!
{
\tarchiveVersion = 1;
\tclasses = {
\t};
\tobjectVersion = 60;
\tobjects = {

/* Begin PBXBuildFile section */
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
\t\t67000001 /* \(projectName).app */ = {
\t\t\tisa = PBXFileReference;
\t\t\texplicitFileType = wrapper.application;
\t\t\tpath = \(projectName).app;
\t\t\tsourceTree = BUILT_PRODUCTS_DIR;
\t\t};
/* End PBXFileReference section */

/* Begin PBXGroup section */
\t\t67000002 = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t67000003 /* \(projectName) */,
\t\t\t\t67000004 /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t67000013 /* \(projectName) */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tname = \(projectName);
\t\t\tproductName = \(projectName);
\t\t\tproductReference = 67000001 /* \(projectName).app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t67000017 /* Project object */ = {
\t\t\tisa = PBXProject;
\t\t\tbuildConfigurationList = 67000018;
\t\t\tmainGroup = 67000002;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t67000013 /* \(projectName) */,
\t\t\t);
\t\t};
/* End PBXProject section */

/* Begin XCBuildConfiguration section */
\t\t67000019 /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tname = Debug;
\t\t};
\t\t67000020 /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

\t};
\trootObject = 67000017 /* Project object */;
}
"""
    }
}

// MARK: - Entry Point
let builder = XcodeProjectBuilder()
builder.buildProject()
