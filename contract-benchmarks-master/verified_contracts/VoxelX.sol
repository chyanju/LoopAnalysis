// Created by Mohamed Sharaf
// EMail: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="94f9d4f9fbfcf5f9f1f0e7fcf5e6f5f2bafaf1e0">[email protected]</a>&#13;
// Date: 15/04/2018&#13;
pragma solidity ^0.4.21;&#13;
&#13;
contract VoxelX {&#13;
    /* Constructor */&#13;
    function VoxelX() public {&#13;
    }&#13;
}&#13;
&#13;
library SafeMath {&#13;
&#13;
    /**&#13;
    * @dev Multiplies two numbers, throws on overflow.&#13;
    */&#13;
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        if (a == 0) {&#13;
            return 0;&#13;
        }&#13;
        uint256 c = a * b;&#13;
        assert(c / a == b);&#13;
        return c;&#13;
    }&#13;
&#13;
    /**&#13;
    * @dev Integer division of two numbers, truncating the quotient.&#13;
    */&#13;
    function div(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0&#13;
        uint256 c = a / b;&#13;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold&#13;
        return c;&#13;
    }&#13;
&#13;
    /**&#13;
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).&#13;
    */&#13;
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        assert(b &lt;= a);&#13;
        return a - b;&#13;
    }&#13;
&#13;
    /**&#13;
    * @dev Adds two numbers, throws on overflow.&#13;
    */&#13;
    function add(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        uint256 c = a + b;&#13;
        assert(c &gt;= a);&#13;
        return c;&#13;
    }&#13;
}&#13;
&#13;
contract Ownable {&#13;
    address public owner;&#13;
&#13;
&#13;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);&#13;
&#13;
&#13;
    /**&#13;
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender&#13;
     * account.&#13;
     */&#13;
    function Ownable() public {&#13;
        owner = msg.sender;&#13;
    }&#13;
&#13;
    /**&#13;
     * @dev Throws if called by any account other than the owner.&#13;
     */&#13;
    modifier onlyOwner() {&#13;
        require(msg.sender == owner);&#13;
        _;&#13;
    }&#13;
&#13;
    /**&#13;
     * @dev Allows the current owner to transfer control of the contract to a newOwner.&#13;
     * @param newOwner The address to transfer ownership to.&#13;
     */&#13;
    function transferOwnership(address newOwner) public onlyOwner {&#13;
        require(newOwner != address(0));&#13;
        emit OwnershipTransferred(owner, newOwner);&#13;
        owner = newOwner;&#13;
    }&#13;
&#13;
}&#13;
&#13;
contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}&#13;
&#13;
contract Token is Ownable {&#13;
    // Public variables of the token&#13;
    string public name = "VoxelX GRAY";&#13;
    string public symbol = "GRAY";&#13;
    uint8 public decimals = 18;&#13;
    uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens;&#13;
&#13;
    // This creates an array with all balances&#13;
    mapping(address =&gt; uint256) public balanceOf;&#13;
    mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;&#13;
&#13;
    // This generates a public event on the blockchain that will notify clients&#13;
    event Transfer(address indexed from, address indexed to, uint256 value);&#13;
&#13;
    // This notifies clients about the amount burnt&#13;
    event Burn(address indexed from, uint256 value);&#13;
&#13;
    /**&#13;
     * Constructor function&#13;
     * Initializes contract with initial supply tokens to the creator of the contract&#13;
     */&#13;
    function Token() public {&#13;
        balanceOf[msg.sender] = totalSupply;&#13;
    }&#13;
&#13;
    /**&#13;
     * Internal transfer, only can be called by this contract&#13;
     */&#13;
    function _transfer(address _from, address _to, uint _value) internal {&#13;
        // Prevent transfer to 0x0 address. Use burn() instead&#13;
        require(_to != 0x0);&#13;
        // Check if the sender has enough&#13;
        require(balanceOf[_from] &gt;= _value);&#13;
        // Check for overflows&#13;
        require(balanceOf[_to] + _value &gt; balanceOf[_to]);&#13;
        // Save this for an assertion in the future&#13;
        uint previousBalances = balanceOf[_from] + balanceOf[_to];&#13;
        // Subtract from the sender&#13;
        balanceOf[_from] -= _value;&#13;
        // Add the same to the recipient&#13;
        balanceOf[_to] += _value;&#13;
        emit Transfer(_from, _to, _value);&#13;
        // Asserts are used to use static analysis to find bugs in your code. They should never fail&#13;
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);&#13;
    }&#13;
&#13;
    /**&#13;
     * Transfer tokens&#13;
     *&#13;
     * Send `_value` tokens to `_to` from your account&#13;
     *&#13;
     * @param _to The address of the recipient&#13;
     * @param _value the amount to send&#13;
     */&#13;
    function transfer(address _to, uint256 _value) public {&#13;
        _transfer(msg.sender, _to, _value);&#13;
    }&#13;
