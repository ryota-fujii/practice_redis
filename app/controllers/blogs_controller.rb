class BlogsController < ApplicationController
    def index
        @blogs = Blog.all
        ids = REDIS.zrevrange "blogs", 0, 2
        @top_blogs = Blog.where(id: ids)
        # @blogs.each do |blog|
        #     @blog_previews[@blog.id] = REDIS.get "blogs/#{blog.id}"
        # end
        # @blog_previews.sort_by{|k,v | v}

    end

    def show
        @blog = Blog.find(params[:id])

        REDIS.zincrby "blogs", 1, "#{@blog.id}"
        ids = REDIS.zrevrange "blogs", 0, 2
        @top_blogs = Blog.where(id: ids)

        blog = @blog
        if blog.access == nil
            blog.access = 0
        end
        blog.access = blog.access + 1
        blog.save
        
    end

    def new
        @blog = Blog.new
    end

    def create
        @blog = Blog.create(blog_params)
    end

    def edit
        @blog = Blog.find(params[:id])
    end

    def destroy 
        blog = Blog.find(params[:id])   
        if blog.user_id == current_user.id
            blog.destroy
        end
        redirect_to root_path    
    end

    def update
        blog = Blog.find(params[:id])
        if blog.user_id == current_user.id
            blog.update(blog_params)
        end
        redirect_to root_path
    end

    private

    def blog_params
        params.require(:blog).permit(:title, :text).merge(user_id: current_user.id)
    end

end
