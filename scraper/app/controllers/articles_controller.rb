class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def index
        # Get the largest ID in the database
        articles = Article.last
        @headlines = JSON.parse(articles.text)
        @urls = JSON.parse(articles.url)
    end

    def create
        #render plain: params[:headlines].inspect # hash with key plain
        puts params[:article].inspect
        @article = Article.new(article_params)

        @article.save
        render plain: "OK"
    end

    private 
        def article_params
            params.require(:article).permit(:title, :text, :url)
        end
end
