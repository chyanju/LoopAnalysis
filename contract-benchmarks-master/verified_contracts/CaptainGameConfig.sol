pragma solidity ^0.4.18;
/* ==================================================================== */
/* Copyright (c) 2018 The Priate Conquest Project.  All rights reserved.
/* 
/* https://www.pirateconquest.com One of the world's slg games of blockchain 
/*  
/* authors <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="96e4f7fff8efd6faffe0f3e5e2f7e4b8f5f9fb">[email protected]</a>/<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="7b3114151502553d0e3b17120d1e080f1a0955181416">[email protected]</a>&#13;
/*                 &#13;
/* ==================================================================== */&#13;
contract CaptainGameConfig {&#13;
  address owner;&#13;
  struct Card {&#13;
    uint32 cardId;&#13;
    uint32 color;&#13;
    uint32 atk;&#13;
    uint32 defense;&#13;
    uint32 stype;&#13;
    uint256 price;&#13;
  }&#13;
&#13;
  /** mapping**/&#13;
  mapping(uint256 =&gt; Card) private cardInfo;  //normal card&#13;
  mapping(uint32 =&gt; uint256) public captainIndxToCount;&#13;
  mapping(uint32 =&gt; uint32) private calfactor;&#13;
  mapping(uint32 =&gt; bool) private unitSellable;&#13;
&#13;
  function CaptainGameConfig() public {&#13;
    owner = msg.sender;&#13;
&#13;
    // level 1 config&#13;
    cardInfo[1] = Card(1, 2, 220, 80, 1, 0.495 ether);&#13;
    cardInfo[2] = Card(2, 1, 130, 20, 2, 0.2475 ether);&#13;
    cardInfo[3] = Card(3, 4, 520, 80, 2, 0.99 ether);&#13;
    cardInfo[4] = Card(4, 3, 240, 210, 3, 0.7425 ether);&#13;
    cardInfo[5] = Card(5, 4, 320, 280, 3, 0.99 ether);&#13;
    cardInfo[6] = Card(6, 4, 440, 160, 1, 0.99 ether);&#13;
    cardInfo[7] = Card(7, 2, 260, 40, 2, 0.495 ether);&#13;
    cardInfo[8] = Card(8, 3, 330, 120, 1, 0.7425 ether);&#13;
    cardInfo[9] = Card(9, 1, 130, 20, 2, 0.2475 ether);&#13;
&#13;
    captainIndxToCount[1] = 100000; // for count limited&#13;
    captainIndxToCount[2] = 100000;&#13;
    captainIndxToCount[3] = 30;&#13;
    captainIndxToCount[4] = 100000;&#13;
    captainIndxToCount[5] = 30;&#13;
    captainIndxToCount[6] = 30;&#13;
    captainIndxToCount[7] = 100000;&#13;
    captainIndxToCount[8] = 100000;&#13;
    captainIndxToCount[9] = 100000;&#13;
&#13;
    calfactor[1] = 80; //for atk_min &amp; atk_max calculate&#13;
    calfactor[2] = 85;&#13;
    calfactor[3] = 90;&#13;
    calfactor[4] = 95;&#13;
&#13;
    unitSellable[3] = true;&#13;
    unitSellable[5] = true;&#13;
    unitSellable[6] = true;&#13;
  }&#13;
&#13;
  function getCardInfo(uint32 cardId) external constant returns (uint32,uint32,uint32,uint32,uint32,uint256,uint256) {&#13;
    return (&#13;
      cardInfo[cardId].color,&#13;
      cardInfo[cardId].atk, &#13;
      cardInfo[cardId].atk*calfactor[cardInfo[cardId].color]/100,&#13;
      cardInfo[cardId].atk*(200-cardInfo[cardId].color)/100,&#13;
      cardInfo[cardId].defense,&#13;
      cardInfo[cardId].price,&#13;
      captainIndxToCount[cardId]);&#13;
  }    &#13;
  &#13;
  function getCardType(uint32 cardId) external constant returns (uint32){&#13;
    return cardInfo[cardId].stype;&#13;
  }&#13;
  function addCard(uint32 id, uint32 color, uint32 atk,uint32 defense, uint32 stype, uint256 price) external {&#13;
    require(msg.sender == owner);&#13;
    cardInfo[id] = Card(id, color, atk, defense, stype, price);&#13;
  }&#13;
  &#13;
  function setCaptainIndexToCount(uint32 _id, uint256 _count) external {&#13;
    require(msg.sender == owner);&#13;
    captainIndxToCount[_id] = _count;&#13;
  }&#13;
  function getCaptainIndexToCount(uint32 _id) external constant returns (uint256) {&#13;
    return captainIndxToCount[_id];&#13;
  }&#13;
&#13;
  function getCalFactor(uint32 _color) external constant returns (uint32) {&#13;
    return calfactor[_color];&#13;
  }&#13;
  function setCalFactor(uint32 _color, uint32 _factor) external {&#13;
    require(msg.sender == owner);&#13;
    calfactor[_color] = _factor;&#13;
  }&#13;
&#13;
  function getSellable(uint32 _captainId) external constant returns (bool) {&#13;
    return unitSellable[_captainId];&#13;
  }&#13;
&#13;
  function setSellable(uint32 _captainId,bool b) external {&#13;
    require(msg.sender == owner);&#13;
    unitSellable[_captainId] = b;&#13;
  }&#13;
&#13;
  function getLevelConfig(uint32 cardId, uint32 level) external view returns (uint32 atk,uint32 defense,uint32 atk_min,uint32 atk_max) {&#13;
    if (level==1) {&#13;
      atk = cardInfo[cardId].atk;&#13;
      defense = cardInfo[cardId].defense;&#13;
    } else if (level==2) {&#13;
      atk = cardInfo[cardId].atk * 150/100;&#13;
      defense = cardInfo[cardId].defense * 150/100;&#13;
    } else if (level&gt;=3) {&#13;
      atk = cardInfo[cardId].atk * (level-1) - (level-2) * cardInfo[cardId].atk * 150/100;&#13;
      defense = cardInfo[cardId].defense * 150/100;&#13;
    }&#13;
    atk_min = calfactor[cardInfo[cardId].color]/100;&#13;
    atk_max = atk*(200-cardInfo[cardId].color)/100;&#13;
  }&#13;
}