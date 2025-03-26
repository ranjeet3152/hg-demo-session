class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @article.update(state: "old") # Update status to "old"

    respond_to do |format|
      format.html # This will render `show.html.erb`
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("article_status_#{@article.id}", 
          partial: "articles/status", 
          locals: { article: @article }
        )
      end
    end
  end



  def create
    @article = Article.new(article_params)
    @articles = Article.all
    if @article.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("articles", partial: "articles/article", locals: { article: @article }),
            turbo_stream.replace("count_article", @articles.count + 1)
          ]
        end
        format.html { redirect_to articles_path, notice: "Article created successfully!" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    if @article.update(article_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@article) }
        format.html { redirect_to articles_path, notice: "Article updated!" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@article) }
      format.html { redirect_to articles_path, notice: "Article deleted!" }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