&#13;
    /**&#13;
     * Transfer tokens from other address&#13;
     *&#13;
     * Send `_value` tokens to `_to` on behalf of `_from`&#13;
     *&#13;
     * @param _from The address of the sender&#13;
     * @param _to The address of the recipient&#13;
     * @param _value the amount to send&#13;
     */&#13;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {&#13;
        require(_value &lt;= allowance[_from][msg.sender]);&#13;
        // Check allowance&#13;
        allowance[_from][msg.sender] -= _value;&#13;
        _transfer(_from, _to, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    /**&#13;
     * Set allowance for other address&#13;
     *&#13;
     * Allows `_spender` to spend no more than `_value` tokens on your behalf&#13;
     *&#13;
     * @param _spender The address authorized to spend&#13;
     * @param _value the max amount they can spend&#13;
     */&#13;
    function approve(address _spender, uint256 _value) public&#13;
    returns (bool success) {&#13;
        allowance[msg.sender][_spender] = _value;&#13;
        return true;&#13;
    }&#13;
&#13;
    /**&#13;
     * Set allowance for other address and notify&#13;
     *&#13;
     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it&#13;
     *&#13;
     * @param _spender The address authorized to spend&#13;
     * @param _value the max amount they can spend&#13;
     * @param _extraData some extra information to send to the approved contract&#13;
     */&#13;
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)&#13;
    public&#13;
    returns (bool success) {&#13;
        tokenRecipient spender = tokenRecipient(_spender);&#13;
        if (approve(_spender, _value)) {&#13;
            spender.receiveApproval(msg.sender, _value, this, _extraData);&#13;
            return true;&#13;
        }&#13;
    }&#13;
