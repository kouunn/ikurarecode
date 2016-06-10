module NokogiriHelper
	  #unless session[:rate].nil?
		#汇率 API - json  汇率=rate['showapi_res_body']['money']
		response=Net::HTTP.get_response(URI('http://route.showapi.com/105-31?showapi_appid=18266&showapi_sign=0142ab2f164a43999ddd4fff43ebd063&fromCode=JPY&toCode=CNY&money=100&'))
		$rate = JSON.parse(response.body)['showapi_res_body']['money']
	  #end


end