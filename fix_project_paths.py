import sys
from pbxproj import XcodeProject

def main():
    if len(sys.argv) != 2:
        print("Usage: python fix_project.py <project_path>")
        sys.exit(1)

    project_path = sys.argv[1]
    
    try:
        project = XcodeProject.load(project_path)
        print("Project loaded successfully.")

        files_to_update = {
            "MessageRowOptimized.swift": "MessageRowOptimized.swift",
            "WebSocketManager.swift": "Resources/Sources/Core/WebSocketManager.swift",
        }

        files_to_remove_names = [
            "KrilleCore2030Modifier.swift",
            "IconButton.swift",
            "KrilleCore2030Extensions.swift",
            "KrilleStyle.swift",
            "ProjectAction.swift",
            "BrandIcon.swift",
            "MessageRow.swift",
            "ChatBubble.swift",
            "ProjectContextBar.swift",
            "AISaveGlowModifier.swift",
            "ActionButton.swift",
            "MessageRowAttachments.swift",
            "ModelPicker.swift",
            "KrilleStyleDemoView.swift",
            "a) **Uppgradera till en nyare modell** s",
            "- Temporärt: Ta bort alla tool-related i"
        ]
        
        # First, gather all file references to be removed
        files_to_remove_refs = []
        for file_ref in project.get_files_by_name("KrilleCore2030Modifier.swift"):
            files_to_remove_refs.append(file_ref)
        for file_ref in project.get_files_by_name("IconButton.swift"):
            files_to_remove_refs.append(file_ref)
        for file_ref in project.get_files_by_name("KrilleCore2030Extensions.swift"):
            files_to_remove_refs.append(file_ref)
            
        # Remove the gathered file references from the project
        for file_ref in files_to_remove_refs:
            print(f"Removing file reference: {file_ref.path}")
            project.remove_file_by_id(file_ref.get_id())


        # Update file paths
        for old_name, new_path in files_to_update.items():
            files = project.get_files_by_name(old_name)
            for f in files:
                print(f"Updating path for {old_name} to {new_path}")
                f.path = new_path

        # Remove files by name
        for file_name in files_to_remove_names:
            print(f"Attempting to remove file: {file_name}")
            files = project.get_files_by_name(file_name)
            if not files:
                print(f"No files found with name: {file_name}")
            for f in files:
                print(f"Removing file: {f.path}")
                project.remove_file_by_id(f.get_id())

        project.save()
        print("Project saved successfully.")

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
