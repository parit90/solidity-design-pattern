// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
//0xd9145CCE52D386f254917e481eB44e9943F39138
import "@ensdomains/ens/contracts/ENSRegistry.sol";
import "@ensdomains/ens/contracts/ENS.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./EnumerableSet.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/AddrResolver.sol";

//import "./MyResolver.sol";
import "./RestrictedResolver.sol";
import "./ISystemRegistrar.sol";
import "./OrganizationFactory.sol";
import "./TokenFactory.sol";
import "./WalletFactory.sol";
import "hardhat/console.sol";

contract SystemRegistrar is ISystemRegistrar, SystemRoles{
    	ENS public ens;
		using EnumerableSet for EnumerableSet.AddressSet;
		EnumerableSet.AddressSet organizations;
		
		// namehash("contracts")
		bytes32 public constant CONTRACTS_NODE = 0x7834ba3f1c01ec58f9c09c64f953152574267a74f46d0b60675abd2a214e4013;

        // namehash("access-control.contracts")
        bytes32 public constant ACCESS_CONTROL_NODE = 0x9487981f759f184cea1a85d55b7e4d713b1f5b481d9896e45e12b9b66d68a4d6;

		// namehash("org")
		bytes32 public constant ORGANIZATION_NODE = 0xa191b3258591469a2def6d7c4d6134b24408f9642d8b1da3530d1d668083070e;

		// namehash("token-factory.contracts")
		bytes32 public constant TOKEN_FACTORY_NODE = 0xbe29e5f45821190fe7b9875e9a5733b748136309df2838dbdd9a7401b10527e7;
        
		// keccak256("contracts")
    	bytes32 public constant CONTRACTS_LABEL = 0x2c3fc6f0fbafda851ab189a57d8b6d637fc05d74783bfd979a60cc05d3b6729b;

	    // keccak256("org")
	    bytes32 public constant ORGANIZATION_LABEL = 0x5768f996d53a8ccd5c92503083fe22a3e05791d56896c81d7c0713c3c42e5dee;

    	// keccak256("access-control")
	    bytes32 public constant ACCESS_CONTROL_LABEL = 0x64617ee3c6a0361a9a8223334a8f2dacd3fe2087125e4536dd1d8f73178934e8;

        // keccak256("token-factory")
	    bytes32 public constant TOKEN_FACTORY_LABEL = 0x81414736efd327bbb07a0a0551fa5a7c7b1d56284388cde5c3cf2d17ba3c98f5;

        // keccak256("wallet-factory")
	    bytes32 public constant WALLET_FACTORY_LABEL = 0x6256ca28978f52b8b8954688f04ed8db42dde197a1ca97218e2e18c0aaf1ba04;
        
        // keccak256("organization-factory")
    	bytes32 public constant ORGANIZATION_FACTORY_LABEL = 0x86bb7dd5210f2c294f7f63218eaeb0d89ece7e0e339d7d601ad2b2a06f6639cb;

        modifier onlyAdminManager(address _ac) {
            console.log("Is it called? 1", msg.sender);
			console.log("Is it called? 2", _ac);
		    require(this.accessControl().hasRole(ADMIN_MANAGER_ROLE, _ac), "SystemRegistry: not authorised");
		    _;
	    }
		


    function initialize() public {
        bool initialized;
        console.log("Address of SystemRegistrar ...call from intialize", address(this));
        require(!initialized);
        TokenFactory _tokenFactory = new TokenFactory();
        WalletFactory _walletFactory = new WalletFactory(address(this));
        OrganizationFactory _organizationFactory = new OrganizationFactory(address(this));
        SystemAccessControl _accessControl = new SystemAccessControl(msg.sender);
        
        ens = new ENSRegistry();
        console.log("The Ens = ",address(ens));
		//MySimpleResolver myresolver = new MySimpleResolver();
        RestrictedResolver contractsResolver = new RestrictedResolver(this, ADMIN_MANAGER_ROLE);
		RestrictedResolver organizationResolver = new RestrictedResolver(this, ADMIN_MANAGER_ROLE);
        
        /**
			function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl);
			
			Sets the owner, resolver and TTL for a subdomain, creating it if necessary. 
			This function is offered for convenience, and permits setting all three fields without 
			first transferring ownership of the subdomain to the caller.
		 */

        ens.setSubnodeRecord(0x0, CONTRACTS_LABEL, address(this), address(contractsResolver), 0);
		ens.setSubnodeRecord(0x0, ORGANIZATION_LABEL, address(this), address(organizationResolver), 0);

        _registerAddress(ACCESS_CONTROL_LABEL, address(_accessControl), CONTRACTS_NODE);
		_registerAddress(TOKEN_FACTORY_LABEL, address(_tokenFactory), CONTRACTS_NODE);
		_registerAddress(WALLET_FACTORY_LABEL, address(_walletFactory), CONTRACTS_NODE);
		_registerAddress(ORGANIZATION_FACTORY_LABEL, address(_organizationFactory), CONTRACTS_NODE);
        
    }
    //parit
    // function HasRole (bytes32 ADMIN_MANAGER_ROLE) public{
    //     bool _hasrole = hasRole(ADMIN_MANAGER_ROLE, msg.sender);
    //     console.log("_hasRole", _hasrole);
    // }

		//function with basic wire
    function accessControl() public override view returns (SystemAccessControl) {
		address acAddress = addr(ACCESS_CONTROL_NODE);
		require(acAddress != address(0x0), "SystemRegistrar: SystemAccessControl is not set");
		return SystemAccessControl(acAddress);
	}

		//function with basic wire
    function addr(bytes32 node) public view returns (address) {
		AddrResolver res = AddrResolver(ens.resolver(node));
		// If no resolver is set, return the empty address
		if (address(res) == address(0x0)) {
			return address(0x0);
		}
		return res.addr(node);
	}

    // function doesRecordExists(bytes32 _node) public view returns (bool) {
    //     bytes32 targetNode = keccak256(abi.encodePacked(bytes32(0), CONTRACTS_LABEL));
    //     bool result = ens.recordExists(targetNode);
    //     console.log("The result is....",result);
    // }
	
	//function with basic wire
    function _registerAddress(
		bytes32 label,
		address targetAddress,
		bytes32 node
	) internal {
		bytes32 targetNode = keccak256(abi.encodePacked(node, label));
		if (!ens.recordExists(targetNode)) {
			_registerRecord(label, node);
		}
		RestrictedResolver(ens.resolver(node)).setAddr(targetNode, targetAddress);
	}
	
		//function with basic wire
	function _registerRecord(bytes32 label, bytes32 node) internal {
		// Query the Resolver for the `node` domain
		address res = ens.resolver(node);
		// Add a new record for the given label
		ens.setSubnodeRecord(node, label, address(this), res, 0);
	}

	function registerOrganization(address _ac, bytes32 label, address organization) public override onlyAdminManager(_ac) {
		_registerAddress(label, organization, ORGANIZATION_NODE);
		EnumerableSet.add(organizations, organization);
	}

		// @inheritdoc ISystemRegistrar
	function getOrganizationLength() public view override returns (uint256) {
		return EnumerableSet.length(organizations);
	}

	function tokenFactory() public view override returns(ITokenFactory){
		address tfAddress = addr(TOKEN_FACTORY_NODE);
		return ITokenFactory(tfAddress);
	}
}