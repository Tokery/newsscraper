class ArticlesController < ApplicationController
    def create
        render plain: params[:headlines].inspect # hash with key plain
    end
end
