class Exception
  def to_hash
    {
      :backtrace => backtrace,
      :message => message,
      :klass => self.class.to_s,
      :error_class => self.class.name, # Hoptoad compatibility
      :error_message => "#{self.class.name}: #{message}" # Hoptoad compatibility
    }
  end
end
