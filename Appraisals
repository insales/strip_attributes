# frozen_string_literal: true

if RUBY_VERSION <= "2.4"
  # on mac ruby 2.3 can be installed:
  # brew install rbenv/tap/openssl@1.0 readline libyaml
  # rvm install 2.3.8 --with-openssl-dir=$(brew --prefix openssl@1.0) --with-readline-dir=$(brew --prefix readline) --autolibs=disable
  appraise "rails_3.2" do
    gem "activemodel", "3.2.22.5"
  end

  appraise "rails_4" do
    gem "activemodel", "4.2.11.3"
  end
end

if RUBY_VERSION >= '2.2.2' && RUBY_VERSION < '2.7'
  appraise "rails_5.2" do
    gem "activemodel", "~>5.2.8"
  end
end

if RUBY_VERSION >= '2.5' && RUBY_VERSION < '3.0'
  appraise "rails_6" do
    gem "activemodel", "~>6.0.5"
  end
end

if RUBY_VERSION >= '2.5'
  appraise 'rails_6.1' do
    gem "activemodel", "~>6.1.6"
  end
end

if RUBY_VERSION >= '2.7'
  appraise 'rails_7' do
    gem "activemodel", "~>7.0.3"
  end
end

# next rails 7 will be ruby >= 3.1
