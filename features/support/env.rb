require 'fileutils'
require 'open3'


module CommandLineHelpers
  Invocation = Struct.new :stdout, :stderr, :status do
    def exitstatus
      status.exitstatus
    end
  end

  extend self

  def write_file(filename, body)
    in_proving_grounds do
      FileUtils.mkdir_p File.dirname filename
      File.open(filename, 'w') { |file| file.write body }
    end
  end

  def execute(command, stdin_data=nil)
    stdin_data ||= ''
    in_proving_grounds do
      bin_in_path = {'PATH' => "#{bin_dir}:#{ENV['PATH']}"}
      Invocation.new *Open3.capture3(bin_in_path, command, stdin_data: stdin_data)
    end
  end

  def in_proving_grounds(&block)
    Dir.chdir proving_grounds_dir, &block
  end

  def proving_grounds_dir
    File.join root_dir, 'proving_grounds'
  end

  def root_dir
    @root_dir ||= begin
      dir = File.expand_path Dir.pwd
      dir = File.dirname dir until Dir["#{dir}/*"].map { |fn| File.basename fn }.include?('lib')
      dir
    end
  end

  def make_proving_grounds
    FileUtils.mkdir_p proving_grounds_dir
  end

  def bin_dir
    File.join root_dir, "bin"
  end

  def path_to(filename)
    in_proving_grounds { File.join proving_grounds_dir, filename }
  end
end

CommandLineHelpers.make_proving_grounds

module GeneralHelpers
  def eval_curlies(string)
    string.gsub(/{{(.*?)}}/) { eval $1 }
  end
end

World GeneralHelpers
