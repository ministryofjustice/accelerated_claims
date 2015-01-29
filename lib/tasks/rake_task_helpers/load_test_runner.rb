require 'fileutils'

class LoadTestRunner

  def initialize(environment, load_profile)
    puts "initializing runner with load profile '#{load_profile}' in #{environment} environment."
    @env               = environment
    @load_profile      = load_profile
    @project_dir       = Dir.pwd
    @tsung_wrapper_dir = File.expand_path(File.join(@project_dir, '..', 'tsung-wrapper'))
    @log_dir           = "#{@project_dir}/tmp/load/log"
    @xml_dir           = "#{@project_dir}/tmp/load/xml"
    @xml_file_name     = "#{environment}_#{load_profile}.xml"
    check_dependencies
    create_xml_file
    run_tsung
    analyse_results
  end

  private

  def check_dependencies
    check_tsung_wrapper_present
    check_tsung_executable_present
  end

  def check_tsung_wrapper_present
    unless File.exist?(@tsung_wrapper_dir)
      raise "Cannot file tsung-wrapper project - expected to find it in #{@tsung_wrapper_dir}: check out project from git into this directory"
    end
    config_subdirs = %w{ environments load_profiles matches scenarios sessions snippets}
    config_subdirs.each do | subdir |
      config_subdir = "#{@tsung_wrapper_dir}/config/project/cc/#{subdir}"
      unless File.exist?(config_subdir)
        raise "tsung-wrapper project appears to be incomplete: unable to find #{config_subdir}. Check out project from git again."
      end
    end
  end

  def check_tsung_executable_present
    executable = %x{which tsung}
    if executable.length == 0
      raise "Unable to find 'tsung' executable.  Ensure that it has been downloaded and the path is set correctly - see https://github.com/ministryofjustice/tsung-wrapper "
    end
  end

  def create_xml_file
    create_empty_tmp_dirs
    command = "ruby #{@tsung_wrapper_dir}/lib/wrap.rb -xe #{@env} -p cc -l #{@load_profile} all_scenarios > #{@xml_dir}/#{@xml_file_name}"
    puts "Writing xml file to #{@xml_dir}/#{@xml_file_name}"
    system command
  end

  def run_tsung
  end

  def analyse_results
  end

  def create_empty_tmp_dirs
    FileUtils::mkdir_p @log_dir
    FileUtils::mkdir_p @xml_dir
    FileUtils.rm Dir.glob("#{@log_dir}/*")
    FileUtils.rm Dir.glob("#{@xml_dir}/*")
  end

end
