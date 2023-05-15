require 'open-uri'
require 'uri'
require 'net/http'
require 'fileutils'

class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def yellow;         "\e[33m#{self}\e[0m" end
end

fuse_remote_url = "https://public.releases.juspay.in/hypersdk-asset-download/ios/Fuse.rb"

url = URI.parse(fuse_remote_url)
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
    http.request(req)
end

fuse_remote_file_path = "./Pods/HyperSDK/FuseRemote.rb"

if res.code == '200'
    File.open(fuse_remote_file_path, 'w') do |f|
        f.write res.body
    end
else
    puts ("[HyperSDK] Error downloading Fuse script - " + res.code).red
    return
end

if !system("ruby", fuse_remote_file_path, ARGV[0], "xcframework")
    puts "[HyperSDK] Assets download failed.".red
end