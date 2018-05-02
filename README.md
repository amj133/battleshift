# BattleShift

An API for multi-player battleship. This is a brownfield project built on top of a pre-existing battleship game for a single player and computer. Players can register for an account, and will receive an email with their API key and a link to activate their account. Once activated, they are able to send post requests using their API key to create a new game, place their ships and fire shots on the opposing player.  Both players must be registered users. 

See the project spec here: [Battleshift project spec](http://backend.turing.io/module3/projects/battleshift)

See the deployed project here: [BattleShift Game](https://lit-hollows-27475.herokuapp.com/)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

For information on using our application in the deployed see [deployment](#deployment)

1. clone down this project and change into the directory
```
git clone https://github.com/amj133/battleshift.git
bundle install
```
2. create and migrate the database
```
rake db:create
rake db:migrate
```
3. create an active user in the database
```
rails c
User.create(name: "give it a name", email: "give in an email", password: "give it a password", password_confirmation: "same password", status: 1)
exit
```
4. Run rails server and visit localhost:3000 in your browser
```
rails s
```
*visit http://localhost:3000 in your browser
*enjoy!

### Prerequisites

* Ruby 2.4+
* Rails 5

To play battleship you will need to use cURL in your terminal or download the postman application from chrome.

## Running the tests

To run the tests, follow the instructions in [Getting Started](#getting-started) above first.  Open rails server in a separate tab then run rspec.
```
rspec
```
#####Our tests include: 
* feature tests for logging in, registering an account and visiting the user dashboard
* mailer tests for user receiving an API key and a link to activate their account 
* model tests of all ActiveRecord and PORO models
* service tests of all PORO services
* request tests of all API request endpoints

#####Tools and gems used for testing:
* [capybara](https://github.com/teamcapybara/capybara)
* [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
* [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
* [database_cleaner](https://github.com/DatabaseCleaner/database_cleaner)


## Deployment

To get set up on our deployed heroku app, visit the application [BattleShift Game](https://lit-hollows-27475.herokuapp.com/), register for an account, check your email address for an API key and link to activate your acount, and follow the instructions in the application. 
This application requires [postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en) or cURL in the terminal to make post requests to the api.


## Contributing

Feel free to make pull requests or comments to contribute to this application. We are happy to hear your feedback

## Authors

* [Andrew Jeffery](https://github.com/amj133)
* [Anna Royer](https://github.com/annaroyer)

## Acknowledgments

* Thank you to our wonderful instructors at Turing!
* The original brownfield Battleshift application: [original BattleShift](https://github.com/turingschool-examples/battleshift)
* The spec harness used to build out our functionality: [BattleShift Spec Harness](https://github.com/turingschool-examples/battleshift_spec_harness)
