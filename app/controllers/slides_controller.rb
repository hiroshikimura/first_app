class SlidesController < ApplicationController
	before_action :authenticate_user!

  def index
		@slides = mySlideList(current_user.id)
  end

  def show
		@slides = mySlideList(current_user.id)
  end

	def edit
		# 詳細表示アクション
		# exec(1, params[:req][:ID], params[:req][:requestid] )
		@slide = mySlide(current_user.id, params[:ID], params[:requestid] )
		p @slide
	end

	def	update
		# 変更アクション
		@slides = s = mySlideList(current_user.id)
		s.Description = params[:Description] ;
		s.Title = params[:Title] ;
		s.save
		redirect_to :action => 'index', :notice => '更新しました'
	end

	def delete
		# 削除アクション
		mySlideDelete(current_user.id, params[:ID], params[:requestid] )
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
