// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TripLib.sol";

contract TripManager{

    using TripLib for *;

    TripLib.Trip[] private trips;

    mapping(address => uint) private providerBalance;
    mapping(address => uint) private customerBalance;
    mapping(uint => address) private bookingCustomer;
    mapping(address => bool) private isProvider;
    mapping(address => bool) private isCustomer;

    event TripAdded(uint256 indexed tripIndex, TripLib.Trip);
    event TripCancelled(address indexed customer, uint256 indexed tripIndex);
    event TripCompleted(address indexed customer, uint256 indexed tripIndex);
    event Withdrawal(address indexed provider, uint256 amount);

    modifier onlyCustomer(){
        require(isCustomer[msg.sender], "Only the customer can access this function");
        _;
    }

    modifier onlyProvider(){
        require(isProvider[msg.sender],"Only the provider can access this function");
        _;
    }

    modifier tripExist(uint256 _tripIndex){
        require(_tripIndex < trips.length, "Trip not found");
        _;
    }

    //it allows you to create a new trip, the address calling the function is registered as the provider
    function addTrip(string memory _name, string memory _location, uint256 _startDate,
    uint256 _endDate, uint256 _price) external
    {
        //Checking that the address is not already registered as a customer
        require(isCustomer[msg.sender] == false,"User is registered as a customer, cannot book trips");
        TripLib.Trip memory trip = TripLib.createTrip(
            _name,
            _location,
            _startDate,
            _endDate,
            _price,
            msg.sender
        );

        trips.push(trip);
        isProvider[msg.sender] = true;
        emit TripAdded(trips.length -1, trip);
    }

    //Allows you to book a trip that has been created, the address is registered as a customer
    function bookTrip(uint256 _tripIndex, uint256 _currentDate) external payable tripExist(_tripIndex) {
        TripLib.Trip storage trip = trips[_tripIndex];
        //Checking that the address is not already registered as a provider
        require(isProvider[msg.sender] == false, "Only the customer can access this function");
        require(trip.price == msg.value, "Invalid amount");
        require(!trip.isBooked, "Trip is already booked");
        require(_currentDate < trip.endDate, "The selected trip has already ended");
        
        bookingCustomer[_tripIndex] = msg.sender;
        customerBalance[msg.sender] += msg.value;
        isCustomer[msg.sender] = true;
        trip.logTrip(msg.sender, _tripIndex);
    }

    function closeTrip(uint256 _tripIndex, uint256 _currentDate) external onlyProvider tripExist(_tripIndex) payable{
        TripLib.Trip storage trip = trips[_tripIndex];
        require(trip.isBooked, "The trip has not been booked yet");
        require(_currentDate >= trip.endDate, "The trip is not yet over");

        customerBalance[bookingCustomer[_tripIndex]] -= trip.price;
        providerBalance[trip.addressProvider] += trip.price; 
        emit TripCompleted(bookingCustomer[_tripIndex], _tripIndex);
    }

    function cancelTrip(uint _tripIndex, uint256 _currentDate) external onlyCustomer tripExist(_tripIndex) payable{
        TripLib.Trip storage trip = trips[_tripIndex];
        require(_currentDate < trip.startDate,"Trip is already started");

        customerBalance[msg.sender] -= trip.price;
        payable(msg.sender).transfer(trip.price);
        trip.isBooked = false;
        emit TripCancelled(msg.sender, _tripIndex);
    }

    function withdrawBalanceProvider() external onlyProvider{
        require(providerBalance[msg.sender] > 0, "insufficient balance");
        uint256 amount = providerBalance[msg.sender];
        payable(msg.sender).transfer(amount);  
        emit Withdrawal(msg.sender, amount); 
    }

    function getAllTrips() external view returns(TripLib.Trip[] memory) {
        return trips;
    }

    function getCustomerBalance() external view onlyCustomer returns(uint256){
        return customerBalance[msg.sender];
    }

    function getProviderBalance() external view onlyProvider returns(uint256){
        return providerBalance[msg.sender];
    }
}