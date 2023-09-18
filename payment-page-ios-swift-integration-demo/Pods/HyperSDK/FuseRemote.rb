require 'net/http'
require 'fileutils'
require 'logger'

is_xcodeproj_available = true
begin
    require 'xcodeproj'
rescue LoadError
    is_xcodeproj_available = false
end

class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def yellow;         "\e[33m#{self}\e[0m" end
end

verboseEnabled = false
downloadInParallel = true

class AssetsDownloadWorker
    def self.start(files_count:, verbose:, downloadInParallel:)
        queue = SizedQueue.new(files_count)
        num_threads = 0
        if downloadInParallel == true
            num_threads = 15
        end
        worker = new(num_threads: num_threads, queue: queue, verbose: verbose)
        worker.spawn_threads
        worker
    end

    def initialize(num_threads:, queue:, verbose:)
        @num_threads = num_threads
        @queue = queue
        @threads = []
        @files_downloaded = 0
        @actions_finished = 0
        @verbose = verbose
    end

    attr_reader :num_threads, :threads, :queue

    attr_reader :files_downloaded, :actions_finished

    def spawn_threads
        num_threads.times do
            threads << Thread.new() {
                while running? || actions?
                    payload = wait_for_action
                    download_assets(payload) if payload
                end
            }
        end
    end

    def download_assets(payload)
        logger = Logger.new(STDOUT)
        file = payload["file"]
        file_data = file.gsub!(/\s/, '').split("@", 2)
        file_name = file_data[0].split("/")[2]
        file_path = payload["iphoneFrameworkPath"] + file_name
        file_path_simulator = payload["simulatorFrameworkPath"] + file_name
        file_url = file_data[1]
        is_xcframework = payload["isXCFramework"]

        if (@verbose)
            logger.info("[HyperSDK] downloading file: #{file_url}")
        end

        url = URI.parse(file_url)
        req = Net::HTTP::Get.new(url.path)
        if File.exist?(file_path) && file_name != "v1-boot_loader.jsa"
            time = (File.mtime(file_path)).gmtime
            gmt = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
            req.add_field("If-Modified-Since", gmt)
        end

        begin
            res = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
                http.request(req)
            end
            if (@verbose)
                logger.info("[HyperSDK] File Response message: #{res.message}")
            end

            if res.code == '304'
            elsif res.code == '403'
                logger.error("[HyperSDK] Error downloading file: #{file_url} #{res.code}")
            elsif res.code == '200'
                @files_downloaded += 1
                File.open(file_path, 'w') do |f|
                    f.write res.body
                end
                if is_xcframework
                    File.open(file_path_simulator, 'w') do |f|
                        f.write res.body
                    end
                end
            else
                puts ("[HyperSDK] Error downloading file: " + file_url + " " + res.code).red
            end
        rescue StandardError => e
            logger.fatal("[HyperSDK] Crashed while downloading file: #{e}")
        end
        @actions_finished += 1
    end

    def enqueue(payload)
        queue.push(payload)
    end
    
    def stop
        queue.close
        threads.each(&:exit)
        threads.clear
        true
    end
  
    def actions?
        !queue.empty?
    end
    
    def running?
        !queue.closed?
    end
    
    def dequeue_action
        queue.pop(true)
    end
    
    def wait_for_action
        queue.pop(false)
    end
end

merchant_config_data = {
    "clientId" => "internalPP",
    "env" => "production",
    "scope" => "release",
    "version" => ""
}
merchant_config_path = "./MerchantConfig.txt"

if File.exist?(merchant_config_path)
    File.foreach(merchant_config_path) { |line|
        rawLine = line.gsub!(/\s/, '')
        if rawLine != nil
            line = rawLine
        end
        key_value = line.split("=", 2)
        if key_value[0] && key_value[1]
            merchant_config_data[key_value[0]] = key_value[1]
        end
    }
else
    puts "[HyperSDK] Error - MerchantConfig.txt file not found. Put it in the folder where Podfile is present.".red
    return
end

pListTargets = []
if (merchant_config_data["pListTargets"])
    pListTargets = merchant_config_data["pListTargets"].split(",")
end

def to_boolean(str)
    str.to_s.downcase == 'true'
end

if (merchant_config_data["verbose"])
    verboseEnabled = to_boolean(merchant_config_data["verbose"])
end

if (merchant_config_data["downloadInParallel"])
    downloadInParallel = to_boolean(merchant_config_data["downloadInParallel"])
