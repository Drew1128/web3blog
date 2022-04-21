//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {
    string public name;
    address public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    struct Post {
        uint id;
        string title;
        string content; // This is going to be the IPFS hash where the content is stored
        bool published;
    }

    mapping(uint => Post) public idToPosts;
    mapping(string => Post) public hashToPosts;

    event PostCreated(uint id, string title, string hash);
    event PostUpdated(uint id, string title, string hash, bool published);

   constructor(string memory _name) {
       console.log("Deploying blog with name: ",  _name);
        name = _name;
        owner = msg.sender;
   }

   function updateName(string memory _name) public {
       name = _name;
   }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function fetchPost( string memory hash) public view returns (Post memory) {
        return hashToPosts[hash];
    }

    function createPost(string memory title, string memory hash) public onlyOwner {
        _postIds.increment();
        uint postId = _postIds.current();
        Post storage post = idToPosts[postId];
        post.id = postId;
        post.title = title;
        post.published = true;
        post.content = hash;
        hashToPosts[hash] = post;
        emit PostCreated(postId, title, hash);
    }

    function updatePost(uint postId, string memory title, string memory hash, bool published) public onlyOwner {
        Post storage post = idToPosts[postId];
        post.title = title;
        post.published = published;
        post.content = hash;
        hashToPosts[hash] = post;
        emit PostUpdated(post.id, title, hash, published);
    }

    function fetchPosts() public view returns (Post[] memory) {
        uint itemCount = _postIds.current();

        Post[] memory posts = new Post[](itemCount);
        for (uint i = 0; i < itemCount; i++) {
            uint currentId = i + 1;
            Post storage currentItem = idToPosts[currentId];
            posts[i] = currentItem;
        }
        return posts;
    }

    
}
