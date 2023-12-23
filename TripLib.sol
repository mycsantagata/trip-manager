// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library TripLib{

    struct Trip {
        string name;
        string location;
        uint256 startDate;
        uint256 endDate;
        uint256 price;
        address addressProvider;
        bool isBooked;
    }

    event bookingTrip(address customerBooking, uint256 tripIndex);

    function createTrip(string memory _name, string memory  _location, uint256 _startDate,
     uint256 _endDate, uint256 _price, address _addressProvider) internal pure returns(Trip memory){
        return Trip({
            name: _name,
            location: _location,
            startDate: _startDate,
            endDate: _endDate,
            price: _price,
            addressProvider: _addressProvider,
            isBooked: false
        });
    }

    function logTrip(Trip storage trip, address _customerBooking, uint256 _tripIndex) internal {
        require(!trip.isBooked, "Trip is already booked");
        trip.isBooked = true;
        emit bookingTrip(_customerBooking, _tripIndex);
    
    }
    
}


