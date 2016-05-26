require 'open-uri'
require 'net/http'
require 'kconv'
require 'webrick/httputils'

class NokogiriController < ApplicationController
	
  	def search
  		#unless session[:rate].nil?
  			#汇率 API - json  汇率=rate['showapi_res_body']['money']
  			response=Net::HTTP.get_response(URI('http://route.showapi.com/105-31?showapi_appid=18266&showapi_sign=0142ab2f164a43999ddd4fff43ebd063&fromCode=JPY&toCode=CNY&money=100&'))
  		     #@rate = JSON.parse(response.body)
  			#session[:rate] = JSON.parse(response.body)
  			@rate = JSON.parse(response.body)['showapi_res_body']['money']
  		#end
  		#@rate = session[:rate]['showapi_res_body']['money']
  	end

  	def search_result
  	
	  	
		@key_word = params[:search]

		#unless session[:rate].nil?
			#汇率 API - json  汇率=rate['showapi_res_body']['money']
			response=Net::HTTP.get_response(URI('http://route.showapi.com/105-31?showapi_appid=18266&showapi_sign=0142ab2f164a43999ddd4fff43ebd063&fromCode=JPY&toCode=CNY&money=100&'))
		     #@rate = JSON.parse(response.body)
			#session[:rate] = JSON.parse(response.body)
			@rate = JSON.parse(response.body)['showapi_res_body']['money']
		#end
		#@rate = session[:rate]['showapi_res_body']['money']

		@kproducts = Hash.new
		@aproducts = Hash.new
		@rproducts = Hash.new
		


		kakaku_url = "http://kakaku.com/search_results/#{CGI.escape @key_word.encode(Encoding::SJIS)}"
   

		doc = Nokogiri::HTML(open(kakaku_url))
		doc.css(".item").each_with_index do |item,index|
			@kproducts[index] = {
								:title => (item.at_css(".itemnameN").text if item.at_css(".itemnameN")),					
								:price => ((item.at_css(".yen").text.gsub(/\D/, '').to_i*@rate.to_f/100).to_i if item.at_css(".yen")),
								:category => (item.at_css(".cate").text if item.at_css(".cate")),
								:score => (item.at_css(".first+ li .numOr").text if item.at_css(".first+ li .numOr")),
								:introduction => (item.at_css(".itemSpec").text if item.at_css(".itemSpec")),
								:url => (item.at_css(".noscriptLink")[:href] if item.at_css(".noscriptLink")),
								:img_url => (item.at_css(".noscriptLink img")[:src] if item.at_css(".noscriptLink img")),
							   }
			#删除0分产品
			#@kproducts.delete(index) if @kproducts[index][:score].nil? 
			
			@kproducts[index][:score] = 0 if @kproducts[index][:score].nil? 
		end
		

		amazon_url = "http://www.amazon.co.jp/s/field-keywords=#{CGI.escape @key_word}"
		doc = Nokogiri::HTML(open(amazon_url))
		doc.css(".s-item-container").each_with_index do |item,index|
			@aproducts[index] = {
								:title => (item.at_css("a h2").text if item.at_css("a h2")),					
								:price => ((item.at_css(".s-price").text.gsub(/\D/, '').to_f.*@rate.to_f/100).to_i if item.at_css(".s-price")),
								:category => (item.at_css(".a-spacing-mini~ .a-spacing-mini+ .a-spacing-mini .a-text-bold").text if item.at_css(".a-spacing-mini~ .a-spacing-mini+ .a-spacing-mini .a-text-bold")),
								:url => (item.at_css("a")[:href] if item.at_css("a")),
								:img_url => (item.at_css("a img")[:src] if item.at_css("a img"))
							   }


		end
		
		raketen_url = "http://search.rakuten.co.jp/search/mall/#{CGI.escape @key_word}"
		doc = Nokogiri::HTML(open(raketen_url))
		doc.css(".rsrSResultSect").each_with_index do |item,index|
			@rproducts[index] = {
								:title => (item.at_css("h2").text if item.at_css("h2")),					
								:price => ((item.at_css("p a").text.gsub(/\D/, '').to_f.*@rate.to_f/100).to_i if item.at_css("p a")),
								:store => (item.at_css("style+ .clfx h2 , .txtIconShopName a").text if item.at_css("style+ .clfx h2 , .txtIconShopName a")),	
								:introduction => (item.at_css(".copyTxt").text if item.at_css(".copyTxt").text if item.at_css(".copyTxt").text if item.at_css(".copyTxt")),
								:url => (item.at_css("h2 a")[:href] if item.at_css("h2 a")),
								:img_url => (item.at_css("a img")[:src].chomp!("?_ex=112x112") if item.at_css("a img"))
							   }
			

		end

	
  	end
end
