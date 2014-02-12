class BaseClass
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  def attributes
    instance_values
  end

  def date_input_format
    "%Y-%m-%d"
  end

  def split_postcode
    if postcode.nil?
      p1, p2 = '', ''
    else
      pcode = UKPostcode.new(postcode)
      p1 = pcode.outcode
      p2 = pcode.incode
    end
    return p1,p2
  end

  def initialize( attrs = {} )
    if !attrs.nil? then
      dattrs = {}
      attrs.each do |n, v|
        if n.match( /^(.+)\(.+\)$/ ) then
          an = Regexp.last_match[1]
          dattrs[an] = [] if dattrs[an].nil?
          dattrs[an] << { :n => n, :v => v }
        else
          send( "#{n}=", v)          
        end          
      end
      dattrs.each do |k, v|
        vs = v.sort_by{|hv| hv[:n] }.collect{|hv| hv[:v] }
        p1 = vs[0]
        p2 = ( vs[1].size() > 0 ? ( vs[1].size() == 1 ? "0#{vs[1]}" : vs[1] ) : "01" )
        p3 = ( vs[2].size() > 0 ? ( vs[2].size() == 1 ? "0#{vs[2]}" : vs[2] ) : "01" )
        dv = [ p1, p2, p3 ].join( "-" )
        begin send( "#{k}=", Date.parse( dv ) ); rescue; end
      end
    end       
  end
end
