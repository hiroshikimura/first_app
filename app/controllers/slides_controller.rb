class SlidesController < ApplicationController
  def index
		@slides = mySlide(0)
  end

  def show
		@slides = mySlide(0)
  end

	def item
		# 詳細表示アクション
		# exec(1, params[:req][:q], params[:req][:lang] )
	end

	def	modify
		# 変更アクション
	end

	def delete
		# 削除アクション
	end

	private
	def mySlide(userid)
		# いったん全部
		Slides.all
	end

end
