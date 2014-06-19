
module RakeTaskHelper

  class DevelopmentVersionFileCreator

    def initialize
      @project_root = File.expand_path(File.dirname(__FILE__) + "/../../../")
      Dir.chdir @project_root
    end
    

    def run
      status = convert_to_array(capture_output('git status'))
      commit = capture_output('git log -n1 --oneline')
      branch = get_current_branch(capture_output('git branch'))

      hash = {
        'commit' => commit,
        'current_branch' => branch,
        'status' => status
      }
      File.open("#{@project_root}/public/version.json", "w") do |fp|
        fp.puts hash.to_json
      end
    end

    private

    def capture_output(command)
      IO.popen(command) do |pipe|
        pipe.read
      end
    end



    def convert_to_array(output)
      output.split("\n")
    end

    def get_current_branch(output)
      lines = output.split("\n")
      branch = ''
      lines.each do |line|
        if line =~ /^\*\s(.*)/
          branch = $1
          break
        end
      end
      branch
    end

  end

end