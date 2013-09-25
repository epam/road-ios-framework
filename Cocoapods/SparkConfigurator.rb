require 'xcodeproj'

class SparkConfigurator
    @@user_project_name = File.basename(Dir.getwd)

    @@path_proj_user = (Dir.glob Dir.getwd).last
    @@path_user_project = @@path_proj_user + "/#{@@user_project_name}.xcodeproj"
    
    @@path_proj_pods = @@path_proj_user + '/Pods'
    
    def self.pre_install(installer)
        genereted_attributes_user_path = "#{@@path_proj_user}/#{@@user_project_name}/SparkGeneratedAttributes"
        genereted_attributes_pods_path = "#{@@path_proj_pods}/SparkFramework/Framework/SparkGeneratedAttributes"
        
        SparkConfigurator::create_generated_attributes_for_path(genereted_attributes_user_path)
        SparkConfigurator::create_generated_attributes_for_path(genereted_attributes_pods_path)
    end
    
    def self.post_install(installer)
        # run scripts
        run_script_user = "#{@@path_proj_user}/binaries/SparkAttributesCodeGenerator"\
        " -src=#{@@path_proj_user}/#{@@user_project_name}"\
        " -dst=#{@@path_proj_user}/#{@@user_project_name}/SparkGeneratedAttributes/"
        run_script_pods = "#{@@path_proj_user}/binaries/SparkAttributesCodeGenerator"\
        " -src=#{@@path_proj_pods}/"\
        " -dst=#{@@path_proj_pods}/SparkFramework/Framework/SparkGeneratedAttributes/"
        
        puts "user's project: #{@@path_user_project}"
        
        if File.exists?(path_user_project)
            puts "Info: found user's project by path: #{@@path_user_project}"
            else
            puts "Error: not found user's project (Podfile should be located in your project directory)"
            Process.exit!(true)
        end
        
        # user's project
        #TODO check for already created "Spark generate attributes"

        proj = Xcodeproj::Project.open(@@path_user_project)
        SparkConfigurator::add_script_to_project_targets(run_script_user, 'Spark generate attributes', proj)
        proj.save(proj.path)
        
        SparkConfigurator::add_script_to_project_targets(run_script_pods, 'Spark generate attributes', installer.project)
        
        # create directories 9shared sources
        path_binary = Dir.getwd + '/binaries'
        if !File.directory?(path_binary)
            FileUtils.mkdir(path_binary)
        end
    end
    
    def self.create_generated_attributes_for_path(path)
        generated_attributes_file_path = "#{path}/SparkGeneratedAttribute.m"
        
        if !File.exists?(generated_attributes_file_path)
            FileUtils.mkdir_p(path)
            puts "create: #{generated_attributes_file_path}"
            File.new(generated_attributes_file_path, "w+").close
        end
    end
    
    def self.add_script_to_project_targets(script, script_name, project)
        project.targets.each do |target|
            phase = installer.project.new(Xcodeproj::Project::PBXShellScriptBuildPhase)
            phase.name = script_name
            phase.shell_script = script
            target.build_phases.insert(0, phase)
        end
    end
end