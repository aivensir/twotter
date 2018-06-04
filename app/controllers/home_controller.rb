class HomeController < ApplicationController

  def index
  end

  def add_comment #post
    post_id = json_input['id']
    a = Post.where(:id => post_id).last
    comment = a.comments.create(text: json_input['text'])
    comment.save!
    return "comment.id, comment.text, comment.likes, comment.created_at, comment.post_id"
  end

  def return_posts
    a = Post.all.order(:created_at).reverse!
    a.each do |post|


    end
    render :json => {"text" => "hello"}
  end

  def create_new_post #post
    a = Post.new
    a.text = params[:text]
    a.likes = 0
    a.save!

    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at}
    render :json => hh
    #render :json => {:id =>"#{params}"}
  end

  def edit_post
    a = Post.where(:id => params[:post_id]).last
    a.text = params[:text]

    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at}
    fail = {"id" => "Null"}
    a.save ? render :json => hh : render :json => fail
  end

  def remove_post
    a = Post.where(:id => params[:post_id]).last
    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at}
    fail = {"id" => "Null"}
    a.destroy ? render :json => hh : render :json => fail
  end

  def return_comments

  end

  def create_new_comment
    a = Post.where(:id => params[:post_id]).last
    comment = a.comments.create(text: params[:text]).first
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at, "comment_id" => comment.id}
    render :json => hh
  end

  def edit_comment
    a = Comment.where(:id => params[:comment_id]).first
    a.text = params[:text]
    hh = {"post_id" => a.post_id, "text" => a.text, "likes" => a.likes, "date" => a.created_at, "comment_id" => a.id }
    fail = {"id" => "Null"}

    a.save ? render :json => hh : render :json => fail
  end

  def remove_comment
    a = Comment.where(:id => params[:comment_id]).first
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at, "comment_id" => comment.id}
    fail = {"id" => "Null"}
    a.destroy ? render :json => hh : render :json => fail

  end

end
