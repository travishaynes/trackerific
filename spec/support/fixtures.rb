module Fixtures
  
  FIXTURES_PATH = "spec/fixtures/"
  
  def load_fixture(name, ext = :xml)
    
    file_name = File.join(FIXTURES_PATH, "#{name.to_s}.#{ext.to_s}")
    f = File.open(file_name, 'r')
    data = "";
    f.lines.each { |line| data += line }
    f.close
    return data
    
  end
  
end
