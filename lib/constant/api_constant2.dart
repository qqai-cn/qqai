class ApiConstant2 {
  //和风天气,https://dev.qweather.com/docs/api/geoapi/city-lookup/
  static const String HE_FENG_BASE_API =
      'https://np6hewbpx7.re.qweatherapi.com';

  static const String API_KEY = '4119cc50b08743198978cf2a97b0bd34';
  // static const String API_KEY = '65e4469558bc45709fd6adfe554c270e';

  //城市搜索,
  static const String HE_CITY_API = HE_FENG_BASE_API + '/geo/v2/city/lookup';

  //实时天气,
  static const String REALTIME_WEATHER = '/v7/weather/now';

  //逐小时天气预报,
  static const String HOUR_WEATHER = HE_FENG_BASE_API +'/v7/weather/24h';

  //每日天气预报,
  static const String DAY_WEATHER = HE_FENG_BASE_API +'/v7/weather/10d';
  //天气指数
  static const String DAY_INDICES = HE_FENG_BASE_API +'/v7/indices/1d';

  //分钟级降水,
  static const String MINUTE_WEATHER = '/v7/minutely/5m';
}
