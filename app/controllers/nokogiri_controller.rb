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

        #搜索关键字转日文
        

        
         @key_word = zh2jp(@key_word) unless @key_word.match(/\p{Katakana}|\p{Hiragana}/)

         @key_word_a = @key_word.gsub(/\d*[a-zA-Z]\d*/,'').gsub(/\の+/,'')
         @key_word_b = @key_word.gsub(/\p{Katakana}|\p{Hiragana}|[ー－]|\p{Han}/,'')




    		@kproducts = Hash.new
    		@aproducts = Hash.new
    		@rproducts = Hash.new
    		

        #kakaku_url = URI.escape("http://kakaku.com/search_results/#{@key_word.encode(Encoding::SJIS)}")
    		kakaku_url = URI.escape("http://kakaku.com/search_results/#{@key_word_a.encode(Encoding::SJIS)}+#{@key_word_b.encode(Encoding::SJIS)}")
       

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
          @kproducts[index][:score] = 0 if @kproducts[index][:score].nil?
    			@kproducts.delete(index) if @kproducts[index][:img_url]=='http://img.kakaku.com/images/category/noImage_120x120.gif'

          #@kproducts.delete(index) if @kproducts[index][:score]==0
    			
    		end


    		#amazon_url = URI.escape("http://www.amazon.co.jp/s/field-key_words=#{CGI.escape @key_word}")
        amazon_url = open("https://www.amazon.co.jp/s/field-keywords=#{CGI.escape @key_word}","User-Agent" => "ikura/#{rand(999999)}")

        #amazon_url = open("http://www.amazon.co.jp/gp/aw/s/ref=is_box_?__mk_ja_JP=%83J%83%5E%83J%83i&k=#{CGI.escape @key_word}&url=search-alias%3Daps")


    		doc = Nokogiri::HTML(amazon_url)
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

    def zh2jp(text)
      md5 = Digest::MD5.hexdigest("20160527000022236#{text}ikura2016CPtF543nsRwPIleARxOf")
      url="http://api.fanyi.baidu.com/api/trans/vip/translate?q=#{text}&from=zh&to=en&appid=20160527000022236&salt=ikura2016&sign=#{md5}"
      response=Net::HTTP.get_response(URI(URI.escape(url)))
      JSON.parse(response.body)['trans_result'][0]['dst']
    end

    def jp2zh(text)
      md5 = Digest::MD5.hexdigest("20160527000022236#{text}ikura2016CPtF543nsRwPIleARxOf")
      url="http://api.fanyi.baidu.com/api/trans/vip/translate?q=#{text}&from=jp&to=zh&appid=20160527000022236&salt=ikura2016&sign=#{md5}"
      response=Net::HTTP.get_response(URI(URI.escape(url)))
      JSON.parse(response.body)['trans_result'][0]['dst']
    end

end
