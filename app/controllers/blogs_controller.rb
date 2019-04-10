class BlogsController < ApplicationController
    def index
        @blogs = Blog.all
    end

    def new
    end

    def create
        @blog = Blog.create(blog_params)
    end

    def edit
        @blog = Blog.find(params[:id])
    end

    def destroy
        @blog = Blog.find(params[:id])
    end

    def update

    end

    private

    def blog_params

    end

end
