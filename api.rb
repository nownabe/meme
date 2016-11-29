# frozen_string_literal: true

require "json"
require "sinatra"
require "somemoji"
require "qiita/markdown"

class Renderer
  def initialize(provider)
    @provider = provider
    @processor =
      Qiita::Markdown::Processor.new(
        hostname: hostname,
        emoji_url_generator: emoji_url_generator,
        emoji_names: emoji_names
      )
  end

  def render(markdown)
    @processor.call(markdown)[:output].to_s
  end

  private

  def emoji_collection
    @emoji_collection ||=
      case @provider
      when "apple"
        Somemoji.apple_emoji_collection
      when "emoji_one"
        Somemoji.emoji_one_emoji_collection
      when "noto"
        Somemoji.noto_emoji_collection
      when "twemoji"
        Somemoji.twemoji_emoji_collection
      end
  end

  def emoji_names
    Somemoji.send(:emoji_definitions).map { |ed| ed["code"] }
  end

  def emoji_path(code)
    "/images/emoji/#{@provider}/#{emoji_collection.find_by_code(code).base_path}.png"
  end

  def emoji_url_generator
    proc { |code| emoji_path(code) }
  end

  def hostname
    ENV["MEME_HOSTNAME"] || "localhost:4567"
  end
end

set :port, ENV["PORT"] || 4567

get "/" do
  redirect to("/index.html")
end

post "/markdown/:provider" do
  content_type :json
  {
    provider: params[:provider],
    rendered_html: Renderer.new(params[:provider]).render(params[:markdown])
  }.to_json
end
