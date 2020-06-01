/*
 *      ##########################################
 *      ##########################################
 *      ###                                    ###
 *      ###          𝐏𝐥𝐚𝐲 & 𝐖𝐢𝐧 𝐄𝐭𝐡𝐞𝐫          ###
 *      ###                 at                 ###
 *      ###          𝐄𝐓𝐇𝐄𝐑𝐀𝐅𝐅𝐋𝐄.𝐂𝐎𝐌          ###
 *      ###                                    ###
 *      ##########################################
 *      ##########################################
 *
 *      Welcome to the temporary 𝐄𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞 𝐃𝐢𝐬𝐛𝐮𝐫𝐬𝐚𝐥 𝐂𝐨𝐧𝐭𝐫𝐚𝐜𝐭. 
 *      It's currently a place-holder whose only functionality is 
 *      forward-compatability with the soon-to-be-deployed actual 
 *      contract. 
 *
 *      Its job is to accrue funds generated by 𝐄𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞 to pay out 
 *      as 𝐝𝐢𝐯𝐢𝐝𝐞𝐧𝐝𝐬 to the 𝐋𝐎𝐓 token holders. But that's only the 
 *      start. 𝐋𝐎𝐓 token holders will form a 𝐃𝐀𝐎 who own and run 
 *      𝐄𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞, and will be able to vote of the future of the 
 *      platform via this very contract! They'll also get to say where 
 *      𝐄𝐭𝐡𝐑𝐞𝐥𝐢𝐞𝐟 - Etheraffle's charitable arm - funds go to as well. 
 *      All whilst earning a 𝐝𝐢𝐯𝐢𝐝𝐞𝐧𝐝 from ticket sales of 𝐄𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞! 
 *
 *
 *                     𝐄𝐱𝐜𝐢𝐭𝐢𝐧𝐠 𝐭𝐢𝐦𝐞𝐬 - 𝐬𝐭𝐚𝐲 𝐭𝐮𝐧𝐞𝐝!
 *
 *
 *      Learn more and take part at 𝐡𝐭𝐭𝐩𝐬://𝐞𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞.𝐜𝐨𝐦/𝐢𝐜𝐨
 *      Or if you want to chat to us you have loads of options:
 *      On 𝐓𝐞𝐥𝐞𝐠𝐫𝐚𝐦 @ 𝐡𝐭𝐭𝐩𝐬://𝐭.𝐦𝐞/𝐞𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞
 *      Or on 𝐓𝐰𝐢𝐭𝐭𝐞𝐫 @ 𝐡𝐭𝐭𝐩𝐬://𝐭𝐰𝐢𝐭𝐭𝐞𝐫.𝐜𝐨𝐦/𝐞𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞
 *      Or on 𝐑𝐞𝐝𝐝𝐢𝐭 @ 𝐡𝐭𝐭𝐩𝐬://𝐞𝐭𝐡𝐞𝐫𝐚𝐟𝐟𝐥𝐞.𝐫𝐞𝐝𝐝𝐢𝐭.𝐜𝐨𝐦
 *
 */
pragma solidity^0.4.21;

contract ReceiverInterface {
    function receiveEther() external payable {}
}

contract EtheraffleDisbursal {

    bool    upgraded;
    address etheraffle;
    /**
     * @dev  Modifier to prepend to functions rendering them
     *       only callable by the Etheraffle multisig address.
     */
    modifier onlyEtheraffle() {
        require(msg.sender == etheraffle);
        _;
    }
    event LogEtherReceived(address fromWhere, uint howMuch, uint atTime);
    event LogUpgrade(address toWhere, uint amountTransferred, uint atTime);
    /**
     * @dev   Constructor - sets the etheraffle var to the Etheraffle
     *        managerial multisig account.
     *
     * @param _etheraffle   The Etheraffle multisig account
     */
    function EtheraffleDisbursal(address _etheraffle) {
        etheraffle = _etheraffle;
    }
    /**
     * @dev   Upgrade function transferring all this contract's ether
     *        via the standard receive ether function in the proposed
     *        new disbursal contract.
     *
     * @param _addr    The new disbursal contract address.
     */
    function upgrade(address _addr) onlyEtheraffle external {
        upgraded = true;
        emit LogUpgrade(_addr, this.balance, now);
        ReceiverInterface(_addr).receiveEther.value(this.balance)();
    }
    /**
     * @dev   Standard receive ether function, forward-compatible
     *        with proposed future disbursal contract.
     */
    function receiveEther() payable external {
        emit LogEtherReceived(msg.sender, msg.value, now);
    }
    /**
     * @dev   Set the Etheraffle multisig contract address, in case of future
     *        upgrades. Only callable by the current Etheraffle address.
     *
     * @param _newAddr   New address of Etheraffle multisig contract.
     */
    function setEtheraffle(address _newAddr) onlyEtheraffle external {
        etheraffle = _newAddr;
    }
    /**
     * @dev   selfDestruct - used here to delete this placeholder contract
     *        and forward any funds sent to it on to the final disbursal
     *        contract once it is fully developed. Only callable by the
     *        Etheraffle multisig.
     *
     * @param _addr   The destination address for any ether herein.
     */
    function selfDestruct(address _addr) onlyEtheraffle {
        require(upgraded);
        selfdestruct(_addr);
    }
    /**
     * @dev   Fallback function that accepts ether and announces its
     *        arrival via an event.
     */
    function () payable external {
    }
}