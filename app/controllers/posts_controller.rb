class PostsController < ApplicationController


  def return_posts
    a = Post.all.order(:created_at).reverse
    a.each do |post|


    end
    render :json => {"text" => "hello_posts"}
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
    a.save ? (render :json => hh) : (render :json => fail)
  end

  def remove_post
    a = Post.where(:id => params[:post_id]).last
    hh = {"id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at}
    fail = {"id" => "Null"}
    a.destroy ? (render :json => hh) : (render :json => fail)
  end

end
