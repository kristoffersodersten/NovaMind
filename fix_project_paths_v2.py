import sys
from pbxproj import XcodeProject

def main():
    if len(sys.argv) != 2:
        print("Usage: python fix_project_paths_v2.py <project_path>")
        sys.exit(1)

    project_path = sys.argv[1]
    
    try:
        project = XcodeProject.load(project_path)
        print("Project loaded successfully.")

        # --- Path Correction Logic ---
        path_map = {
            "Views/Components/MessageRowOptimized.swift": "MessageRowOptimized.swift",
            "Realtime/Resources/Sources/Core/WebSocketManager.swift": "Resources/Sources/Core/WebSocketManager.swift"
        }

        for incorrect_path, correct_path in path_map.items():
            files = project.get_files_by_path(incorrect_path)
            if files:
                for f in files:
                    print(f"Found incorrect reference: {incorrect_path}")
                    f.path = correct_path
                    print(f"Corrected path to: {correct_path}")
            else:
                print(f"No file reference found for incorrect path: {incorrect_path}")

        # --- File Removal Logic ---
        paths_to_remove = [
            "Views/DesignSystem/KrilleCore2030Modifier.swift",
            "Views/Chat/IconButton.swift",
            "Views/DesignSystem/KrilleCore2030Extensions.swift",
        ]

        for path_to_remove in paths_to_remove:
            files = project.get_files_by_path(path_to_remove)
            if files:
                for f in files:
                    print(f"Removing file with path: {path_to_remove}")
                    project.remove_file_by_id(f.get_id())
            else:
                print(f"No file reference found for path to remove: {path_to_remove}")
        
        # Also remove by name, just in case
        names_to_remove = [
            "KrilleCore2030Modifier.swift",
            "IconButton.swift",
            "KrilleCore2030Extensions.swift",
        ]
        for name in names_to_remove:
             files_by_name = project.get_files_by_name(name)
             if files_by_name:
                 for f in files_by_name:
                    print(f"Removing file with name: {name}")
                    project.remove_file_by_id(f.get_id())


        project.save()
        print("Project saved successfully.")

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
