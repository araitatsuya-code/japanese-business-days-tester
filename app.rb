require 'sinatra'
require 'erb'
require 'date'
require 'json'

# Load japanese_business_days gem with error handling
begin
  require 'japanese_business_days'
rescue LoadError => e
  puts "Warning: japanese_business_days gem not available: #{e.message}"
  GEM_AVAILABLE = false
else
  GEM_AVAILABLE = true
end

# Configure Sinatra
configure do
  set :views, File.expand_path('views', __dir__)
  set :public_folder, File.expand_path('public', __dir__)
end

# Business day checking functionality
class BusinessDayChecker
  def self.check_business_day(date_string)
    # Enhanced date parsing and validation
    begin
      # First, validate the input string format
      if date_string.nil? || date_string.strip.empty?
        return { error: "日付が入力されていません。有効な日付を入力してください。" }
      end

      # Parse the date string with enhanced validation
      date = Date.parse(date_string.strip)
      
      # Additional validation for reasonable date ranges
      current_year = Date.today.year
      if date.year < 1900 || date.year > current_year + 10
        return { error: "日付の年が範囲外です。1900年から#{current_year + 10}年の間で入力してください。" }
      end

    rescue ArgumentError => e
      return { error: "無効な日付形式です。正しい日付を入力してください。（例：2024-01-15）" }
    rescue StandardError => e
      return { error: "日付の解析中にエラーが発生しました：#{e.message}" }
    end

    # Check if gem is available with user-friendly message
    unless GEM_AVAILABLE
      return { 
        error: "japanese_business_days gemが利用できません。アプリケーションの設定を確認してください。",
        gem_error: true
      }
    end

    # Use the gem to check if it's a business day with enhanced error handling
    begin
      is_business_day = JapaneseBusinessDays.business_day?(date)
      
      # Determine the reason if it's not a business day
      reason = nil
      unless is_business_day
        if date.saturday?
          reason = "土曜日（週末）"
        elsif date.sunday?
          reason = "日曜日（週末）"
        elsif JapaneseBusinessDays.holiday?(date)
          # Try to get holiday name if available
          begin
            holiday_name = JapaneseBusinessDays.holiday_name(date) rescue nil
            reason = holiday_name ? "祝日（#{holiday_name}）" : "日本の祝日"
          rescue
            reason = "日本の祝日"
          end
        else
          reason = "営業日ではありません"
        end
      end

      {
        date: date,
        is_business_day: is_business_day,
        reason: reason,
        success: true
      }
    rescue NoMethodError => e
      { error: "japanese_business_days gemのメソッドが見つかりません。gemのバージョンを確認してください。" }
    rescue StandardError => e
      { error: "営業日の判定中にエラーが発生しました：#{e.message}" }
    end
  end

  # Additional validation helper method
  def self.validate_date_input(date_string)
    return false if date_string.nil? || date_string.strip.empty?
    
    begin
      Date.parse(date_string.strip)
      true
    rescue ArgumentError
      false
    end
  end
end

# Main route - display the date input form
get '/' do
  erb :index
end

# POST route - process form submission and display results
post '/check' do
  date_input = params[:date]
  
  # Enhanced input validation and error handling
  begin
    # Primary validation - check for empty input
    if date_input.nil? || date_input.strip.empty?
      @result = { 
        error: "日付が入力されていません。カレンダーから日付を選択してください。",
        error_type: "validation"
      }
    else
      # Additional server-side validation before processing
      unless BusinessDayChecker.validate_date_input(date_input)
        @result = { 
          error: "入力された日付の形式が正しくありません。有効な日付を選択してください。",
          error_type: "format"
        }
      else
        # Check business day using the BusinessDayChecker
        @result = BusinessDayChecker.check_business_day(date_input)
        
        # Add input value for error recovery
        @result[:input_date] = date_input unless @result[:error]
      end
    end
  rescue StandardError => e
    # Catch any unexpected errors in the route
    @result = { 
      error: "予期しないエラーが発生しました。しばらく時間をおいて再度お試しください。",
      error_type: "system",
      debug_info: e.message
    }
  end
  
  erb :result
end

# Health check route with gem status
get '/health' do
  content_type :json
  status = {
    status: 'OK',
    gem_available: GEM_AVAILABLE,
    timestamp: Time.now.iso8601
  }
  
  unless GEM_AVAILABLE
    status[:status] = 'WARNING'
    status[:message] = 'japanese_business_days gem not available'
  end
  
  status.to_json
end

# Simple status route for basic health checks
get '/status' do
  GEM_AVAILABLE ? 'OK' : 'GEM_UNAVAILABLE'
end