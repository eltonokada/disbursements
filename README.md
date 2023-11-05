# README

Disbursement calculation of merchants disbursements payouts
  This application is responsible to create disbursements based in merchants disbursement frequency, considering the fees that needs to be collected by seQura and the orders amounts.

## Usage

Install Ruby 3.1.2 - you can use rbenv, or rvm as a ruby version manager to install.
Copy the content of the application, or clone the repository

Installing dependencies: go to the root directory off the application and run:

```
  bundle install 
```

Edit config/database.yml with your database data.

  Create databases running 
  ```
    rake db:create 
    rake db:migrate
  ```
  Import data
  ```
    rake sequra:import_orders
    rake sequra:import_merchants
  ```
  The application is using whenever gem to schedule the rake task run_disbursement, actually the task will run every day at 00:00AM, it can be changed in config/schedule.rb

  You can view the schedule running 

  ```
    bundle exec whenever
  ```

  To update the crontab:
  ```
    whenever --update-crontab 
  ```    
  
  To run tests go to application root and run 

  ```
    rspec
  ```    
  
  The application needs Sidekiq and Redis up and running, to manage the process queues
  Go to root directory

  ```
    bundle exec sidekiq -C config/sidekiq.yml
  ```
  Open another terminal
  ```
    redis-server
  ```

  To generate the results for the imported data, we have a task that handle this for all previous dates.
  ```
    rake sequra:disburse_imported_data
  ```
  In my local environment this task that disburse orders from previous dates took 5 minutes to finish.

## Application summary
  The application consists of a main rake task 
  ```
    rake sequra:disburse_orders
  ```
  This task is scheduled to run everyday at 00:00AM
  
  That handle the execution of 3 jobs:
    
  - DailyDisbursmentJob
    Handle orders from merchants configured as daily disbursement frequency
  - WeeklyDisbursementJob
    Handle orders from merchants configured as weekly disbursement frequency
  - RemainingMonthlyFeeJob
    Check pending fees for past month from all merchants on the first day of the month. In this case, this job will be the first one to run, and the other jobs will only run after its finished.

  Application is using Sidekiq/Redis to handle the jobs processing.

  As we might have a huge number of others, the application also have a OrderDisbursementJob, that will be called in each merchant iteration, and will enqueue in sidekiq each disbursement operation, sending to OrderDisbursmentService, with this the application can scale horizontally if needed, adding as much workers as needed to handle the amount of orders.

  For remaining monthly fees calculation we have RemainingMonthlyFeeService.

  These 2 services are in app/services

  Models:

  Merchant
  Order
  Disbursement
  
  A creation of a disbursement item would be considered, but for now, only disbursement is enough, as we have methods in order that handle the fee calculation.
  A thing to be considered if needed.
## Improvements and decisions

  We should analyze the way that the application is getting merchant orders, sometimes, using raw SQL queries might be faster, i understand that is not the most elegant solution, but in some cases might be necessary. So, this is a possible improvement. My suggestion is to do tests with more data, so we can measure how fast queries can be.

  The calculation of order fees are directly in a order method, we can move this to be done directly in database as SQL, also needs to some load testing.
  
  We can just have one single job that handle daily and weekly jobs, we have a few code that is being repeated in this 2 jobs, but as the other options, need to investigate it further. 
  
  We can have one single query that handle with this data, but, from an other point of view, having 2 jobs might be easier to understand and debug if needed, although each disbursement operation is being enqueued.

  Also need to add tests for the logic os jobs execution, actually this was tested manually.
  
  Add more logging error treatment to the application in general, need to investigate it further the possible error points
  Add more tests to the application in general, need to explore possible situations.

## Disbursed data from csv


| Year | Number of disbursements | Amount disbursed to merchants | Amount of order fees |  No of monthly fees charged(From minimum monthly fee)|Amount of monthly fee charged (From minimum monthly fee)
|------|-------------------------|-------------------------------| -------------------- |------------------------------------------------------|--------------------------------------------------------
| 2022 | 1435                    | 16.121.678,41€                | 149.967,98€          | 3808                                                 | 82.110,00€
| 2023 | 995                     | 17.038.683,80€                | 156.617,93           | 1248                                                 | 26.910,00 €