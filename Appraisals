# frozen_string_literal: true

if RUBY_VERSION >= '2.5'
  appraise 'rails_6.1' do
    gem "activemodel", "~>6.1.7"
    # for ruby 3.?+:
    gem "base64"
    gem "bigdecimal"
    gem "mutex_m"
  end
end

if RUBY_VERSION >= '2.7'
  appraise 'rails_7.0' do
    gem "activemodel", "~>7.0.8"
    # for ruby 3.?+:
    gem "base64"
    gem "bigdecimal"
    gem "mutex_m"
  end
end

# next rails 7 will be ruby >= 3.1
if RUBY_VERSION >= '3.1'
  appraise 'rails_7.2' do
    gem "activemodel", "~>7.2.2"
  end

  appraise 'rails_8.0' do
    gem "activemodel", "~>8.0.2"
  end
end
