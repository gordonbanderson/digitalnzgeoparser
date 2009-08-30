class CachedGeoSearch < ActiveRecord::Base
  belongs_to :cached_geo_search_term
  belongs_to :accuracy
  
  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  has_and_belongs_to_many :submissions
  
  def is_significant_for_geocoding?
    accuracy.id < 6 #Using google constants
  end
  
  
  def is_country?
    accuracy == Accuracy::COUNTRY
  end
 
=begin
<%= book.highlight("Jason", :field => :title, :num_excerpts => 1, :pre_tag => "<strong>", :post_tag => "</strong>") %>
<tr><td>Address</td><td><%=address%></td></tr>
<tr><td>Country</td><td><%=country%></td></tr>
<tr><td>Admin Area</td><td><%=admin_area%></td></tr>
<tr><td>Subadmin Area</td><%=subadmin_area%><td></td></tr>
<tr><td>Locality</td><td><%=locality%></td></tr>
<tr><td>Dependen Locality</td><td><%=dependent_locality%></td></tr>
<tr><td>Accuracy</td><td><%=accuracy.name%></td></tr>
=end 
  
  
  #Render a window for google maps
  def to_info_map_window(submission)
    template = ERB.new <<-EOF
  
    <table>
      <tr><td><%=submission.highlight(cached_geo_search_term.search_term, :field => :corpus, :num_of_excerpts => 10,
      :pre_tag => "<strong>", :post_tag => "</strong>"
      )%></td></tr>


	EOF
    result = template.result(binding)
	return "\n"+result.strip
  end
  
end
