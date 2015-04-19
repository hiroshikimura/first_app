class Search < ActiveRecord::Base
# パラメータ
# requestid,userid,q,lang,state,request_date,last_update_date
# ここで状態も管理
# state(0:requested,1:accepted,2:processing,3:complete,-1:abort)
# 依頼方法は
# s = Search.create(userid,q,lang);
# この後、sidekiqでのトリガー
#
# 状態の確認

end