&#13;
    /**&#13;
     * Destroy tokens&#13;
     *&#13;
     * Remove `_value` tokens from the system irreversibly&#13;
     *&#13;
     * @param _value the amount of money to burn&#13;
     */&#13;
    function burn(uint256 _value) public returns (bool success) {&#13;
        require(balanceOf[msg.sender] &gt;= _value);&#13;
        // Check if the sender has enough&#13;
        balanceOf[msg.sender] -= _value;&#13;
        // Subtract from the sender&#13;
        totalSupply -= _value;&#13;
        // Updates totalSupply&#13;
        emit Burn(msg.sender, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    /**&#13;
     * Destroy tokens from other account&#13;
     *&#13;
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.&#13;
     *&#13;
     * @param _from the address of the sender&#13;
     * @param _value the amount of money to burn&#13;
     */&#13;
    function burnFrom(address _from, uint256 _value) public returns (bool success) {&#13;
        require(balanceOf[_from] &gt;= _value);&#13;
        // Check if the targeted balance is enough&#13;
        require(_value &lt;= allowance[_from][msg.sender]);&#13;
        // Check allowance&#13;
        balanceOf[_from] -= _value;&#13;
        // Subtract from the targeted balance&#13;
        allowance[_from][msg.sender] -= _value;&#13;
        // Subtract from the sender's allowance&#13;
        totalSupply -= _value;&#13;
        // Update totalSupply&#13;
        emit Burn(_from, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    // Change Name&#13;
    function setName(string _name) public onlyOwner {&#13;
        name = _name;&#13;
    }&#13;
}&#13;
&#13;
contract Crowdsale is Ownable {&#13;
    using SafeMath for uint256;&#13;
&#13;
    // Token being sold&#13;
    Token public token;&#13;
&#13;
    // start and end timestamps where investments are allowed (both inclusive)&#13;
    uint256 public startTime = 1524202200;&#13;
    uint256 public endTime = 1525973400;&#13;
&#13;
    // Crowdsale cap (how much can be raised total)&#13;
    uint256 public cap = 25000 ether;&#13;
&#13;
    // Address where funds are collected&#13;
    address public wallet = 0x0a46e230869d60e737147d986Fc2973Cad379B4e;&#13;
&#13;
    // Predefined rate of token to Ethereum (1/rate = crowdsale price)&#13;
    uint256 public rate = 200000;&#13;
&#13;
    // Min/max purchase&#13;
    uint256 public minSale = 0.0025 ether;&#13;
    uint256 public maxSale = 1000 ether;&#13;
&#13;
    // amount of raised money in wei&#13;
    uint256 public weiRaised;&#13;
    mapping(address =&gt; uint256) public contributions;&#13;
&#13;
    // Finalization flag for when we want to withdraw the remaining tokens after the end&#13;
    bool public finished = false;&#13;
&#13;
    /**&#13;
     * event for token purchase logging&#13;
     * @param purchaser who paid for the tokens&#13;
     * @param beneficiary who got the tokens&#13;
     * @param value weis paid for purchase&#13;
     * @param amount amount of tokens purchased&#13;
     */&#13;
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);&#13;
&#13;
    function Crowdsale(address _token) public {&#13;
        require(_token != address(0));&#13;
        owner = msg.sender;&#13;
        token = Token(_token);&#13;
    }&#13;
&#13;
    // fallback function can be used to buy tokens&#13;
    function() external payable {&#13;
        buyTokens(msg.sender);&#13;
    }&#13;
&#13;
&#13;
    // low level token purchase function&#13;
    function buyTokens(address beneficiary) public payable {&#13;
        require(beneficiary != address(0));&#13;
        require(validPurchase());&#13;
&#13;
        uint256 weiAmount = msg.value;&#13;
&#13;
        // calculate token amount to be created&#13;
        uint256 tokens = getTokenAmount(weiAmount);&#13;
&#13;
        // update total and individual contributions&#13;
        weiRaised = weiRaised.add(weiAmount);&#13;
        contributions[beneficiary] = contributions[beneficiary].add(weiAmount);&#13;
&#13;
        // Send tokens&#13;
        token.transfer(beneficiary, tokens);&#13;
        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);&#13;
&#13;
        // Send funds&#13;
        wallet.transfer(msg.value);&#13;
    }&#13;
&#13;
    // Returns true if crowdsale event has ended&#13;
    function hasEnded() public view returns (bool) {&#13;
        bool capReached = weiRaised &gt;= cap;&#13;
        bool endTimeReached = now &gt; endTime;&#13;
        return capReached || endTimeReached || finished;&#13;
    }&#13;
&#13;
    // Bonuses for larger purchases (in hundredths of percent)&#13;
    function bonusPercentForWeiAmount(uint256 weiAmount) public pure returns (uint256) {&#13;
        if (weiAmount &gt;= 500 ether) return 1000;&#13;
        // 10%&#13;
        if (weiAmount &gt;= 250 ether) return 750;&#13;
        // 7.5%&#13;
        if (weiAmount &gt;= 100 ether) return 500;&#13;
        // 5%&#13;
        if (weiAmount &gt;= 50 ether) return 375;&#13;
        // 3.75%&#13;
        if (weiAmount &gt;= 15 ether) return 250;&#13;
        // 2.5%&#13;
        if (weiAmount &gt;= 5 ether) return 125;&#13;
        // 1.25%&#13;
        return 0;&#13;
        // 0% bonus if lower than 5 eth&#13;
    }&#13;
&#13;
    // Returns you how much tokens do you get for the wei passed&#13;
    function getTokenAmount(uint256 weiAmount) internal view returns (uint256) {&#13;
        uint256 tokens = weiAmount.mul(rate);&#13;
        uint256 bonus = bonusPercentForWeiAmount(weiAmount);&#13;
        tokens = tokens.mul(10000 + bonus).div(10000);&#13;
        return tokens;&#13;
    }&#13;
&#13;
    // Returns true if the transaction can buy tokens&#13;
    function validPurchase() internal view returns (bool) {&#13;
        bool withinPeriod = now &gt;= startTime &amp;&amp; now &lt;= endTime;&#13;
        bool moreThanMinPurchase = msg.value &gt;= minSale;&#13;
        bool lessThanMaxPurchase = contributions[msg.sender] + msg.value &lt;= maxSale;&#13;
        bool withinCap = weiRaised.add(msg.value) &lt;= cap;&#13;
&#13;
        return withinPeriod &amp;&amp; moreThanMinPurchase &amp;&amp; lessThanMaxPurchase &amp;&amp; withinCap &amp;&amp; !finished;&#13;
    }&#13;
&#13;
    // Escape hatch in case the sale needs to be urgently stopped&#13;
    function endSale() public onlyOwner {&#13;
        finished = true;&#13;
        // send remaining tokens back to the owner&#13;
        uint256 tokensLeft = token.balanceOf(this);&#13;
        token.transfer(owner, tokensLeft);&#13;
    }&#13;
&#13;
    // set rate for gray so we can handle time based sales rates&#13;
    function setRate(uint256 _rate) public onlyOwner {&#13;
        rate = _rate;&#13;
    }&#13;
&#13;
    // set start time&#13;
    function setStartTime(uint256 _startTime) public onlyOwner {&#13;
        startTime = _startTime;&#13;
    }&#13;
&#13;
    // set end time&#13;
    function setEndTime(uint256 _endTime) public onlyOwner {&#13;
        endTime = _endTime;&#13;
    }&#13;
&#13;
    // set finalized time so contract can be paused&#13;
    function setFinished(bool _finished) public onlyOwner {&#13;
        finished = _finished;&#13;
    }&#13;
&#13;
}