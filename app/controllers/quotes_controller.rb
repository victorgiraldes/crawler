class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :update, :destroy]

  # GET /quotes
  def index
    require 'open-uri'
    parse_page = Nokogiri::HTML(open('http://quotes.toscrape.com/'))
    quotes = parse_page.css('div.quote').map { |quote|
      {quote: quote.css('span.text').text,
      author: quote.css('span small.author').text,
      author_about: quote.css('span a').text,
      tags: quote.css('div.tags a.tag').map { |tag| tag.text }
      }
    }
    render json: quotes
  end

  # GET /quotes/1
  def show
    tag
    if
    render json: @quote
  end

  # POST /quotes
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      render json: @quote, status: :created, location: @quote
    else
      render json: @quote.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quotes/1
  def update
    if @quote.update(quote_params)
      render json: @quote
    else
      render json: @quote.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/1
  def destroy
    @quote.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quote_params
      params.require(:quote).permit(:quote, :author, :author_about, :tags)
    end
end
