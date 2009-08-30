module ArchiveSearchesHelper
  
  #Find the host of a given URL
  def hostof(url)
    stripped = url.gsub("http://", '')
    parts = stripped.split('/')
    parts[0]
  end
end
