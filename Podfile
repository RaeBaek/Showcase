# CocoaPods captures Node output as binary, but React Native uses it as UTF-8 paths.
module NodeOutputEncoding
  def execute_command(executable, command, raise_on_failure = true)
    return super unless executable == 'node'

    # On macOS, Node resolves paths as NFD while Ruby uses NFC. Keep Codegen's
    # input paths consistent with Node, then return NFC paths to CocoaPods.
    macos = RUBY_PLATFORM.include?('darwin')
    node_command = macos ? command.map { |argument| argument.to_s.unicode_normalize(:nfd) } : command
    output = super(executable, node_command, raise_on_failure)

    utf8_output = output.dup.force_encoding(Encoding::UTF_8)
    return output unless utf8_output.valid_encoding?

    macos ? utf8_output.unicode_normalize(:nfc) : utf8_output
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

  # RN declares these pods above; only change their warning policy.
  %w[React-Core-prebuilt React-RCTAppDelegate].each do |pod_name|
    current_target_definition.set_inhibit_warnings_for_pod(pod_name, true)
  end

  target 'AppTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  react_native_post_install(installer, react_native_path, :mac_catalyst_enabled => false)

  # CocoaPods adds per-pod system search paths to C flags, but not Swift's Clang importer.
  # Limit the Swift-side policy to the prebuilt RN framework and relocated RN headers.
  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.xcconfigs.each do |configuration_name, config|
      ReactNativePodsUtils.add_flag_to_map_with_inheritance(
        config.attributes,
        'OTHER_SWIFT_FLAGS',
        ' -Xcc -isystem -Xcc "$(PODS_ROOT)/React-Core-prebuilt/Headers"' \
        ' -Xcc -iframework -Xcc "$(PODS_XCFRAMEWORKS_BUILD_DIR)/React-Core-prebuilt"'
      )
      config.save_as(aggregate_target.xcconfig_path(configuration_name))
    end
  end

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
