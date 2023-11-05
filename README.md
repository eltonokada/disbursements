# README

= Disbursement calculation of merchants disbursements payouts
  This application is responsible to create disbursements based in merchants disbursement frequency, considering the fees that needs to be collected by seQura and the orders amounts.

= Usage

  Install Ruby 3.1.2 - you can use rbenv, or rvm as a ruby version manager to install.
  Copy the content of the application, or clone the repository
  Go to root directory of the application and run bundle install to install required dependencies
  Edit config/database.yml with your database data.
  Create databases running rake db:create rake db:migrate

  The application is using whenever gem to schedule the rake task run_disbursement, actually the task will run every day at 00:00AM, it can be changed in config/schedule.rb

  You can view the schedule running bundle exec whenever
  
  run whenever --update-crontab to add to crontab

  To run tests go to application root and run rspec.
  
= Application
  The application consists of a main rake task that handle the execution of the 3 main jobs:
    rake custom_tasks:disburse_orders
    
  - DailyDisbursmentJob
    Handle orders from merchants configured as daily disbursement frequency
  - WeeklyDisbursementJob
    Handle orders from merchants configured as weekly disbursement frequency
  - RemainingMonthlyFeeJob
    Check pending fees for past month from all merchants on the first day of the month. In this case, this job will be the first one to run, and the other jobs will only run after its finished.
  
  Application is using Sidekiq/Redis to handle the jobs, a very solid technology that handles queues processing

  As we might have a huge number of others, the application also have a OrderDisbursementJob, that will be called in each merchant iteration, and will enqueue in sidekiq each disbursement operation, with this the application can scale horizontally if needed, adding as much workers as needed to handle the amount of orders.

  Improvements

  We can analyze the way that the application is getting merchant orders, sometimes, using raw SQL queries might be faster, i understand that is not the most elegant solution, but in some cases might be necessary.
  The calculation of order fees are directly in a order method, we can move this to be done directly in database as SQL, also needs to some load testing.
  We can just have one single job that handle daily and weekly jobs, we have a few code that is being repeated in this 2 jobs, but as the other options, need to study. We can have one single query that handle with this data, but, from an other point of view, having 2 jobs might be easier to understand and debug if needed, although each disbursement operation is being enqueued.
  Also need to add tests for the logic os jobs execution, actually this was tested manually.


Year | Number of disbursements | Amount disbursed to merchants | Amount of order fees |  Number of monthly fees charged(From minimum monthly fee) |  Amount of monthly fee charged (From minimum monthly fee)

2022 | 1435 | 16.121.678,41€ | 149.967,98€  | 3808,00€ | 82.110,00€
2023 | 995 |  17.038.683,80€ | 156.617,93  | 1248,00€ | 26.910,00 €