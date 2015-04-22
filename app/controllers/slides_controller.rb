class SlidesController < ApplicationController
  def index
		@slides = mySlideList(1)
  end

  def show
		@slides = mySlideList(1)
  end

	def edit
		# 詳細表示アクション
		# exec(1, params[:req][:ID], params[:req][:requestid] )
		@slide = mySlide(1, params[:ID], params[:requestid] )
		p @slide
	end

	def	update
		# 変更アクション
		@slides = mySlideList(1)
		redirect_to :action => 'index', :notice => '更新しました'
	end

	def delete
		# 削除アクション
		#mySlideDelete(1, params[:ID], params[:requestid] )
		redirect_to :action => 'index', :notice => '削除しました'
	end

	protected

	def mySlideList(userID)
		list = Slide.where(userid: userID);
		list
	end

	def mySlide(userID,slideID,requestID)
		# いったん全部
		list = Slide.where(userid: userID,ID: slideID, requestid: requestID);
		list
	end

	def mySlideDelete(userID,slideID,requestID)
		Slide.where(userid: userid,ID: slideID, requestid: requestID).delete;
	end

end
