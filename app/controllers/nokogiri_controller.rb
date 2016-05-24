require 'open-uri'
require 'net/http'

class NokogiriController < ApplicationController
	
  	def search
  	end

  	def search_result
  	
	  	
		@key_word = params[:search]

		unless session[:rate].nil?
			#汇率 API - json  汇率=rate['showapi_res_body']['money']
			response=Net::HTTP.get_response(URI('http://route.showapi.com/105-31?showapi_appid=18266&showapi_sign=0142ab2f164a43999ddd4fff43ebd063&fromCode=JPY&toCode=CNY&money=100&'))
		     #@rate = JSON.parse(response.body)
			session[:rate] = JSON.parse(response.body)
		end
		@rate = session[:rate]['showapi_res_body']['money']

		@products,@url,@img_url,@title,@price,@category,@score,@introduction= Hash.new

		
		kakaku_url = "http://kakaku.com/search_results/#{@key_word}/"
		doc = Nokogiri::HTML(open(kakaku_url))
		doc.css(".item").each_with_index do |item,index|

			@products[index] = {
								:title => (item.at_css(".itemnameN").text if item.at_css(".itemnameN")),					
								:price => (item.at_css(".yen").text.gsub(/\D/, '').to_f if item.at_css(".yen")),
								:category => (item.at_css(".cate").text if item.at_css(".cate")),
								:score => (item.at_css(".first+ li .numOr").text if item.at_css(".first+ li .numOr")),
								:introduction => (item.at_css(".itemSpec").text if item.at_css(".itemSpec")),
								:url => (item.at_css(".noscriptLink")[:href] if item.at_css(".noscriptLink")),
								:img_url => (item.at_css(".noscriptLink img")[:src] if item.at_css(".noscriptLink img")),

							   }


		end



	
  	end
end
