import sys
from pbxproj import XcodeProject

def main():
    if len(sys.argv) != 2:
        print("Usage: python fix_project_paths_v4.py <project_path>")
        sys.exit(1)

    project_path = sys.argv[1]
    
    try:
        project = XcodeProject.load(project_path)
        print("Project loaded successfully.")

        # Fix for MessageRowOptimized.swift
        file_ref_id = '67069FBC2E34E7EC00B79643'
        file_ref = project.get_object(file_ref_id)
        if file_ref and file_ref.path == 'MessageRowOptimized.swift':
            print("Fixing path for MessageRowOptimized.swift")
            file_ref.path = '../../MessageRowOptimized.swift'
        
        # Fix for WebSocketManager.swift
        file_ref_id = '6706A0192E34E82200B79643'
        file_ref = project.get_object(file_ref_id)
        if file_ref and file_ref.path == 'Resources/Sources/Core/WebSocketManager.swift':
             print("Fixing path for WebSocketManager.swift")
             file_ref.path = '../Resources/Sources/Core/WebSocketManager.swift'

        project.save()
        print("Project saved successfully.")

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
