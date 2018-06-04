class CommentsController < ApplicationController
  def return_comments
    render :json => {"text" => "hello_comments"}
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
