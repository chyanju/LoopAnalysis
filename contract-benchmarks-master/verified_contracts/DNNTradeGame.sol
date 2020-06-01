pragma solidity ^0.4.15;

/// @title DNNToken contract - Main DNN contract
/// @author Dondrey Taylor - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="23474c4d4751465a63474d4d0d4e46474a42">[email protected]</a>&gt;&#13;
contract DNNToken {&#13;
    enum DNNSupplyAllocations {&#13;
        EarlyBackerSupplyAllocation,&#13;
        PRETDESupplyAllocation,&#13;
        TDESupplyAllocation,&#13;
        BountySupplyAllocation,&#13;
        WriterAccountSupplyAllocation,&#13;
        AdvisorySupplyAllocation,&#13;
        PlatformSupplyAllocation&#13;
    }&#13;
    function balanceOf(address who) constant public returns (uint256);&#13;
    function issueTokens(address, uint256, DNNSupplyAllocations) public pure returns (bool) {}&#13;
}&#13;
&#13;
/// @title DNNTradeGame contract&#13;
/// @author Dondrey Taylor - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="adc9c2c3c9dfc8d4edc9c3c383c0c8c9c4cc">[email protected]</a>&gt;&#13;
contract DNNTradeGame {&#13;
&#13;
  // DNN Token&#13;
  DNNToken public dnnToken;&#13;
&#13;
  // Owner&#13;
  address owner = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;&#13;
&#13;
	// Event that gets triggered each time a user&#13;
	// sends a redemption transaction to this smart contract&#13;
  event Winner(address indexed to, uint256 dnnBalance, uint256 dnnWon);&#13;
  event Trader(address indexed to, uint256 dnnBalance);&#13;
&#13;
  // Owner&#13;
  modifier onlyOwner() {&#13;
      require (msg.sender == owner);&#13;
      _;&#13;
  }&#13;
&#13;
  // Decide DNN Winner&#13;
  function pickWinner(address winnerAddress, uint256 dnnToReward, DNNToken.DNNSupplyAllocations allocationType)&#13;
    public&#13;
    onlyOwner&#13;
  {&#13;
      uint256 winnerDNNBalance = dnnToken.balanceOf(msg.sender);&#13;
&#13;
      if (!dnnToken.issueTokens(winnerAddress, dnnToReward, allocationType)) {&#13;
          revert();&#13;
      }&#13;
      else {&#13;
          emit Winner(winnerAddress, winnerDNNBalance, dnnToReward);&#13;
      }&#13;
  }&#13;
&#13;
  // Constructor&#13;
  constructor() public&#13;
  {&#13;
      dnnToken = DNNToken(0x9D9832d1beb29CC949d75D61415FD00279f84Dc2);&#13;
  }&#13;
&#13;
	// Handles incoming transactions&#13;
	function () public payable {&#13;
&#13;
      // Sender address&#13;
      address dnnHolder = msg.sender;&#13;
&#13;
      // Sender balance&#13;
      uint256 dnnHolderBalance = dnnToken.balanceOf(msg.sender);&#13;
&#13;
      // Event to reference for picking a winner&#13;
      emit Trader(dnnHolder, dnnHolderBalance);&#13;
&#13;
      if (msg.value &gt; 0) {&#13;
          owner.transfer(msg.value);&#13;
      }&#13;
	}&#13;
}