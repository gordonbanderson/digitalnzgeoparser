module ArchiveSearchesHelper
  
  #Find the host of a given URL
  def hostof(url)
    result = 'NOT FOUND'
    if !url.blank?
      stripped = url.gsub("http://", '')
      parts = stripped.split('/')
      result = parts[0]
    end
    result
  end
end