end

env = merchant_config_data["env"].split("_")[0]
merchant_name = merchant_config_data["clientId"].split("_")[0]
scope = merchant_config_data["scope"].split("_")[0]
version = merchant_config_data["version"]

domain = env == "sandbox" ? "https://sandbox.assets.juspay.in" : "https://assets.juspay.in"
os = "ios"

puts ("[HyperSDK] Client ID - " + merchant_name).yellow
puts ("[HyperSDK] Environment - " + env).yellow
puts ("[HyperSDK] Scope - " + scope).yellow

if version != ""
    puts ("[HyperSDK] Version -" + version).yellow
end

clean_assets = ARGV.length > 0 && ARGV[0] == "true"
is_xcframework = ARGV.length > 1 && ARGV[1] == "xcframework"

puts ("[HyperSDK] Is Xcframework? - " + (is_xcframework ? "Yes" : "No")).yellow

temp_dir_name = "temp"
hyper_sdk_framework_path = is_xcframework ? "./Pods/HyperSDK/HyperSDK.xcframework" : "./Pods/HyperSDK/HyperSDK.framework"
assets_path = is_xcframework ? hyper_sdk_framework_path + "/*/*" : hyper_sdk_framework_path

if clean_assets
    FileUtils.rm_rf(temp_dir_name)
    FileUtils.rm_rf(Dir[ assets_path + "/*.png" ])
    FileUtils.rm_rf(Dir[ assets_path + "/*.ttf" ])
    FileUtils.rm_rf(Dir[ assets_path + "/*.xml" ])
    FileUtils.rm_rf(Dir[ assets_path + "/payments-*.jsa" ])
    FileUtils.rm_rf(Dir[ assets_path + "/payments-in.juspay.vies-vies*" ])
    FileUtils.rm_rf(Dir[ assets_path + "/v1-config.jsa" ])
    FileUtils.rm_rf(Dir[ assets_path + "/v1-boot_loader.jsa" ])
    FileUtils.rm_rf(Dir[ assets_path + "/juspay_assets.json" ])
end

FileUtils.rm_rf(Dir[ assets_path + "/VerifyHyperAssets.h" ])
FileUtils.rm_rf(Dir[ assets_path + "/Headers/VerifyHyperAssets.h" ])

FileUtils.mkdir_p temp_dir_name

versionPart = version != "" ? "/" + version : version
filePart = '/AssetConfig.txt'
scopePart = (scope == "beta" ? "beta/" : (scope == "cug") ? "cug/" : "")

url = URI.parse(domain + '/hyper/assetConfig/' + os + '/' + scopePart + merchant_name + versionPart + filePart)
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

files_to_download.push('HyperAssets/payments/VerifyHyperAssets.h @ https://public.releases.juspay.in/hypersdk-asset-download/ios/VerifyHyperAssets.h');

hyper_sdk_iphone_framework_path = hyper_sdk_framework_path + (is_xcframework ? "/ios-arm64/HyperSDK.framework/" : "/")
hyper_sdk_simulator_framework_path = hyper_sdk_framework_path + "/ios-arm64_x86_64-simulator/HyperSDK.framework/"

worker_instance = AssetsDownloadWorker.start(files_count: files_to_download.length, verbose: verboseEnabled, downloadInParallel: downloadInParallel)

puts "[HyperSDK] Downloading assets..."

files_to_download.each do |file|
    if (downloadInParallel == true)
        worker_instance.enqueue({ "file" => file,
                                    "iphoneFrameworkPath" => hyper_sdk_iphone_framework_path, 
                                    "simulatorFrameworkPath" => hyper_sdk_simulator_framework_path,
                                    "isXCFramework" => is_xcframework })
    else
        worker_instance.download_assets({ "file" => file, 
                                        "iphoneFrameworkPath" => hyper_sdk_iphone_framework_path, 
                                        "simulatorFrameworkPath" => hyper_sdk_simulator_framework_path,
                                        "isXCFramework" => is_xcframework })
    end
end

until files_to_download.length == worker_instance.actions_finished
    sleep 1
end

puts "[HyperSDK] #{worker_instance.files_downloaded - 1} file(s) downloaded/updated."

worker_instance.stop

