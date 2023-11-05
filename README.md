# README



2 - We can do the net amount and comission as SQL, might be faster, need to check
3 - I created a disbursement item with each disbursement value from each order, and also a disbursement sum, because for reporting it might be good, as we wont need to do queries in all disbursement items all the time, and i prefer to not store in order, so we can separate things, from the database point of view, we will need to have a belongs_to optional, it was also a choice that i think, but in the end i decided to add another model

Year | Number of disursements | Amount of order fees |  Number of monthly fees charged(From minimum monthly fee) |  Amount of monthly fee charged (From minimum monthly fee)

2022