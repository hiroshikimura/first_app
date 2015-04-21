class SlideSource < ActiveResource::Base
	class Connection < ActiveResource::Connection
		private
		def http()
		 	http=super;
			http.set_debug_output($stderr);
			http
		end
	end
	class Format
		def extension()
			'';
		end
		def mime_type()
			'text/xml';
		end
		def encode(hash,options={})
			hash.to_xml(options);
		end
		def decode(xml)
			data = Hash.from_xml(xml);
			data.is_a?(Hash) && data.keys.size == 1 ? data.values.first : data ;
		end
	end

	self.site   = 'https://www.slideshare.net';
#	self.prefix = '/api/2/search_slideshows';
	self.format = Format.new;

	class << self
		def connection(refresh=false)
			if defined?(@connection)
				@connection          = Connection.new(site,format) if refresh || @connection.nil?
				@connection.user     = user if user;
				@connection.password = user if password;
				@connection.timeout  = timeout if timeout ;
				@connection
			else
				superclass.connection;
			end
		end
	end
end
