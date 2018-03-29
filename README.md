# What is this repo?

The purpose of the newscraper is to pull headlines from news sites (currently only Bloomberg), send those headlines to a Rails backend (inside the scraper directory) to be served on a minimal front-end or through voice-assistants (just a concept for now)

# How do I run this repo?
The rails app in the scraper directory can be run as follows:
1. Change your directory to /scraper
2. Run `bundle install`
3. Use `ruby bin\rails server` on Windows to run the app (`bin/rails server` on Max and Linux)

# How do I run the scraper?
1. Run `ruby nokogiri.rb`

# Things to do
- How to handle multiple news sites?