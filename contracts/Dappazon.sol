// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
	address public owner;
	
	mapping(uint256=>Item) public items;
	mapping(address => uint256) public orderCount;
	mapping(address=>mapping(uint256=>Order)) public orders;

	event List(string name ,uint256 cost, uint256 quantity);
	event Buy(address buyer,uint256 orderId,uint256 itemId);
	struct Item{

		uint256 id;
		string name;
		string category;
		string image;
		uint256 cost;
		uint256 rating;
		uint256 stock;
	}


	struct Order{
		uint256 time;
		Item item;


	}

modifier onlyOwner(){

require(msg.sender==owner);

_;}

	constructor(){
	owner=msg.sender;
	}

// List products
	function list(
	uint256 _id,
	string memory _name,
	string memory _category,
	string memory _image,
	uint256 _cost,
	uint256 _rating,
	uint256 _stock
	) public onlyOwner{
	


	//create item struct

	Item memory item = Item(_id,_name,_category,_image,_cost,_rating,_stock);


//save item struct

	items[_id]=item;

//emitting a event 
emit List(_name,_cost,_stock);
	

	}

// buy products


function buy(uint256 _id) public payable{
//create an order

//fetch item
Item storage item= items[_id];

require(msg.value>=items[_id].cost);

//fetch item
Order memory new_order=Order(block.timestamp,items[_id]);
orderCount[msg.sender]++;

orders[msg.sender][orderCount[msg.sender]]=new_order;

//subtract stock



items[_id].stock=item.stock-1;

//emit event

 emit Buy(msg.sender,orderCount[msg.sender],item.id);



}



//withdraw funds
	function withdraw()public onlyOwner{

(bool success,) = owner.call{value:address(this).balance}("");
require(success);

	}




}

