// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";


contract KokoToken is ERC20, Ownable {
    using SafeMath for uint256;
    address[] internal stakeholders;

    uint256 public rate = 1000;
    uint constant gracePeriod = 1 hours;
    uint constant weekly = 7 days;

    mapping(address => uint256) internal stakes;
    mapping(address => uint256) internal rewards;
    mapping(address => uint256) internal locked;
    //Just added
    mapping(address => uint) public rewardDueDate;


    constructor() ERC20("KokoToken", "KTK") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    // set token purchase rate working
    function modifyTokenBuyPrice(uint256 newRate) public onlyOwner {
        rate = newRate;
    }
    
    // purchase tokens working
    function buyToken(address buyer) public payable returns (uint256 amount) {
        require (msg.value > 0, "You need money for this transaction");
        amount = msg.value * rate;
        _mint(buyer, amount);
    }


    // STAKEHOLDER FUNCTIONS
    // to add a stakeholder
    function addStakeholder(address staker) private {
        (bool _checkStakeholder, ) = checkStakeholder(staker);
        if(!_checkStakeholder) stakeholders.push(staker);
    }

    // to remove a stakeholder
    function removeStakeholder(address staker) private {
        (bool _checkStakeholder, uint256 verified) = checkStakeholder(staker);
        if(_checkStakeholder){
            stakeholders[verified] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

    // to verify stakeholder
    function checkStakeholder(address stakeholder_address) public view returns(bool, uint256) {
        for (
            uint256 verified;
            verified < stakeholders.length;
            verified++){
                if (stakeholder_address == stakeholders[verified]) return (true, verified);
            }
        return (false, 0);
    }

    function allStakeholders() public view onlyOwner returns ( address [] memory ) {
        return stakeholders;
    }
    
    // for stakeholder to add a stake
    function createStake(uint256 stakeamount) public {
        require(stakeamount > 0, "Stake Amount cannot be zero");
        stakeamount = stakeamount *1e18;
        _burn(msg.sender, stakeamount);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        // require (balanceOf[msg.sender] >= (stakeamount), "Insuffient funds" );
        stakes[msg.sender] = stakes[msg.sender].add(stakeamount);
        rewardDueDate[msg.sender] = block.timestamp + weekly;
    }

    function checkRewardDueDate (address staker) public view returns (uint) {
        return rewardDueDate[staker];
    }

    // 6 hours period
    modifier checkDueDateReached () {
        require (block.timestamp >= rewardDueDate[msg.sender], "Reward Date not reached");
        _;
    }

    // for stakeholder to remove a stake
    function removeStake(uint256 stakeamount) public {
        stakeamount = stakeamount *1e18;
        stakes[msg.sender] = stakes[msg.sender].sub(stakeamount);
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, stakeamount);
    }

    // check amount staked by a stakeholder
    function stakeOf() public view returns (uint256) {
        return stakes[msg.sender];
    }

    // check total of all stakes
    function combinedStake() public view returns(uint256) {
        uint256 totalStakes = 0;
        for (
            uint256 verified = 0; 
            verified < stakeholders.length; 
            verified += 1){
                totalStakes = totalStakes.add(stakes[stakeholders[verified]]);
            }
        return totalStakes;
    }

    // calculate reward per stakeholder 
    function calculateStakeReward(address staker) public view returns(uint256) {
        return stakes[staker] * 1 / 100;
    }

    function claimReward() public checkDueDateReached {
        if (block.timestamp >= rewardDueDate[msg.sender] + gracePeriod) {
            rewardDueDate[msg.sender] = block.timestamp + weekly;
        } else {
            uint amount = calculateStakeReward(msg.sender);
            rewardDueDate[msg.sender] = block.timestamp + weekly;
            _mint(msg.sender, amount);
        }
        
    }

     /* ========== EVENTS ========== */

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardsDurationUpdated(uint256 newDuration);
    event Recovered(address token, uint256 amount);
    
}