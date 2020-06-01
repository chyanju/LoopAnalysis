pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------------------------
// PublickOffering by Xender Limited.
// An ERC20 standard
//
// author: Xender Team
// Contact: s<span class="__cf_email__" data-cfemail="fd988f8b949e98bd85989399988fd39e9290">[email protected]</span>&#13;
// ----------------------------------------------------------------------------------------------&#13;
&#13;
contract Authority {&#13;
    &#13;
    // contract administrator&#13;
    address public owner;&#13;
    &#13;
    // publick offering beneficiary&#13;
    address public beneficiary;&#13;
    &#13;
    // publick offering has closed&#13;
    bool public closed = false;&#13;
    &#13;
    // allowed draw ETH&#13;
    bool public allowDraw = true;&#13;
    &#13;
     modifier onlyOwner() { &#13;
        require(msg.sender == owner);&#13;
        _;&#13;
    }&#13;
    &#13;
    modifier onlyBeneficiary(){&#13;
        require(msg.sender == beneficiary);&#13;
        _;&#13;
    }&#13;
    &#13;
    modifier alloweDrawEth(){&#13;
       if(allowDraw){&#13;
           _;&#13;
       }&#13;
    }&#13;
    &#13;
    function Authority() public {&#13;
        owner = msg.sender;&#13;
        beneficiary = msg.sender;&#13;
    }&#13;
    &#13;
    function open() public onlyOwner {&#13;
        closed = false;&#13;
    }&#13;
    &#13;
    function close() public onlyOwner {&#13;
        closed = true;&#13;
    }&#13;
    &#13;
    function setAllowDrawETH(bool _allow) public onlyOwner{&#13;
        allowDraw = _allow;&#13;
    }&#13;
}&#13;
&#13;
contract PublickOffering is Authority {&#13;
    &#13;
    // invest info&#13;
    struct investorInfo{&#13;
        address investor;&#13;
        uint256 amount;&#13;
        uint    utime;&#13;
        bool    hadback;&#13;
    }&#13;
    &#13;
    // investors bills&#13;
    mapping(uint =&gt; investorInfo) public bills;&#13;
    &#13;
    // recive ETH total amount&#13;
    uint256 public totalETHSold;&#13;
    &#13;
    // investor number&#13;
    uint public lastAccountNum;&#13;
    &#13;
    // min ETH&#13;
    uint256 public constant minETH = 0.2 * 10 ** 18;&#13;
    &#13;
    // max ETH&#13;
    uint256 public constant maxETH = 20 * 10 ** 18;&#13;
    &#13;
    event Bill(address indexed sender, uint256 value, uint time);&#13;
    event Draw(address indexed _addr, uint256 value, uint time);&#13;
    event Back(address indexed _addr, uint256 value, uint time);&#13;
    &#13;
    function PublickOffering() public {&#13;
        totalETHSold = 0;&#13;
        lastAccountNum = 0;&#13;
    }&#13;
    &#13;
    function () public payable {&#13;
        if(!closed){&#13;
            require(msg.value &gt;= minETH);&#13;
            require(msg.value &lt;= maxETH);&#13;
            bills[lastAccountNum].investor = msg.sender;&#13;
            bills[lastAccountNum].amount = msg.value;&#13;
            bills[lastAccountNum].utime = now;&#13;
            totalETHSold += msg.value;&#13;
            lastAccountNum++;&#13;
            Bill(msg.sender, msg.value, now);&#13;
        } else {&#13;
            revert();&#13;
        }&#13;
    }&#13;
    &#13;
    function drawETH(uint256 amount) public onlyBeneficiary alloweDrawEth{&#13;
        beneficiary.transfer(amount);&#13;
        Draw(msg.sender, amount, now);&#13;
    }&#13;
    &#13;
    function backETH(uint pos) public onlyBeneficiary{&#13;
        if(!bills[pos].hadback){&#13;
            require(pos &lt; lastAccountNum);&#13;
            bills[pos].investor.transfer(bills[pos].amount);&#13;
            bills[pos].hadback = true;&#13;
            Back(bills[pos].investor, bills[pos].amount, now);&#13;
        }&#13;
    }&#13;
    &#13;
}