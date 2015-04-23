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
		id = params[:f][:ID];
		rid = params[:f][:requestid];
		ti = params[:f][:Title];
		ds = params[:f][:Description] ;
		Slide.where(userid: current_user.id, ID: id, requestid: rid ).update_all(Title: ti, Description: ds ) ;
		redirect_to :action => 'index', :notice => '更新しました'
	end

	def delete
		# 削除アクション
		mySlideDelete(current_user.id, params[:f][:ID], params[:f][:requestid] )
		redirect_to :action => 'index', :notice => '削除しました'
	end

	protected

	def mySlideList(userID)
		list = Slide.where(userid: userID);
		list
	end

	def mySlide(userID,slideID,requestID)
		# いったん全部
		return Slide.where(userid: userID,ID: slideID, requestid: requestID).first;
	end

	def mySlideDelete(userID,slideID,requestID)
		Slide.where(userid: userID, ID: slideID, requestid: requestID).delete_all;
	end

end
