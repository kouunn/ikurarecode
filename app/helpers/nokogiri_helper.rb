module NokogiriHelper
	  #unless session[:rate].nil?
		#汇率 API - json  汇率=rate['showapi_res_body']['money']
		response=Net::HTTP.get_response(URI('http://route.showapi.com/105-31?showapi_appid=18266&showapi_sign=0142ab2f164a43999ddd4fff43ebd063&fromCode=JPY&toCode=CNY&money=100&'))
		$rate = JSON.parse(response.body)['showapi_res_body']['money']
	  #end

	  def zh2jp(text)
	    md5 = Digest::MD5.hexdigest("20160527000022236#{text}ikura2016CPtF543nsRwPIleARxOf")
	    url="http://api.fanyi.baidu.com/api/trans/vip/translate?q=#{text}&from=zh&to=jp&appid=20160527000022236&salt=ikura2016&sign=#{md5}"
	    response=Net::HTTP.get_response(URI(URI.escape(url)))
	    JSON.parse(response.body)['trans_result'][0]['dst']
	  end

	  def jp2zh(text)
	    md5 = Digest::MD5.hexdigest("20160527000022236#{text}ikura2016CPtF543nsRwPIleARxOf")
	    url="http://api.fanyi.baidu.com/api/trans/vip/translate?q=#{text}&from=jp&zh=jp&appid=20160527000022236&salt=ikura2016&sign=#{md5}"
	    response=Net::HTTP.get_response(URI(URI.escape(url)))
	    JSON.parse(response.body)['trans_result'][0]['dst']
	  end
end