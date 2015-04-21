class SlideshareWorker < ApplicationController
	include Sidekiq::Worker
	sidekiq_options queue: :slideshare_query, retry: 5

	def perform(id)
		p 'work: id=' + sprintf('%d',id)
		req = Search.find(id)
		process req
	end

	def process(req)
		apiKey  = 'zukiZH3z'
		secret  = 'f62yQkox'
		epoctime= ''
		# 取得単位
		pgs     = 1
		lastPage= 2
		cnt     = 16
		total   = 100
		whole_cnt = 0

		p 'begin 001'

		req.update( state: 1 )

		while lastPage > pgs do
			epoctime = sprintf("%d",Time.now.to_i)
			hashVar = Digest::SHA1.hexdigest(sprintf("%s%s", secret, epoctime))

			# この書き方、メッチャカッコワルイ
			# 検索処理
			slides = SlideSource.find(
														:one,
														:from=> '/api/2/search_slideshows', # この指定方法もカッコワルイ
														:params=>{
															:q=>req.q,						# 検索文字列
															:page=>pgs,						# ページ番号
															:items_per_page=>16,	# １ページ中のアイテム数
															:lang=>req.lang,			# 言語
															:sort=>'relevance',		# データ並び順
															:upload_date=>'any',	# 直近の更新期間
															:fileformat=>'all',		# ファイルフォーマット
															:file_type=>'all',		# ファイルタイプ
															:cc=>1,								# Creative Commons関連
															:cc_adapt=>1,					# Creative Commons関連
															:cc_commercial=>1,		# Creative Commons関連
															:api_key=>apiKey,			# api key
															:hash=>hashVar,				# ハッシュ
															:ts=>epoctime      	 # 現在日時(UNIX秒)
															}	
														)
			p slides.Meta

			# 件数の初期化、毎回やるのカッコワルイ・・・
			total = slides.Meta.TotalResults.to_i
			lastPage = ( total + 15 ) / 16
			pgs = pgs + 1

			# ここで処理中にする
			req.update( state:  2, total_count: slides.Meta.TotalResults.to_i, last_update_date: Time.now )

			# スライド情報のDBへの登録
			# データが多いので、ここはしょうがないかなー
			for s in slides.Slideshow do
				#p '----------'
				#p s ;

				whole_cnt = whole_cnt + 1

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
								DownloadURL:				if s.Download == '1' then s.DownloadUrl else '' end,
								SlideshowType:			s.SlideshowType
							).save

				req.update( state:  2, process_count: whole_cnt , last_update_date: Time.now )
			end

		end
		req.update( state:  3 )
	end

end
