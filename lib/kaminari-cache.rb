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
      key = cache_key(options)
      entries = Rails.cache.fetch(key) do
        Rails.logger.info "Cache miss: #{key.to_s}"
        scope = self.send(options[:scope]) if options[:scope]
        scope = (scope || self).page(options[:page]).per(options[:per])
        scope = apply_locale(scope, options[:locale]) if options[:locale]
        scope = apply_includes(scope, options[:includes]) if options[:includes]
        scope = apply_sort(scope, options[:order]) if options[:order]
        Kaminari::PaginatableArray.new(scope.to_a,
          :limit => scope.limit_value,
          :offset => scope.offset_value,
          :total_count => scope.total_count
        )
      end
    end

    private
      def cache_key(options)
        key = [:kaminari, self.name.pluralize.downcase]
        key << options[:page]
        key << options[:per]
        key << [:locale, options[:locale]] if options[:locale]
        key << [:order, options[:order]] if options[:order]
        key << [:scope, options[:scope]] if options[:scope]
        key << [:includes, options[:includes]] if options[:includes]
        expanded_key(key)
      end

      def expanded_key(key)
        return key.cache_key.to_s if key.respond_to?(:cache_key)
        case key
          when Array
            if key.size > 1
              key = key.collect{|element| expanded_key(element)}
            else
              key = key.first
            end
          when Hash
            key = key.sort_by { |k,_| k.to_s }.collect{|k,v| "#{k}=#{v}"}
        end
        key.to_param
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
      def apply_locale(scope, locale)
        scope = scope.with_translations(locale) if scope.respond_to? :with_translations
        scope
      end
      def apply_includes(scope, includes)
        includes.each do |i|
          scope = scope.includes(i)
        end
        scope
      end
    end
end

ActiveRecord::Base.send(:include, KaminariCache)