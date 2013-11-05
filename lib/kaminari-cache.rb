module KaminariCache
  extend ActiveSupport::Concern
  
  def self.included(base)
    base.after_update :flush_pagination_cache
  end
  
  def flush_pagination_cache
    store_class = Rails.cache.class.name.split("::").last
    if Rails.cache.respond_to? "delete_matched"

      self.changed.each do |field|
        match = [:kaminari, "/#{self.class.name.downcase}", '*', "/#{:order}", '*', "/#{field}", '*']
        
        Rails.logger.info "Cache flush: #{match.join}"
        case store_class
        when "DalliStore"
          # DalliStore uses a Regexp
          regexp = Regexp.new match.join.gsub(/\*/,'.*?')
          Rails.cache.delete_matched /^#{Regexp.escape(:kaminari)}\/#{Regexp.escape(self.class.name.downcase)}/
        when "RedisStore"
          # RedisStore uses a String
          Rails.cache.delete_matched match.join
        end
      end

    else
      Rails.cache.clear
      Rails.logger.warn "#{store_class} does not support deleting matched keys. The entire cache was flushed. Consider using RedisStore (Redis) OR DalliStore (gem dalli) for memcached with dalli-store-extensions gem for improved performance."
    end
  end
  
  module ClassMethods
    def fetch_page(options = {})
      # Default options
      options.reverse_merge!(
        :page => 1,
        :per => Kaminari.config.max_per_page || Kaminari.config.default_per_page
      )
      entries = Rails.cache.fetch(cache_key(options)) do
        scope = self.page(options[:page]).per(options[:per])
        scope = apply_sort(scope, options[:order])
        Kaminari::PaginatableArray.new(scope.to_a,
          :limit => scope.limit_value,
          :offset => scope.offset_value,
          :total_count => scope.total_count
        )
      end
    end

    def cache_key(options)
      key = [:kaminari, self.name.downcase]
      key << options[:page]
      key << options[:per]
      key << ["order", options[:order]] if options[:order]
      key
    end

    def apply_sort(scope, order)
      case order
        when Symbol
          scope.order! order
        when String
          scope.order! order
        when Hash
          order.each do |k, v|
            if v.empty?
              scope.order! k
            else
              scope.order! "#{k.to_s} #{v.to_s}"
            end
          end
      end
      scope
    end
  end
end

ActiveRecord::Base.send(:include, KaminariCache)