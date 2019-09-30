# frozen_string_literal: true

require "json"
require "net/https"
require "uri"
require "zlib"

module DNPedia
  class API
    HOST = "dnpedia.com"
    BASE_URL = "https://#{HOST}"

    DEFAULT_HEADERS = {
      "Accept-Encoding" => "gzip",
      "Referer" => "https://dnpedia.com/tlds/search.php",
      "X-Requested-With" => "XMLHttpRequest",
    }.freeze

    DEFAULT_PARAMS = {
      cmd: "search",
      columns: "id,name,zoneid,length,idn,thedate,",
      ecf: "name",
      ecv: "",
      days: 2,
      mode: "added",
      _search: false,
      nd: 1_569_842_920_216,
      rows: 500,
      page: 1,
      sidx: "length",
      sord: "asc"
    }.freeze

    def search(word, **params)
      params = DEFAULT_PARAMS.merge(params).merge(
        ecv: normalize(word)
      )

      _get("/tlds/ajax.php", params) { |json| json }
    end

    private

    def normalize(word)
      return word if word.start_with?("~")
      return word unless word.include?("%")

      "~#{word}"
    end

    def url_for(path)
      URI(BASE_URL + path)
    end

    def https_options
      if proxy = ENV["HTTPS_PROXY"] || ENV["https_proxy"]
        uri = URI(proxy)
        {
          proxy_address: uri.hostname,
          proxy_port: uri.port,
          proxy_from_env: false,
          use_ssl: true
        }
      else
        { use_ssl: true }
      end
    end

    def decompress_gzip_body(body)
      io = StringIO.new(body)
      gz = Zlib::GzipReader.new(io)
      gz.read
    rescue Zlib::GzipFile::Error => e
      raise Error, e.message
    end

    def request(req)
      Net::HTTP.start(HOST, 443, https_options) do |http|
        response = http.request(req)

        code = response.code.to_i
        raise Error, "Unsupported response code returned: #{code}" if code != 200

        body = response.body
        body = decompress_gzip_body(body) if response["content-encoding"] == "gzip"

        yield JSON.parse body
      end
    end

    def _get(path, params = {}, &block)
      uri = url_for(path)
      uri.query = URI.encode_www_form(params)
      get = Net::HTTP::Get.new(uri, DEFAULT_HEADERS)

      request(get, &block)
    end
  end
end
