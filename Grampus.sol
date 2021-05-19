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

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IMdexFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function feeToRate() external view returns (uint256);

    function initCodeHash() external view returns (bytes32);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function setFeeToRate(uint256) external;

    function setInitCodeHash(bytes32) external;

    function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);

    function pairFor(address tokenA, address tokenB) external view returns (address pair);

    function getReserves(address tokenA, address tokenB) external view returns (uint256 reserveA, uint256 reserveB);

    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);

    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
}

interface IMdexPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;

    function price(address token, uint256 baseDecimal) external view returns (uint256);

    function initialize(address, address) external;
}

interface IMdexRouter {
    function factory() external pure returns (address);

    function WHT() external pure returns (address);

    function swapMining() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);

    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

// mixed supply / Ownable
contract Grampus is Ownable, IERC20, IERC20Metadata
{
    using SafeMath for uint256;

    using Address for address;

    address public constant DeadAddress = 0x000000000000000000000000000000000000dEaD;

    IMdexRouter public immutable mdexRouter;

    address public immutable mdexPair;

    mapping (address => uint256) private _reflectionOwned;

    mapping (address => uint256) private _tokenOwned;

    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;

    address[] private _excluded;
   
    uint256 private constant MAX = ~uint256(0);

    uint256 private _token_supply = 10 ** 24;

    uint256 private _reflection_supply = (MAX - (MAX % _token_supply));

    uint256 private _transfer_fee_to_share;

    uint256 private _transfer_fee_to_share_reflection;

    uint256 private _transfer_fee_to_burn;

    string private _name = "Grampus";

    string private _symbol = "graus";

    uint8 private _decimals = 9;

    uint256 public _transfer_fee_share_ratio = 18;

    uint256 public _transfer_fee_burn_ratio = 12;

    uint256 public _transfer_fee_ratio = 30;
        
    uint256 public _maxTransferAmount = 5 * 10 ** 22;

    constructor () {
         address _sender = _msgSender();

         _reflectionOwned[_sender] = _reflection_supply.div(2);

        _excluded.push(DeadAddress);

         _isExcluded[DeadAddress] = true;
         
        _isExcludedFromFee[_sender] = true;

         _reflectionOwned[DeadAddress] = _reflection_supply.div(2);

         _tokenOwned[DeadAddress] = _token_supply.div(2);

        IMdexRouter _router = IMdexRouter(0xED7d5F38C79115ca12fe6C0041abb22F0A06C300);

        mdexPair = IMdexFactory(_router.factory()).createPair(address(this), _router.WHT());

        mdexRouter = _router;
        
        emit Transfer(address(0), _sender, _token_supply.div(2));

        emit Transfer(address(this), DeadAddress, _token_supply.div(2));
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

    function excludeFromReward(address account) public onlyOwner{
        require(!_isExcluded[account], "Account is already excluded");

        if(_reflectionOwned[account] > 0) {
            _tokenOwned[account] = tokenFromReflection(_reflectionOwned[account]);
        }

        _isExcluded[account] = true;

        _excluded.push(account);
    } 

    function includeInReward(address account) external onlyOwner {
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

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }
    
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    
    function setTransferFeePercent(uint256 shareRatio, uint256 burnRatio) external onlyOwner {
      _transfer_fee_share_ratio = shareRatio;

      _transfer_fee_burn_ratio = burnRatio;

      _transfer_fee_ratio = burnRatio + shareRatio;
    }
   
    function setMaxTransferPercent(uint256 maxTransferPercent) external onlyOwner {
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

        if(from != owner() && to != owner())
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

        _reflectionOwned[DeadAddress] = _reflectionOwned[DeadAddress].add(reflection_fee_burn);

        _tokenOwned[DeadAddress] = _tokenOwned[DeadAddress].add(token_fee_burn);

        _transfer_fee_to_share_reflection = _transfer_fee_to_share_reflection.add(reflection_fee_share);

       _transfer_fee_to_share = _transfer_fee_to_share.add(token_fee_share);

       _transfer_fee_to_burn = _transfer_fee_to_burn.add(token_fee_burn);
   
       if (token_fee_burn > 0)
          emit Transfer(_msgSender(), DeadAddress, token_fee_burn);
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

 
