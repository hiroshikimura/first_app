# coding: utf-8

# 検索要求を管理するcontroller
class SearchController < ApplicationController

  #include models::Search
  #include Search
  #include Sidekiq:Worker
  #sidekiq_options queue: :slideshare_query
  before_action :authenticate_user!

	def index
    @req = Search.where(users_id: current_user.id);
	end

	def new
		@req = Search.new
	end

	def create
		# いったん、ユーザーIDは固定で。
		exec(current_user.id, params[:req][:q], params[:req][:lang] )
    @req = Search.where(users_id: current_user.id);
	end

	def exec(userid,q,lang)
		# 検索依頼
		r = Search.new
		r.users_id = userid
		r.q = q
		r.lang = lang
		r.state = 0
		r.request_date = Time.now
		r.save

		@req = r

		SlideshareWorker.perform_async( r.requestid )
		
	end

  def show
		# 認証系が機能していないので
    @req = Search.where(userid: current_user.id);
  end

#  def stat(uid,reqid)
#    # 要求状態確認
#    req = Search.where(requestid: reqid,userid: uid)
#    req
#  end

end
