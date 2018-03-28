class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def index
        # Obviously should not be hardcoded on ID
        headlines = Article.find(1)
        @headlines = JSON.parse(headlines.text)
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
            params.require(:article).permit(:title, :text)
        end
end
