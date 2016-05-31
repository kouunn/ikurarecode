require 'open-uri'
require 'net/http'


class NokogiriController < ApplicationController
	#include 'nokogiri_helper.rb'
  	def search
    end

  	def search_result


    		@key_word = params[:search]

            key_word = Keyword.find_by_name(@key_word)

            if key_word.nil?
                  if signed_in?
                      Keyword.new(:name => @key_word,:user_id => current_user.id).save
                  else
                      Keyword.new(:name => @key_word).save
                  end    

              else
                  key_word.count =0 if key_word.count.nil?
                  key_word.count+=1
                  key_word.user_id = current_user.id if signed_in?
                  key_word.save
                  
              end


    		@kproducts = Hash.new
    		@aproducts = Hash.new
    		@rproducts = Hash.new
    		


    		kakaku_url = URI.escape("http://kakaku.com/search_results/#{@key_word.encode(Encoding::SJIS)}")
       

    		doc = Nokogiri::HTML(open(kakaku_url))
    		doc.css(".item").each_with_index do |item,index|
    			@kproducts[index] = {
    								:title => (item.at_css(".itemnameN").text if item.at_css(".itemnameN")),					
    								:price => ((item.at_css(".yen").text.gsub(/\D/, '').to_i*$rate.to_f/100).to_i if item.at_css(".yen")),
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


    		amazon_url = URI.escape("http://www.amazon.co.jp/s/field-key_words=#{@key_word}")
    		doc = Nokogiri::HTML(open(amazon_url))
    		doc.css(".s-item-container").each_with_index do |item,index|
    			@aproducts[index] = {
    								:title => (item.at_css("a h2").text if item.at_css("a h2")),					
    								:price => ((item.at_css(".s-price").text.gsub(/\D/, '').to_f.*$rate.to_f/100).to_i if item.at_css(".s-price")),
    								:category => (item.at_css(".a-spacing-mini~ .a-spacing-mini+ .a-spacing-mini .a-text-bold").text if item.at_css(".a-spacing-mini~ .a-spacing-mini+ .a-spacing-mini .a-text-bold")),
    								:url => (item.at_css("a")[:href] if item.at_css("a")),
    								:img_url => (item.at_css("a img")[:src] if item.at_css("a img"))
    							   }


    		end
    		
    		raketen_url = URI.escape("http://search.rakuten.co.jp/search/mall/#{@key_word}")
    		doc = Nokogiri::HTML(open(raketen_url))
    		doc.css(".rsrSResultSect").each_with_index do |item,index|
    			@rproducts[index] = {
    								:title => (item.at_css("h2").text if item.at_css("h2")),					
    								:price => ((item.at_css("p a").text.gsub(/\D/, '').to_f.*$rate.to_f/100).to_i if item.at_css("p a")),
    								:store => (item.at_css("style+ .clfx h2 , .txtIconShopName a").text if item.at_css("style+ .clfx h2 , .txtIconShopName a")),	
    								:introduction => (item.at_css(".copyTxt").text if item.at_css(".copyTxt").text if item.at_css(".copyTxt").text if item.at_css(".copyTxt")),
    								:url => (item.at_css("h2 a")[:href] if item.at_css("h2 a")),
    								:img_url => (item.at_css("a img")[:src].chomp!("?_ex=112x112") if item.at_css("a img"))
    							   }
    			

    		end
  	end



end
