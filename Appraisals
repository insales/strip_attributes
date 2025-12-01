# frozen_string_literal: true


# next rails 7 will be ruby >= 3.1
if RUBY_VERSION >= '3.1'
  appraise 'rails_7.2' do
    gem "activemodel", "~>7.2.2"
  end

  appraise 'rails_8.0' do
    gem "activemodel", "~>8.0.2"
  end

  appraise 'rails_8.1' do
    gem "activemodel", "~>8.1.1"
  end
end

# NB: after adding appraisals do `appraisal bundle lock --add-platform x86_64-linux` for CI