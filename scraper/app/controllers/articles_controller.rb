class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
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
