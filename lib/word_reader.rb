class WordReader
  def read_from_args
    ARGV[0]
  end

  def read_from_file(file_name)
    begin
      lines = File.readlines(file_name, encoding: 'UTF-8')
    rescue SystemCallError
      abort 'Файл со словами не найден!'
    end

    lines.sample.chomp
  end
end
