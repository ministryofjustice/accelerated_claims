class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 1
    counter = increment_counter(counter, 'defendant')
    counter = increment_counter(counter, 'claimant')
    @json['copy_number'] = (counter)
    @json
  end

  private

  def increment_counter(counter, collection)
    controller = "#{collection.camelize}Collection".safe_constantize
    (1..controller.send("max_#{collection}s")).each do |i|
      counter += 1 if @json["#{collection}_#{i}_address"].present?
    end
    counter
  end
end
