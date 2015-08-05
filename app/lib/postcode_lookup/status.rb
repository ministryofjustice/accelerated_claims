module PostcodeLookup
  class Status
    attr_accessor :message, :code, :http_status, :result

    def initialize(args={})
      self.message = args[:message]
      self.code = args[:code]
      self.http_status = args[:http_status]
      self.result = args[:result]
    end

    def to_h
      h = { message: self.message, code: self.code }
      h[:result] = self.result if self.result.present?
      h
    end

    def to_json
      to_h.to_json
    end
  end
end