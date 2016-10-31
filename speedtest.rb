#!/usr/bin/env ruby

require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-screenshot"
require "selenium-webdriver"

username, password = ARGV[0], ARGV[1]

unless username || password
  $stderr.puts "Please provide username and password: ruby speedtest.rb username password"
  exit 1
end

Capybara.run_server = false
Capybara.register_driver :selenium do |app|
  Selenium::WebDriver::Firefox::Binary.path = "/Applications/Firefox47.0.1/Firefox.app/Contents/MacOS/firefox"
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end
Capybara.current_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = 5

Capybara.app_host = "https://www.telecolumbus.de"

include Capybara::DSL

visit "/kundenservice/speedtest/assistent/"

choose("Zwischen Computer und Kabelmodem ist eine Direktverbindung mit einem Ethernetkabel hergestellt.", wait: 10)
click_link("Weiter")
sleep 5

choose("Es sind keine leistungshemmenden Programme oder Anwendungen mehr geöffnet oder aktiv.", wait: 10)
click_link("Weiter")
sleep 5

choose("Netzwerkadapter und Ethernetkabel entsprechen den Vorgaben und funktionieren einwandfrei.", wait: 10)
click_link("Weiter")
sleep 5

choose("Ihr Computer arbeitet fehlerfrei, ist optimal konfiguriert und leistungsfähig. Leistungshemmende Add-Ons und Einstellungen sind nicht vorhanden.", wait: 10)
click_link("Weiter")
sleep 5

new_window = window_opened_by { click_link "Starten" }
sleep 5

within_window new_window do
  sleep 5
  fill_in "username", with: username
  fill_in "password", with: password
  click_link "Login"
  sleep 5
  save_and_open_page
end
