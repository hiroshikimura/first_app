# coding: utf-8

require 'rubygems'
require 'active_support'
require 'active_resource'
require 'date'
require 'digest/sha1'
require 'pp'
require 'ap'
require 'ddp'

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
#		include ActiveResource::Formats::XmlFormat

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
#	self.prefix = '/api/2/search_slideshows?q=:q&page=1&items_per_page=16&lang=ja&
#	sort=relevance&upload_date=any&fileformat=all&file_type=all&cc=1&cc_adapt=1&cc_commercial=1&api_key=:api_key&hash=:hash&ts=:ts';
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

apiKey = 'zukiZH3z';
secret = 'f62yQkox' ;

#t = Time.now;
#et = 1428950922;
et = sprintf("%d", Time.now.to_i );
#hc = '9c943256e64630ce134e653948363252bfd29307'
hc = Digest::SHA1.hexdigest(sprintf("%s%d", secret,et));


puts sprintf("EPOC TIME=%s", et);
puts sprintf("apikey=%s", apiKey);
puts sprintf("hashKey    =%s", hc) ;
puts sprintf("digestValue=%s",Digest::SHA1.hexdigest(sprintf("%s%d", secret, et)));

#:from=> '/api/2/search_slideshows',
#:from=> url,
#self.prefix = '/api/2/search_slideshows?q=:q&page=1&items_per_page=16&
#lang=ja&sort=relevance&upload_date=any&fileformat=all&file_type=all&cc=1&cc_adapt=1&cc_commercial=1&api_key=:api_key&hash=:hash&ts=:ts';

url = sprintf('/api/2/search_slideshows?q=%s&page=1&items_per_page=16&lang=**&sort=relevance&upload_date=any&fileformat=all&file_type=all&cc=1&cc_adapt=1&cc_commercial=1&api_key=%s&hash=%s&ts=%s', 'slideshare', apiKey, hc, et );

# example
# www.slideshare.net/api/2/search_slideshows
#	?q=slideshare
#	&page=1
#	&items_per_page=16
#	&lang=**
#	&sort=relevance
#	&upload_date=any
#	&fileformat=all
#	&file_type=all
#	&cc=1
#	&cc_adapt=1
#	&cc_commercial=1
#	&api_key=zukiZH3z
#	&hash=5af7a32954823eeb575e85f03027cdfc0509addd
#	&ts=1428969358


puts url ;
slides = Slide.find(:one, :from=>url);

#slides = Slide.find(
#	:one,
#	:from=> '/api/2/search_slideshows',
#	:params=>{
#		:q=>'slideshare',
#		:page=>1,
#		:items_per_page=>16,
#		:lang=>'ja',
#		:sort=>'relevance',
#		:upload_date=>'any',
#		:fileformat=>'all',
#		:file_type=>'all',
#		:cc=>1,
#		:cc_adapt=>1,
#		:cc_commercial=>1,
#		:api_key=>apiKey,
#		:hash=>hc,
#		:ts=>et
#		}
#	) ;

#puts slides.to_s;
pp slides;
