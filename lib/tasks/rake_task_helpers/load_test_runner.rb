require 'fileutils'
require_relative './load_test_summary_analyser'

class LoadTestRunner

  def initialize(load_test_type)
    @load_test_type    = load_test_type.to_s
    @project_dir       = Rails.root
    config             = load_config
    @project           = config['project']
    @scenario          = config[@load_test_type]['scenario']
    @env               = config[@load_test_type]['environment']
    @load_profile      = config[@load_test_type]['load_profile']
    @tsung_wrapper_dir = File.expand_path(File.join(@project_dir, '..', 'tsung-wrapper'))
    @log_dir           = "#{@project_dir}/tmp/load/log"
    @xml_dir           = "#{@project_dir}/tmp/load/xml"
    @xml_file_name     = "#{@xml_dir}/load_test.xml"
  end

  def run
    check_dependencies
    create_xml_file
    log_subdir = run_tsung
    analyse_results(log_subdir)
  end

  private

  def load_config
    config_file = "#{Rails.root}/config/load_test.yml"
    raise "Unable to find config/load_test.yml" unless File.exist?(config_file)
    YAML.load_file(config_file)
  end

  def check_dependencies
    print "Cheking dependencies...... "
    check_tsung_wrapper_present
    check_tsung_executable_present
    puts "OK"
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
    print "Creating XML file #{@xml_file_name} ...... "
    create_empty_tmp_dirs
    command = "ruby #{@tsung_wrapper_dir}/lib/wrap.rb -xe #{@env} -p cc -l #{@load_profile} all_scenarios > #{@xml_file_name}"
    system command
    puts " Done"
  end

  def run_tsung
    command = "tsung -f #{@xml_file_name} -l #{@log_dir} start"
    print "Starting Tsung......"
    pipe = IO.popen(command)
    output = pipe.read
    pipe.close
    raise "Unable to start Tsung: #{output}" unless output =~ /^Starting Tsung/
    raise "Error Running Tsung: #{output}" unless output =~ /"Log directory is: (.*)"/
    log_subdir = $1
    puts "Done"
    log_subdir
  end

  def analyse_results(log_subdir)
    print "Extracting summarised results..... "
    command = "ruby #{@tsung_wrapper_dir}/lib/dfa -f #{log_subdir}/tsung.dump -s 10"
    system(command)
    puts 'Done'
    ltsa = LoadTestSummaryAnalyser.new("#{log_subdir}/tsung.dump.summary.csv")
    result = ltsa.summarize(@load_test_type)
    pp result
  end

  def create_empty_tmp_dirs
    FileUtils::mkdir_p @log_dir
    FileUtils::mkdir_p @xml_dir
    log_subdirs = Dir.glob("#{@log_dir}/*")
    log_subdirs.each { |d| FileUtils::remove_entry_secure(d) }
    FileUtils::rm Dir.glob("#{@xml_dir}/*")
  end

end
