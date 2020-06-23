## Origin Backend Take-Home Assignment

For this assignment, we created a API endpoint that receives a JSON payload with the user information and returns her risk profile (JSON again)

---

### Ruby version

`2.5.3`

---

#### Base URL

The base URL of the API is `/api/v1/`. Feel free to test the API using [Postman](https://www.getpostman.com/) or in the console directly.

---


## Set Up

To start the project to you will need to run the follow commands

```bash
bundle install
rails db:setup
```
---

## How to run the test suite

You can test the application with the

```bash
rspec
```

---

## How to run developemnt environment

You can run the application with the

```bash
rails server
```
---

### The risk algorithm

First, it calculates the base score by summing the answers from the risk questions, resulting in a number ranging from 0 to 3. Then, it applies the following rules to determine a risk score for each line of insurance*.

1. If the user doesn’t have income, vehicles or houses, she is ineligible for disability, auto, and home insurance, respectively.
2. If the user is over 60 years old, she is ineligible for disability and life insurance.
3. If the user is under 30 years old, deduct 2 risk points from all lines of insurance. If she is between 30 and 40 years old, deduct 1.
4. If her income is above $200k, deduct 1 risk point from all lines of insurance.
5. If the user's house is mortgaged, add 1 risk point to her home score and add 1 risk point to her disability score.
6. If the user has dependents, add 1 risk point to both the disability and life scores.
7. If the user is married, add 1 risk point to the life score and remove 1 risk point from disability.
8. If the user's vehicle was produced in the last 5 years, add 1 risk point to that vehicle’s score.

This algorithm results in a final score for each line of insurance, which should be processed using the following ranges:

- 0 and below maps to “economic”.
- 1 and 2 maps to “regular”.
- 3 and above maps to “responsible”.


#### Post a Insurance Plans `POST 'insurance_plans'`

It will calculate the  insurance plans on our API's database

In the request body, you have to send age, dependents, house ownership status, income, marital status, risk questions and vehicle year, in the following JSON format:

```json
{
  "age": 35,
  "dependents": 2,
  "house": {"ownership_status": "owned"},
  "income": 0,
  "marital_status": "married",
  "risk_questions": [0, 1, 0],
  "vehicle": {"year": 2018}
}
```

The API inputs needs to be pass as the follow rules:

- age as an integer equal or greater than 0
- dependents as an integer equal or greater than 0
- house as hash object or null
- house ownership can be "owned" or "mortgaged" only.
- income as an integer equal or greater than 0
- risk questions an array with 3 booleans , eg: [true, true, false] or [1, 0, 1].
- vehicle as hash object or null
- vehicle year as an integer equal or greater than 0.

Obs: *If you pass vehicle or house as any object diferent than array or hash it will consider the field as null*


The API will respond with the insurance plans for this profile  with the status 200, in the following JSON format:

```json
{
    "auto": "regular",
    "disability": "ineligible",
    "home": "economic",
    "life": "regular"
}
```


If something get wrong the API will respond the error with the status 400 , in the following JSON format:

```json
{
  "error": {
    "age": [
      "must be greater than or equal to 0"
    ],
    "dependents": [
      "must be greater than or equal to 0"
    ],
    "income": [
      "must be an integer"
    ],
    "marital_status": [
      "value is not in the list"
    ],
    "risk_questions": [
      "is not a array of booleans"
    ],
    "house.ownership_status": [
      "value is not in the list"
    ],
    "vehicle.year": [
      "is not a number"
    ],
    "house": [
      "it alowed only one house"
    ],
    "vehicle": [
      "it alowed only one vehicle"
    ]
  }
}
```

