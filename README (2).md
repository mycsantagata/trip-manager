# TripManager Smart Contract

The TripManager is an Ethereum-based smart contract that enables trip management. Users can create, book or cancel new trips. The contract will lock the amount of the trip onto the customer's balance until it runs out and is then transferred to the supplier's balance.

## Project Structure

The project is composed of

1. **TripLib.sol**: A library containing the trip structure and some auxiliary functions for trip management.

2. **TripManager.sol**: The main contract using the TripLib library to implement trip management and payment management.

## Testing the contract

1. Deploying the TripManager contract on an Ethereum-compatible network.
2. Interacting with the contract using a user interface or through direct calls to contract functions.

Testnet Sepholia contract address: **0x616e5db331a3e9c4aef500ee354d97aff86a314d**

## User Management
Each wallet is registered as a provider or as a customer depending on which action is performed for the first time. In the case of creation, you are registered as a provider, and in the case of booking as a customer

## Main Features

### Creating a New Trip

A provider can create a new trip by specifying the name, location, start date, end date and price of the trip.

### Booking a Trip

A customer may book an existing trip by providing the index number of the trip and the correct amount. The booking can only take place if the trip is not already booked and the payment is for the same amount as the selected trip.

### Close a Trip

A provider may close a trip that has been booked. The customer's payment is transferred to the provider's balance.

### Cancellation of a Booking

A customer may cancel a booking before the start of the trip. Payment is returned to the customer

### Withdrawal of Balance by Provider

A provider may withdraw the accumulated balance from the closure of booked trips.

## Author

- [Carmine Santagata]