FileUtils.mv(hyper_sdk_iphone_framework_path + "VerifyHyperAssets.h", hyper_sdk_iphone_framework_path + "Headers")
if is_xcframework
    FileUtils.mv(hyper_sdk_simulator_framework_path + "VerifyHyperAssets.h", hyper_sdk_simulator_framework_path + "Headers")
end

FileUtils.rm_rf(temp_dir_name)

def show_add_plist_property_warning
    puts "Please add the following properties manually in the App's plist file. Ignore if already added.".yellow
    puts """
        <key>CFBundleURLTypes</key>
        <array>
            <dict>
                <key>CFBundleURLName</key>
                <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>amzn-$(PRODUCT_BUNDLE_IDENTIFIER)</string>
                    <string>juspay-$(PRODUCT_BUNDLE_IDENTIFIER)</string>
                    <string>$(PRODUCT_BUNDLE_IDENTIFIER).cred</string>
                    <string>paytm-$(PRODUCT_BUNDLE_IDENTIFIER)</string>
                </array>
            </dict>
        </array>
        
        <key>LSApplicationQueriesSchemes</key>
        <array>
            <string>credpay</string>
            <string>phonepe</string>
            <string>paytmmp</string>
            <string>tez</string>
            <string>paytm</string>
            <string>bhim</string>
            <string>devtools</string>
            <string>myairtel</string>
        </array>
    """
end

if is_xcodeproj_available
    project_files = Dir[ __dir__ + "/../../*.xcodeproj" ]

    if project_files.length > 0
        project_path = project_files[0]
        project_file_name = project_path.split('/').last
        project_folder_name = project_file_name.split('.').first

        project = Xcodeproj::Project.open(project_path)
        target = project.targets[0]

        info_plist_files = []

        project.targets.each { |target|
            if target.sdk == "iphoneos"
                if pListTargets == [] || pListTargets.include?(target.name)
                    debugBuildSettings = target.build_settings("Debug")
                    releaseBuildSettings = target.build_settings("Release")

                    if debugBuildSettings
                        debugPlistPath = debugBuildSettings["INFOPLIST_FILE"]
                        if debugPlistPath && !info_plist_files.include?(debugPlistPath)
                            info_plist_files.push(debugPlistPath)
                        end
                    end

                    if releaseBuildSettings
                        releasePlistPath = releaseBuildSettings["INFOPLIST_FILE"]
                        if releasePlistPath && !info_plist_files.include?(releasePlistPath)
                            info_plist_files.push(releasePlistPath)
                        end
                    end
                end
            end
        }

        if info_plist_files.length > 0
            puts "[HyperSDK] Adding the required URL Schemes & Queries Schemes in plist files..."
            info_plist_files.each { |info_plist_file_path|
                puts "[HyperSDK] Plist file path: " + info_plist_file_path
                info_plist_file_path.slice! "$(SRCROOT)/"
                info_plist_file_path.slice! "${SRCROOT}/"
                if File.exist?(info_plist_file_path)
                    info=Xcodeproj::Plist.read_from_path(info_plist_file_path)
                    queriesSchemes = info["LSApplicationQueriesSchemes"] || []
                    queriesSchemesToAdd = ["credpay", "phonepe", "paytmmp", "tez", "paytm", "bhim", "devtools", "myairtel"]
                    queriesSchemesToAdd.each { |item|
                        if queriesSchemes.include?(item) == false
                            queriesSchemes.push(item)
                        end
                    }
                    info["LSApplicationQueriesSchemes"] = queriesSchemes

                    urlSchemesToAdd = ["amzn-$(PRODUCT_BUNDLE_IDENTIFIER)", "juspay-$(PRODUCT_BUNDLE_IDENTIFIER)", "$(PRODUCT_BUNDLE_IDENTIFIER).cred", "paytm-$(PRODUCT_BUNDLE_IDENTIFIER)"]
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
                else
                    puts ("[HyperSDK] Warning - Couldn't find plist file at path " + info_plist_file_path + ". Please add the required URL Schemes & Queries Schemes manually in the plist file. Ignore if already added.").yellow
                end
            }
        else
            puts "[HyperSDK] Warning - Couldn't find plist files.".yellow
            show_add_plist_property_warning()
        end
    end
else
    puts "[HyperSDK] Warning - Couldn't add the required properties in the plist file since `xcodeproj` gem library is missing.\n\nPlease install it by running `gem install xcodeproj` and then run `pod install`.\n(or)".yellow
    show_add_plist_property_warning()
end

puts "[HyperSDK] Done.".green