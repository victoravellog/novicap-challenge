# README

## Description
Novicap code challenge. Physical Store checkout system.

## Requirements
- Ruby 3.0.2

## Installation
- Clone the repository

## Usage
- Run `ruby main.rb <json-price-rules-filepath> [items argument list]` to run the program.
- Example 
```sh
ruby main.rb json-testfile.json VOUCHER TSHIRT VOUCHER VOUCHER MUG TSHIRT TSHIRT
```

`json-price-rules-filepath` must be a JSON file with a structure similar to:

The discount types supported are `x-for-y` and `bulk`. If no discount is specified, the item will be charged at its regular price.

```json
{
	"VOUCHER": {
		"price": 5.0, // Required
		"discount": {
			"type": "x-for-y",
			"x": 2,
			"y": 1
		}
	},
	"TSHIRT": {
		"price": 20.0,
		"discount": {
			"type": "bulk",
			"quantity": 3,
			"fixed_price": 19.0
		}
	},
	"MUG": {
		"price": 7.5
	}
}
```

- Response example

Success response:
```sh
Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
Total: 74.5€
```

Error response:
```sh
Could not calculate total. Please check the price rules file and the items to be scanned.
```
