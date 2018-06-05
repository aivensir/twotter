class PostsController < ApplicationController


  def return_posts
    a = Post.all.order(created_at: :desc)
    if a.blank?
      render :json => {"id" => "Null"}
      return                           
    end
    hh = {}
    i = 0
    a.each do |post|
      j = 0
      i += 1
      post_info_hash = {"id" => post.id, "text" => post.text, "likes" => post.likes, "date" => post.created_at.to_s}
      comments_hash = {}
      post.comments.each do |comment|
        j += 1
        comments_hash = comments_hash.merge({j => {"id" => comment.id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s}})
      end
      hh = hh.merge({i => post_info_hash.merge({"comments" => comments_hash})})
    end
    render :json => hh
  end

  def return_post
    post = Post.where(:id => params[:post_id]).first
    if post.blank?
      render :json => {"id" => "Null"}
      return
    end

    j = 0
    comments_hash = {}
    post.comments.each do |comment|
      j += 1
      comments_hash = comments_hash.merge({j => {"id" => comment.id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s}})
    end

    render :json => {"id" => post.id, "text" => post.text, "likes" => post.likes, "date" => post.created_at.to_s}.merge({"comments" => comments_hash})
   end

  def create_new_post #post
    a = Post.new

    a.text = params['text']
    a.likes = 0
    a.save!

    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    render :json => hh
    #render :json => {:id =>"#{params}"}
  end

  def edit_post
    a = Post.where(:id => params[:post_id]).last
    a.text = params[:text]

    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"id" => "Null"}
    a.save ? (render :json => hh) : (render :json => fail)
  end

  def remove_post
    a = Post.where(:id => params[:post_id]).last
    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"id" => "Null"}
    a.destroy ? (render :json => hh) : (render :json => fail)
  end

end
