class Exception
  def to_hash
    { :backtrace => backtrace, :message => message, :klass => self.class.to_s }
  end
end
