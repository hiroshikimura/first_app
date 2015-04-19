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

# ハッシュ値計算方法
apiKey = 'zukiZH3z';
secret = 'f62yQkox' ;
epoctime = sprintf("%d", Time.now.to_i );
hashValue = Digest::SHA1.hexdigest(sprintf("%s%s", secret,epoctime));

# API call
# 出力の XML が array を宣言していないので、one じゃないとダメなんだろうなぁ。。。
slides = Slide.find(
	:one,
	:from=> '/api/2/search_slideshows',
	:params=>{
		:q=>'slideshare',	# 検索文字列
		:page=>1,			# ページ番号
		:items_per_page=>16,# １ページ中のアイテム数
		:lang=>'ja',		# 言語(ja:Japanese)
		:sort=>'relevance',	# データ並び順(relevance/mostviewed/mostdownloaded/latest)
		:upload_date=>'any',# 直近の更新期間(any/week/month/year)
		:fileformat=>'all',	# ファイルフォーマット('pdf':PDF,'ppt':PowerPoint,'odp':Open Office,'pps':PowerPoint Slideshow,'pot':PowerPoint template)
		:file_type=>'all',	# ファイルタイプ(presentations/documents/webinars/videos)
		:cc=>1,				# Creative Commonsライセンスで配布しているかどうか
		:cc_adapt=>1,		# Creative Commonsの下で変更を許可しているかどうか
		:cc_commercial=>1,	# Creative Commonsの下で商用利用を許可しているかどうか
		:api_key=>apiKey,	# api key
		:hash=>hashValue,	# ハッシュ
		:ts=>epoctime		# 現在日時(UNIX秒)
		}
	) ;

#puts slides.to_s;
pp slides;
