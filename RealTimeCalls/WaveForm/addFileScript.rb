require 'xcodeproj'

project_path = 'WaveForm.xcworkspace'
project = Xcodeproj::Project.open(project_path)

file_group = project["WaveForm"]
file_group.new_file("../GeneratedFiles/Sample1.swift")

project.save()
