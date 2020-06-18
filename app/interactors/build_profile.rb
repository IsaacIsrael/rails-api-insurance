class BuildProfile
  include Interactor

  def call
    deserialization :house, has_one: true
    deserialization :vehicle, has_one: true

    context.profile = User.new(context.params)

    unless context.profile.valid?
      context.error = context.profile.errors.messages
      context.fail!
    end
  end

  private

  def deserialization(attribute, has_one = false)
    value = context.params.delete attribute

    if has_one && value.is_a?(Array)
      context.error = { attribute => ["it alowed only one #{attribute}"] }
      context.fail!
    end

    if !value.nil?
      context.params[attribute.to_s + '_attributes'] = value.to_h
    end
  end
end
