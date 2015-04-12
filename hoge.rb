#!/usr/bin/ruby

require 'rubygems'
require 'active_support'
require 'active_resource'
require 'date'
require 'digest/sha1'

class Slide < ActiveResource::Base
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

	self.site='https://www.slideshare.net';
	#self.prefix='/api/2/search_slideshows';
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

t = Time.now;
et = sprintf("%d", t.to_i );
apiKey = 'zukiZH3z';
hc = Digest::SHA1.hexdigest(sprintf("%s%s", apiKey,et));

puts sprintf("EPOC TIME=%s", et);
puts sprintf("apikey=%s", apiKey);
puts sprintf("hashKey=%s", hc) ;

slides = Slide.find(
	:all,
	:from=> '/api/2/search_slideshows',
	:params=>{
		'q'=>'slideshare',
		'page'=>1,
		'items_per_page'=>16,
		'lang'=>'ja',
		'sort'=>'relevance',
		'upload_date'=>'any',
		'fileformat'=>'all',
		'file_type'=>'all',
		'cc'=>1,
		'cc_adapt'=>1,
		'cc_commercial'=>1,
#		'detailed'=>1,
#		'get_transcript'=>1,
		'api_key'=>apiKey,
		'hash'=>hc,
		'ts'=>et
	}) ;

puts slides;
