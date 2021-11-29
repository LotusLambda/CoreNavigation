Pod::Spec.new do |spec|
	spec.name = 'CoreNavigation'
	spec.ios.deployment_target = '10.0'
	spec.version = '2.0.0'
	spec.license = 'MIT'
	spec.summary = 'A Swift navigation framework'
	spec.author = 'Aron Balog'
	spec.homepage = 'https://github.com/aronbalog/CoreNavigation'
	spec.source = { :git => 'https://github.com/lotuslambda/CoreNavigation.git', :tag => spec.version }
	spec.requires_arc = true
	spec.source_files = 'CoreNavigation/**/*.{swift}'
	spec.swift_versions = "5.1"
end