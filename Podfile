# CocoaPods captures Node output as binary, but React Native uses it as UTF-8 paths.
module NodeOutputEncoding
  def execute_command(executable, command, raise_on_failure = true)
    output = super
    return output unless executable == 'node'

    utf8_output = output.dup.force_encoding(Encoding::UTF_8)
    utf8_output.valid_encoding? ? utf8_output : output
  end
end

Pod::Executable.singleton_class.prepend(NodeOutputEncoding)

react_native_path = File.join(__dir__, 'ReactNative/node_modules/react-native')
require File.join(react_native_path, 'scripts/react_native_pods')

platform :ios, '17.0'
workspace 'Showcase'
project 'App/App.xcodeproj'
prepare_react_native_project!

target 'App' do
  use_react_native!(
    :path => 'ReactNative/node_modules/react-native',
    :app_path => File.join(__dir__, 'ReactNative')
  )

  target 'AppTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  react_native_post_install(installer, react_native_path, :mac_catalyst_enabled => false)

  # The Swift app target also links the prebuilt React Native C++ code.
  installer.aggregate_targets.map(&:user_project).uniq.each do |project|
    app_target = project.native_targets.find { |target| target.name == 'App' }
    next unless app_target

    app_target.build_configurations.each do |configuration|
      flags = Array(configuration.build_settings.fetch('OTHER_LDFLAGS', '$(inherited)'))
      configuration.build_settings['OTHER_LDFLAGS'] = (flags + ['-lc++']).uniq
    end
    project.save
  end
end
