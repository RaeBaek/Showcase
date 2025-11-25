import ProjectDescription

let nameArgument = Template.Attribute.required("name")

let template = Template(
    description: "Module template with Project.swift, Sources/, Resources/",
    attributes: [
        nameArgument
    ],
    items: [
        // Project.swift
        .file(
            path: "\(nameArgument)/Project.swift",
            templatePath: "project.stencil"
        ),

        // Sources directory
        .directory(
            path: "\(nameArgument)/Sources",
            sourcePath: ""
        ),

        // Sources file
        .file(
            path: "\(nameArgument)/Sources/\(nameArgument).swift",
            templatePath: "sources.stencil"
        ),

        // Resources directory
        .directory(
            path: "\(nameArgument)/Resources",
            sourcePath: ""
        )
    ]
)
