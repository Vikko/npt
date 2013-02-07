Thread.new do
  system("bundle exec rackup faye.ru -s thin -E production")
end