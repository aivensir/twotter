class HomeController < ApplicationController

  def index
    a = Post.new
    a.save!
    @id = a.id
  end

  def add_comment #post
    post_id = json_input['id']
    a = Post.where(:id => post_id).last
    comment = a.comments.create(text: json_input['text'])
    comment.save!
    return "comment.id, comment.text, comment.likes, comment.created_at, comment.post_id"
  end

  def return_post

  end

  def create_new_post #post
    a = Post.new
    a.text = puts "_#{params[:text]}"
    # a.save!
    render :json => {:id =>"#{params}"}
  end

  def edit_post

  end

  def remove_post

  end

  def return_comments

  end

  def create_new_comment

  end

  def edit_comment

  end

  def remove_comment

  end

end
