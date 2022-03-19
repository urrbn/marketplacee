const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test", function (){

  before(async function () {
    this.NftFactory = await ethers.getContractFactory("Nft")
    this.Marketplace = await ethers.getContractFactory("Marketplace")
    this.Token = await ethers.getContractFactory("Token")
    this.signers = await ethers.getSigners()
    this.owner = this.signers[0]
    this.alice = this.signers[1]
    this.bob = this.signers[2]

    this.nftFactory = await this.NftFactory.deploy()
    this.marketplace = await this.Marketplace.deploy()
    this.token = await this.Token.deploy()
    
    

    await this.nftFactory.deployed()
    await this.marketplace.deployed()
    await this.token.deployed()
    

    await console.log(this.nftFactory.address, 'factory')
    await console.log(this.marketplace.address, 'mp')
    await console.log(this.token.address, 'token')
    

  })

  it("should mint nft", async function() {

    await this.nftFactory.createItem("1")
    await this.nftFactory.createItem("2")
    await this.nftFactory.createItem("3")
    await this.nftFactory.createItem("4")

    let uri = await this.nftFactory.tokenURI(1)
    
    console.log(uri)

    await expect(uri).to.equal("1")
    expect(await this.nftFactory.ownerOf(1)).to.equal(this.owner.address)

  })
  

  it("should place an offer", async function() {
    await this.token.transfer(this.alice.address, ethers.utils.parseEther("100000"))
    await this.nftFactory.approve(this.marketplace.address, 2)
    await this.token.connect(this.alice).approve(this.marketplace.address, ethers.utils.parseEther("1000000"))

    let alicebalB4 = await this.token.balances(this.alice.address)
    let ownerB4Sell = await this.nftFactory.ownerOf(2)
   

    console.log(ethers.utils.formatEther(alicebalB4), 'BEFORE')
    console.log(ownerB4Sell, 'BEFORE')
    
    
    await this.marketplace.listItem(2, this.nftFactory.address, 10000)
    await this.marketplace.connect(this.alice).buyItem(0)

    let ownerAfterSell = await this.nftFactory.ownerOf(2)
    let alicebalAfter = await this.token.balances(this.alice.address)
    

    console.log(ethers.utils.formatEther(alicebalAfter), 'AFTER')
    console.log(ownerAfterSell, 'AFTER')
    

    
    await expect(ownerB4Sell).to.equal(this.owner.address)
    await expect(ownerAfterSell).to.equal(this.alice.address)
    
    
  })

});

