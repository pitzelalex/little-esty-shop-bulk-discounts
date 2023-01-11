# Little Esty Shop

## Description

"Little Esty Shop" is a group project that builds a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.

## Project

Hosted on https://murmuring-reef-78817.herokuapp.com/

### Authors

    Thomas Casady: https://github.com/Tscasady
    Kerynn Davis: https://github.com/Kerynn
    Patricia Severance: https://github.com/pkseverance
    Alex Pitzel: https://github.com/pitzelalex

### Built With

    Ruby on Rails
    PostgreSQL
    Heroku

### Current Functionality

The project currently contains two dashboards, one for an admin and another for a particular merchant. The admin dashboard allows an admin to view all merchants and invoices. The admin can manage these invoices, see relevant customer information, enable and disable merchants, etc. The merchant dashboard allows a merchant to see the status of their items, what needs to be shipped, which items generate the most revenue and other features.  

### Moving Forward

We could extend this functionality by allowing an admin to manage the statues of multiple invoices at the same time, adding sorting features, such as sorting items alphabetically, or filtering items by a particular attribute.

We are also looking to upgrade the appearance of the application with Bootstrap.


### Setup

This project requires Ruby 2.7.4.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`
    * `rake load_csv:all`


