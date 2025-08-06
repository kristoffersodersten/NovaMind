import Foundation

// MARK: - Project Configuration
struct ProjectConfig {
    static let projectName = "NovaMind"
    static let bundleID = "com.novamind.macos"
    static let deploymentTarget = "14.0"
    
    static let directories: [String] = [
        "App",
        "Views",
        "Models",
        "Services",
        "Core",
        "Components",
        "Infrastructure",
        "Resources",
        "Supporting Files"
    ]
}

// MARK: - Xcode Project Builder
struct XcodeProjectBuilder {
    private let projectName = ProjectConfig.projectName
    private let fileManager = FileManager.default
    private let workspaceURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    
    func buildProject() {
        print("🚀 Building clean Xcode project for \(projectName)...")
        
        do {
            try createDirectoryStructure()
            try generateXcodeProject()
            print("✅ Project structure created successfully!")
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    private func createDirectoryStructure() throws {
        print("📁 Creating directory structure...")
        
        for directory in ProjectConfig.directories {
            let dirURL = workspaceURL.appendingPathComponent("\(projectName)/\(directory)")
            try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
    }
    
    private func generateXcodeProject() throws {
        print("🔨 Generating Xcode project...")
        
        let projectURL = workspaceURL.appendingPathComponent("\(projectName).xcodeproj")
        try fileManager.createDirectory(at: projectURL, withIntermediateDirectories: true)
        
        let pbxprojURL = projectURL.appendingPathComponent("project.pbxproj")
        let content = generateBasicPBXContent()
        
        try content.write(to: pbxprojURL, atomically: true, encoding: .utf8)
        try createWorkspaceFile(at: projectURL)
    }
    
    private func createWorkspaceFile(at projectURL: URL) throws {
        let workspaceURL = projectURL.appendingPathComponent("project.xcworkspace")
        try fileManager.createDirectory(at: workspaceURL, withIntermediateDirectories: true)
        
        let contentsURL = workspaceURL.appendingPathComponent("contents.xcworkspacedata")
        let workspaceContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Workspace version="1.0">
           <FileRef location="self:">
           </FileRef>
        </Workspace>
        """
        try workspaceContent.write(to: contentsURL, atomically: true, encoding: .utf8)
    }
    
    private func generateBasicPBXContent() -> String {
        return """
        // !$*UTF8*$!
        {
        \tarchiveVersion = 1;
        \tclasses = { };
        \tobjectVersion = 60;
        \tobjects = {
        \t\t67000001 = {
        \t\t\tisa = PBXFileReference;
        \t\t\texplicitFileType = wrapper.application;
        \t\t\tpath = \(projectName).app;
        \t\t\tsourceTree = BUILT_PRODUCTS_DIR;
        \t\t};
        \t\t67000002 = {
        \t\t\tisa = PBXGroup;
        \t\t\tchildren = (
        \t\t\t\t67000003,
        \t\t\t\t67000004,
        \t\t\t);
        \t\t\tsourceTree = "<group>";
        \t\t};
        \t\t67000003 = {
        \t\t\tisa = PBXGroup;
        \t\t\tchildren = ( );
        \t\t\tpath = \(projectName);
        \t\t\tsourceTree = "<group>";
        \t\t};
        \t\t67000004 = {
        \t\t\tisa = PBXGroup;
        \t\t\tchildren = (
        \t\t\t\t67000001,
        \t\t\t);
        \t\t\tname = Products;
        \t\t\tsourceTree = "<group>";
        \t\t};
        \t\t67000013 = {
        \t\t\tisa = PBXNativeTarget;
        \t\t\tname = \(projectName);
        \t\t\tproductName = \(projectName);
        \t\t\tproductReference = 67000001;
        \t\t\tproductType = "com.apple.product-type.application";
        \t\t};
        \t\t67000017 = {
        \t\t\tisa = PBXProject;
        \t\t\tbuildConfigurationList = 67000018;
        \t\t\tmainGroup = 67000002;
        \t\t\tprojectDirPath = "";
        \t\t\tprojectRoot = "";
        \t\t\ttargets = (
        \t\t\t\t67000013,
        \t\t\t);
        \t\t};
        \t\t67000018 = {
        \t\t\tisa = XCConfigurationList;
        \t\t\tbuildConfigurations = (
        \t\t\t\t67000019,
        \t\t\t\t67000020,
        \t\t\t);
        \t\t\tdefaultConfigurationIsVisible = 0;
        \t\t\tdefaultConfigurationName = Release;
        \t\t};
        \t\t67000019 = {
        \t\t\tisa = XCBuildConfiguration;
        \t\t\tname = Debug;
        \t\t};
        \t\t67000020 = {
        \t\t\tisa = XCBuildConfiguration;
        \t\t\tname = Release;
        \t\t};
        \t};
        \trootObject = 67000017;
        }
        """
    }
}

// MARK: - Entry Point
let builder = XcodeProjectBuilder()
builder.buildProject()
