// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);

        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);

        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
      
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library Strings {
    bytes16 private constant alphabet = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = alphabet[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface IAccessControl {
    function hasRole(bytes32 role, address account) external view returns (bool);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function grantRole(bytes32 role, address account) external;
    function revokeRole(bytes32 role, address account) external;
    function renounceRole(bytes32 role, address account) external;
}

abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping (address => bool) members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    modifier onlyRole(bytes32 role) {
        _checkRole(role, _msgSender());
        _;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId
            || super.supportsInterface(interfaceId);
    }

    function hasRole(bytes32 role, address account) public view override returns (bool) {
        return _roles[role].members[account];
    }

    function _checkRole(bytes32 role, address account) internal view {
        if(!hasRole(role, account)) {
            revert(string(abi.encodePacked(
                "AccessControl: account ",
                Strings.toHexString(uint160(account), 20),
                " is missing role ",
                Strings.toHexString(uint256(role), 32)
            )));
        }
    }

    function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
        return _roles[role].adminRole;
    }

    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) internal {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// mixed supply / access control
contract Labrador is AccessControl, IERC20, IERC20Metadata
{
    using SafeMath for uint256;

    using Address for address;

    bytes32 public constant Fee_ROLE = keccak256("Fee_ROLE");  

    mapping (address => uint256) private _reflectionOwned;

    mapping (address => uint256) private _tokenOwned;

    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;

    address[] private _excluded;
   
    uint256 private constant MAX = ~uint256(0);

    uint256 private _token_supply = 10 ** 26;

    uint256 private _reflection_supply = (MAX - (MAX % _token_supply));

    uint256 private _transfer_fee_to_share;

    uint256 private _transfer_fee_to_share_reflection;

    uint256 private _transfer_fee_to_burn;

    string private _name = "Labrador";

    string private _symbol = "lador";

    uint8 private _decimals = 9;

    uint256 public _transfer_fee_share_ratio = 20;

    uint256 public _transfer_fee_burn_ratio = 10;

    uint256 public _transfer_fee_ratio = 30;
        
    uint256 public _maxTransferAmount = 10 ** 24;

    address public _fund_address;

    constructor () {
         address _sender = _msgSender();

         _setupRole(DEFAULT_ADMIN_ROLE, _sender);

         _reflectionOwned[_sender] = _reflection_supply.div(2);

        _excluded.push(address(0));

         _isExcluded[address(0)] = true;
         
        _isExcludedFromFee[_sender] = true;

         _reflectionOwned[address(0)] = _reflection_supply.div(2);

         _tokenOwned[address(0)] = _token_supply.div(2);
        
        emit Transfer(address(0), _sender, _token_supply.div(2));

        emit Transfer(address(this), address(0), _token_supply.div(2));
    }

    // erc20 begin
    function name() public override view returns (string memory) {
        return _name;
    }

    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    function decimals() public override view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _token_supply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) 
        {
           return _tokenOwned[account];
        }

        return tokenFromReflection(_reflectionOwned[account]);
    }  

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);

        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
     
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
    
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    function totalTransferFee() public view returns (uint256) {
        return _transfer_fee_to_burn + _transfer_fee_to_share;
    }

    function totalTransferFeeToShare() public view returns (uint256) {
        return _transfer_fee_to_share;
    }

    function totalTransferFeeToBurn() public view returns (uint256) {
        return _transfer_fee_to_burn;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function excludeFromReward(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!_isExcluded[account], "Account is already excluded");

        if(_reflectionOwned[account] > 0) {
            _tokenOwned[account] = tokenFromReflection(_reflectionOwned[account]);
        }

        _isExcluded[account] = true;

        _excluded.push(account);
    } 

    function includeInReward(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_isExcluded[account], "Account is already included");

        for (uint256 i = 0; i < _excluded.length; i++) 
        {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];

                _tokenOwned[account] = 0;

                _isExcluded[account] = false;

                _excluded.pop();

                break;
            }
        }
    }

    function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee) public view returns(uint256) {
        require(tokenAmount <= _token_supply, "Amount must be less than supply");
           
        (uint256 reflectionAmount,uint256 reflectionTransferAmount,,,) = _calValues(tokenAmount, 0);

        if (!deductTransferFee) {
            return reflectionAmount;
        } else {
            return reflectionTransferAmount;
        }
    }

    function tokenFromReflection(uint256 reflectionAmount) public view returns(uint256) {
        require(reflectionAmount <= _reflection_supply, "Amount must be less than total reflections");

        uint256 currentRate =  _getRate();

        return reflectionAmount.div(currentRate);
    }

    function excludeFromFee(address account) public onlyRole(Fee_ROLE) {
        _isExcludedFromFee[account] = true;
    }
    
    function includeInFee(address account) public onlyRole(Fee_ROLE) {
        _isExcludedFromFee[account] = false;
    }
    
    function setTransferFeePercent(uint256 shareRatio, uint256 burnRatio) external onlyRole(Fee_ROLE) {
      _transfer_fee_share_ratio = shareRatio;

      _transfer_fee_burn_ratio = burnRatio;

      _transfer_fee_ratio = burnRatio + shareRatio;
    }
   
    function setMaxTransferPercent(uint256 maxTransferPercent) external onlyRole(Fee_ROLE) {
        _maxTransferAmount = _token_supply.mul(maxTransferPercent).div(100);
    }
    
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _transfer(address from,  address to, uint256 amount) private 
    {
        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");

        if(!hasRole(DEFAULT_ADMIN_ROLE, from) && !hasRole(DEFAULT_ADMIN_ROLE, to))
            require(amount <= _maxTransferAmount, "Transfer amount exceeds the max transfer amount.");
 
        uint256 feeFree = 0;              

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
           feeFree = 1;
        }
        
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, feeFree);
     }

    function _tokenTransfer(address sender, address recipient, uint256 tokenAmount, uint256 feeFree) private
    {
        (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionTransferFee, uint256 tokenTransferAmount, uint256 tokenTransferFee) = _calValues(tokenAmount, feeFree);
  
        _reflectionOwned[sender] = _reflectionOwned[sender].sub(reflectionAmount);

        _reflectionOwned[recipient] = _reflectionOwned[recipient].add(reflectionTransferAmount);

        if(_isExcluded[sender])
        {
          _tokenOwned[sender] = _tokenOwned[sender].sub(tokenAmount);
        }

        if(_isExcluded[recipient])
        {
           _tokenOwned[recipient] = _tokenOwned[recipient].add(tokenTransferAmount);
        }

        if(tokenTransferFee > 0)
        {
           _reflectFee(reflectionTransferFee, tokenTransferFee);
        }

        emit Transfer(sender, recipient, tokenTransferAmount);
    }

  function _reflectFee(uint256 reflectionFee, uint256 tokenFee) private {
        uint256 reflection_fee_burn = reflectionFee.div(_transfer_fee_ratio).mul(_transfer_fee_burn_ratio);
 
        uint256 reflection_fee_share = reflectionFee.div(_transfer_fee_ratio).mul(_transfer_fee_share_ratio);

        uint256 token_fee_burn = tokenFee.mul(_transfer_fee_burn_ratio).div(_transfer_fee_ratio);

        uint256 token_fee_share = tokenFee.mul(_transfer_fee_share_ratio).div(_transfer_fee_ratio);

        _reflectionOwned[address(0)] = _reflectionOwned[address(0)].add(reflection_fee_burn);

        _tokenOwned[address(0)] = _tokenOwned[address(0)].add(token_fee_burn);

        _transfer_fee_to_share_reflection = _transfer_fee_to_share_reflection.add(reflection_fee_share);

       _transfer_fee_to_share = _transfer_fee_to_share.add(token_fee_share);

       _transfer_fee_to_burn = _transfer_fee_to_burn.add(token_fee_burn);
   
       if (token_fee_burn > 0)
          emit Transfer(_msgSender(), address(0), token_fee_burn);
    }

    function _calValues(uint256 tokenAmount, uint feeFree) private view returns (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionTransferFee, uint256 tokenTransferAmount, uint256 tokenTransferFee) {
         if( feeFree == 0)
         {
            tokenTransferFee = _calTransferFee(tokenAmount);
         }

         tokenTransferAmount = tokenAmount.sub(tokenTransferFee);

         uint256 currentRate = _getRate();

         reflectionAmount = tokenAmount.mul(currentRate);

         reflectionTransferFee = tokenTransferFee.mul(currentRate);

         reflectionTransferAmount = reflectionAmount.sub(reflectionTransferFee);

        return (reflectionAmount, reflectionTransferAmount, reflectionTransferFee, tokenTransferAmount, tokenTransferFee);
    }

    function _calTransferFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_transfer_fee_ratio).div(1000);
    }

    function _getRate() private view returns(uint256) {
        (uint256 reflectionSupply, uint256 tokenSupply) = _getCurrentSupply();

       reflectionSupply = reflectionSupply.sub(_transfer_fee_to_share_reflection); 

       tokenSupply = tokenSupply; 

        return reflectionSupply.div(tokenSupply);
    } 

    function _getCurrentSupply() private view returns(uint256,  uint256) {
        uint256 reflectionSupply = _reflection_supply;

        uint256 tokenSupply = _token_supply;      

        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_reflectionOwned[_excluded[i]] >= reflectionSupply || _tokenOwned[_excluded[i]] >= tokenSupply)
            {
               return (_reflection_supply, _token_supply);
            }

            reflectionSupply = reflectionSupply.sub(_reflectionOwned[_excluded[i]]);

            tokenSupply = tokenSupply.sub(_tokenOwned[_excluded[i]]);
        }

        return (reflectionSupply, tokenSupply);
    } 
}

 
