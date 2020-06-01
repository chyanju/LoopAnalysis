// Timelock
// lock withdrawal for a set time period
// @authors:
// Cody Burns <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="7a1e15140e0a1b1413193a19151e030d180f08140954191517">[email protected]</a>&gt;&#13;
// license: Apache 2.0&#13;
// version:&#13;
&#13;
pragma solidity ^0.4.19;&#13;
&#13;
// Intended use: lock withdrawal for a set time period&#13;
//&#13;
// Status: functional&#13;
// still needs:&#13;
// submit pr and issues to https://github.com/realcodywburns/&#13;
//version 0.2.0&#13;
&#13;
&#13;
contract timelock {&#13;
&#13;
////////////////&#13;
//Global VARS//////////////////////////////////////////////////////////////////////////&#13;
//////////////&#13;
&#13;
    uint public freezeBlocks = 5;       //number of blocks to keep a lockers (5)&#13;
&#13;
///////////&#13;
//MAPPING/////////////////////////////////////////////////////////////////////////////&#13;
///////////&#13;
&#13;
    struct locker{&#13;
      uint freedom;&#13;
      uint bal;&#13;
    }&#13;
    mapping (address =&gt; locker) public lockers;&#13;
&#13;
///////////&#13;
//EVENTS////////////////////////////////////////////////////////////////////////////&#13;
//////////&#13;
&#13;
    event Locked(address indexed locker, uint indexed amount);&#13;
    event Released(address indexed locker, uint indexed amount);&#13;
&#13;
/////////////&#13;
//MODIFIERS////////////////////////////////////////////////////////////////////&#13;
////////////&#13;
&#13;
//////////////&#13;
//Operations////////////////////////////////////////////////////////////////////////&#13;
//////////////&#13;
&#13;
/* public functions */&#13;
    function() payable public {&#13;
        locker storage l = lockers[msg.sender];&#13;
        l.freedom =  block.number + freezeBlocks; //this will reset the freedom clock&#13;
        l.bal = l.bal + msg.value;&#13;
&#13;
        Locked(msg.sender, msg.value);&#13;
    }&#13;
&#13;
    function withdraw() public {&#13;
        locker storage l = lockers[msg.sender];&#13;
        require (block.number &gt; l.freedom &amp;&amp; l.bal &gt; 0);&#13;
&#13;
        // avoid recursive call&#13;
&#13;
        uint value = l.bal;&#13;
        l.bal = 0;&#13;
        msg.sender.transfer(value);&#13;
        Released(msg.sender, value);&#13;
    }&#13;
&#13;
////////////&#13;
//OUTPUTS///////////////////////////////////////////////////////////////////////&#13;
//////////&#13;
&#13;
////////////&#13;
//SAFETY ////////////////////////////////////////////////////////////////////&#13;
//////////&#13;
&#13;
&#13;
}