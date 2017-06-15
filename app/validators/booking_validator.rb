class BookingValidator < ActiveModel::Validator

  def validate(record)

    if record.start <= (Time.now + (60*60*24))
      record.errors[:start] << "You should book at least 24 hours in advance"
    end

    if record.end <= record.start
      record.errors[:end] << "The end time of the booking must come after the start time"
    end

    if (record.end.to_i - record.start.to_i) > (4*60*60)
      record.errors[:end] << "You can't book for more than 4 hours"
    end

    if record.location == 1
      record.errors[:location] << "It's not possible to book the Main Studio at the moment"
    end

    if record.creates_clash?
      record.errors[:start] << "This booking would clash with a previous one"
    end

  end

end
