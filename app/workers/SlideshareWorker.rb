class SlideshareWorker < ApplicationController
	include Sidekiq::Worker
	sidekiq_options queue: :slideshare_query, retry: 5

	def perform(id)
		p 'work: id=' + id
		req = Search.find(requestid: id)
	end

	def process(req)
		apikey  = 'zukiZH3z'
		secret  = 'f62yQkox'
		epoctime= ''
		# 取得単位
		pgs     = 1
		lastPage= 2
		cnt     = 16
		total   = 100

		req.update( state: 1 )

		while lastPage > pgs do
			epoctime = sprintf("%d",Time.now.to_i)
			hashVar = Digest::SHA1.hexdigits(sprintf("%s%s", secret, epoctime))

			# この書き方、メッチャカッコワルイ
			# 検索処理
			slides = SlideSource.find(
														:one,
														:from=> '/api/2/search_slideshows', # この指定方法もカッコワルイ
														:params=>{
															:q=>req.q,          # 検索文字列
															:page=>pgs,         # ページ番号
															:items_per_page=>16,# １ページ中のアイテム数
															:lang=>req.lang,    # 言語
															:sort=>'relevance', # データ並び順
															:upload_date=>'any',# 直近の更新期間
															:fileformat=>'all', # ファイルフォーマット
															:file_type=>'all',  # ファイルタイプ
															:cc=>1,             # Creative Commons関連
															:cc_adapt=>1,       # Creative Commons関連
															:cc_commercial=>1,  # Creative Commons関連
															:api_key=>apiKey,   # api key
															:hash=>hashValue,   # ハッシュ
															:ts=>epoctime       # 現在日時(UNIX秒)
															}	
														)
			# ここで処理中にする
			req.update( state:  2 )

			# スライド情報のDBへの登録
			# データが多いので、ここはしょうがないかなー
			for s in slides.SlideShows do
				Slide.new(
								requestid:					req.requestid,  # 検索要求に対する結果なので。
								ID:									s.ID,
								Title:							s.Title, 
								Description:				s.Description,
								Status:							s.Status,
								URL:								s.URL,
								ThumbnailURL:				s.ThumbnailURL,
								ThumbnailSize:			s.ThumbnailSize,
								ThumbnailSmallURL:	s.ThumbnailSmallURL,
								Embed:							s.Embed,
								Created:						s.Created,
								Updated:						s.Updated,
								Format:							s.Format,
								DownloadURL:				s.DownloadURL,
								SlideshowType:			s.SlideshowType
							)
			end

			total = slides.Meta.TotalResult
			lastPage = ( slides.Meta.TotalResult + 15 ) / 16
			pgs = pgs + 1
		end
		req.update( state:  3 )
	end

end
