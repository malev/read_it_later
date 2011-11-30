ReadItLater API
===============

This is a wrapper over [ReadItLater](http://readitlaterlist.com/) API, so you can work with this great service right from your Ruby app.

Installation
============

Sadly it is not still a gem.

Use
===

Once you have installed the lib (future gem) you will have access to the ReadItLater class:

    user = ReadItLater::User.new("username", "password")
    ril = ReadItLater::Api.new("apikey")

    ril.authenticate(user) -> true

    ril.status(user) -> Object with all the status information

    ril.text("http://weblog.rubyonrails.org/2011/11/20/rails-3-1-3-has-been-released") -> will return a text version of the blog post.

TODO
====

* Create a new user
* Get the user's articles list
* Add new articles to the user's list
