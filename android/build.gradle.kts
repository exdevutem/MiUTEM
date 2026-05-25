allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.value(
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
)

subprojects {
    project.layout.buildDirectory.value(
        rootProject.layout.buildDirectory
            .dir(project.name)
            .get()
    )
}

subprojects {
    project.evaluationDependsOn(":app")
    dependencyLocking {
        ignoredDependencies.add("io.flutter:*")
        lockFile = file("${rootProject.projectDir}/project-${project.name}.lockfile")
        var ignoreFile = file("${rootProject.projectDir}/.ignore-locking.md")
        if (!ignoreFile.exists() && !project.hasProperty("local-engine-repo")) {
            lockAllConfigurations()
        }
    }
}

tasks.register<Delete>("clean") {
    description = "Delete rootProject buildDirectory"
    delete(rootProject.layout.buildDirectory)
}