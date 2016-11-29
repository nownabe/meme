Multi Emoji Markdown Editor
===========================

# Usage
```bash
$ bundle install
$ bundle exec ruby api.rb
```

# Deploy
```bash
$ heroku create
$ heroku config:set MEME_HOSTNAME=yourappname.herokuapp.com
$ heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt
$ heroku buildpacks:add heroku/ruby
```
