require 'open-uri'
require 'uri'
require 'net/http'
require 'fileutils'
require 'xcodeproj'

class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def yellow;         "\e[33m#{self}\e[0m" end
end

merchant_config_data = {
    "clientId" => "internalPP",
    "env" => "production",
    "scope" => "release"
}
merchant_config_path = "./MerchantConfig.txt"

if File.exist?(merchant_config_path)
    File.foreach(merchant_config_path) { |line| 
        key_value = line.gsub!(/\s/, '').split("=", 2)
        if key_value[0] && key_value[1]
            merchant_config_data[key_value[0]] = key_value[1]
        end
    }
end

env = merchant_config_data["env"].split("_")[0]
merchant_name = merchant_config_data["clientId"].split("_")[0]
scope = merchant_config_data["scope"].split("_")[0]

domain = env == "sandbox" ? "https://sandbox.assets.juspay.in" : "https://assets.juspay.in"
os = "ios"

puts ("[HyperSDK] Client ID - " + merchant_name).yellow
puts ("[HyperSDK] Environment - " + env).yellow
puts ("[HyperSDK] Scope - " + scope).yellow

temp_dir_name = "temp"
hyper_sdk_framework_path = "./Pods/HyperSDK/HyperSDK.framework"

clean_assets = ARGV.length > 0 && ARGV[0] == "true"

if clean_assets
    FileUtils.rm_rf(temp_dir_name)
    FileUtils.rm_rf(Dir[ hyper_sdk_framework_path + "/*.png" ])
    FileUtils.rm_rf(Dir[ hyper_sdk_framework_path + "/*.ttf" ])
    FileUtils.rm_rf(Dir[ hyper_sdk_framework_path + "/payments-*.jsa" ])
end

FileUtils.mkdir_p temp_dir_name

url = URI.parse(domain + '/hyper/assetConfig/' + os + '/' + (scope == "beta" ? "beta/" : "") + merchant_name + '/AssetConfig.txt')
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
    http.request(req)
end

asset_config_path = "temp/AssetConfig.txt"

if res.code == '200'
    File.open(asset_config_path, 'w') do |f|
        f.write res.body
    end
else
    puts ("[HyperSDK] Error downloading AssetConfig - " + res.code).red
    return
end

files_to_download = []

if File.exist?(asset_config_path)
    File.foreach(asset_config_path) { |line|     
        files_to_download.push(line)
    }
end

puts "[HyperSDK] Downloading assets..."
files_downloaded = 0
files_to_download.each do |file|
    file_data = file.gsub!(/\s/, '').split("@", 2)
    file_name = file_data[0].split("/")[2]
    file_path = hyper_sdk_framework_path + "/" + file_name
    file_url = file_data[1]

    url = URI.parse(file_url)
    req = Net::HTTP::Get.new(url.path)

    if File.exist?(file_path)
        time = (File.mtime(file_path)).gmtime
        gmt = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
        req.add_field("If-Modified-Since", gmt)
    end

    res = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        http.request(req)
    end

    if res.code == '304'
        
    elsif res.code == '200'
        files_downloaded += 1
        File.open(file_path, 'w') do |f|
            f.write res.body
        end
    else
        puts ("[HyperSDK] Error downloading file: " + file_url + " " + res.code).red
    end    
end

puts "[HyperSDK] #{files_downloaded} file(s) downloaded/updated."

FileUtils.rm_rf(temp_dir_name)

project_files = Dir[ __dir__ + "/../../*.xcodeproj" ]

if project_files.length > 0
    project_path = project_files[0]
    project_file_name = project_path.split('/').last
    project_folder_name = project_file_name.split('.').first

    info_plist_files = Dir[ "./" + project_folder_name + "/*.plist" ] 

    if info_plist_files.length > 0 
        puts "[HyperSDK] Adding the required URL Schemes & Queries Schemes in plist files"
        info_plist_files.each { |info_plist_file_path| 
            puts "[HyperSDK] Plist file path: " + info_plist_file_path

            info=Xcodeproj::Plist.read_from_path(info_plist_file_path)
            queriesSchemes = info["LSApplicationQueriesSchemes"] || []
            queriesSchemesToAdd = ["credpay", "phonepe", "paytmmp", "tez", "paytm", "bhim", "devtools"]
            queriesSchemesToAdd.each { |item| 
                if queriesSchemes.include?(item) == false
                    queriesSchemes.push(item)
                end
            }
            info["LSApplicationQueriesSchemes"] = queriesSchemes

            urlSchemesToAdd = ["amzn-$(PRODUCT_BUNDLE_IDENTIFIER)", "juspay-$(PRODUCT_BUNDLE_IDENTIFIER)", "$(PRODUCT_BUNDLE_IDENTIFIER).cred"]
            urlTypes = info["CFBundleURLTypes"] || []
            if urlTypes.empty?
                urlTypes.push({"CFBundleURLName" => "$(PRODUCT_BUNDLE_IDENTIFIER)", "CFBundleURLSchemes" => urlSchemesToAdd})
            else
                firstItem = urlTypes[0]
                if firstItem["CFBundleURLName"] != "$(PRODUCT_BUNDLE_IDENTIFIER)"
                    urlTypes.insert(0, {"CFBundleURLName" => "$(PRODUCT_BUNDLE_IDENTIFIER)", "CFBundleURLSchemes" => urlSchemesToAdd})
                else
                    urlSchemes = firstItem["CFBundleURLSchemes"] || []
                    urlSchemesToAdd.each { |item| 
                        if urlSchemes.include?(item) == false
                            urlSchemes.push(item)
                        end
                    }
                    firstItem["CFBundleURLSchemes"] = urlSchemes
                    urlTypes[0] = firstItem
                end
            end
            info["CFBundleURLTypes"] = urlTypes
            Xcodeproj::Plist.write_to_path(info, info_plist_file_path)
        }
        puts "[HyperSDK] Done.".green
    else
        puts "[HyperSDK] No plist file found. Please add the required URL Schemes & Queries Schemes manually.".yellow
        puts "[HyperSDK] Done.".green
    end
end