require 'xcodeproj'

class SparkConfigurator
    @@spark_attributes_code_generator_url = 'https://github.com/epam/spark-ios-framework/raw/master/tools/binaries/SparkAttributesCodeGenerator'
    
    def self.set_github_credentials(username, password)
        @@github_username = username
        @@github_password = password
    end

    def self.post_install(installer_representation)
=begin
        sparkframework_path = nil
        installer_representation.pods.each do |pod_representation|
            if pod_representation.name == 'SparkFramework'
                sparkframework_path = pod_representation.root
            end
        end

        if sparkframework_path.nil?
            puts 'SparkConfigurator.rb called without SparkFramework being defined in Podfile.'
            Process.exit!(true)
        end
=end
        SparkConfigurator::download_binaries(installer_representation)
        SparkConfigurator::modify_user_project(installer_representation)
        SparkConfigurator::modify_pods_project(installer_representation)
    end

    def self.modify_user_project(installer_representation)
        installer_representation.installer.analysis_result.targets.each do |target|
            if target.user_project_path.exist? && target.user_target_uuids.any?
                user_project = Xcodeproj::Project.open(target.user_project_path)
        
                user_targets = Array.new
                target.user_target_uuids.each do |user_target_uuid|
                    user_target = get_target_from_project_by_uuid(user_project, user_target_uuid)
                    if not user_target.nil?
                        user_targets.push(user_target)
                
                        user_project_dir = File.dirname(user_project.path)
                        genereted_attributes_path = "#{user_project_dir}/#{user_target.name}/SparkGeneratedAttributes"
                        SparkConfigurator::create_generated_attributes_for_path(genereted_attributes_path)
                    end
                end
        
                run_script_user = "\"#{installer_representation.config.project_root}/binaries/SparkAttributesCodeGenerator\""\
                " -src=\"${SRCROOT}/${PROJECT_NAME}\""\
                " -dst=\"${SRCROOT}/${PROJECT_NAME}/SparkGeneratedAttributes/\""
                SparkConfigurator::add_script_to_project_targets(run_script_user, 'Spark - generate attributes', user_project, user_targets)
            end
        end
    end

    def self.modify_pods_project(installer_representation)
        path_proj_pods = installer_representation.config.project_pods_root
        genereted_attributes_path = "#{path_proj_pods}/SparkFramework/Framework/SparkGeneratedAttributes"
        SparkConfigurator::create_generated_attributes_for_path(genereted_attributes_path)

        run_script_pods = "\"#{installer_representation.config.project_root}/binaries/SparkAttributesCodeGenerator\""\
        " -src=\"${SRCROOT}/\""\
        " -dst=\"${SRCROOT}/SparkFramework/Framework/SparkGeneratedAttributes/\""
        SparkConfigurator::add_script_to_project_targets(run_script_pods, 'Spark - generate attributes', installer_representation.project, installer_representation.project.targets)
    end

    def self.get_target_from_project_by_uuid(project, uuid)
        project.targets.each do |project_target|
            if project_target.uuid.eql? uuid
                return project_target
            end
        end
        return nil
    end

    def self.create_generated_attributes_for_path(path)
        generated_attributes_file_path = "#{path}/SparkGeneratedAttribute.m"

        if !File.exists?(generated_attributes_file_path)
            FileUtils.mkdir_p(path)
            puts "create: #{generated_attributes_file_path}"
            File.new(generated_attributes_file_path, 'w+').close
        end
    end
    
    def self.add_script_to_project_targets(script, script_name, project, targets)
        targets.each do |target|
            phase = project.new(Xcodeproj::Project::PBXShellScriptBuildPhase)
            phase.name = script_name
            phase.shell_script = script
            
            script_already_added = false
            target.build_phases.each do |build_phase|
                if build_phase.display_name == script_name
                    script_already_added = true
                    break
                end
            end
            
            next if script_already_added
            
            target.build_phases.insert(0, phase)
        end
        project.save
    end

    def self.download_binaries(installer_representation)
        binary_path =  "#{installer_representation.config.project_root}/binaries"

        if !File.directory?(binary_path)
            FileUtils.mkdir(binary_path)
        end

        attributes_code_generator_path = "#{binary_path}/SparkAttributesCodeGenerator"

        curl_call = "curl "
        if (defined? @@github_username)
            curl_call += "-u #{@@github_username}:#{@@github_password} "
        end
        curl_call += "-L -o \"#{attributes_code_generator_path}\" #{@@spark_attributes_code_generator_url}"

        puts curl_call

        system curl_call
        system "chmod +x \"#{attributes_code_generator_path}\""
    end
end
