const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test", function (){

  before(async function () {
    this.Marketplace = await ethers.getContractFactory("Marketplace")
    this.Token = await ethers.getContractFactory("Token")
    this.signers = await ethers.getSigners()
    this.owner = this.signers[0]
    this.alice = this.signers[1]
    this.bob = this.signers[2]

    this.marketplace = await this.Marketplace.deploy()
    this.token = await this.Token.deploy()
  
    await this.marketplace.deployed()
    await this.token.deployed()
    
    await console.log(this.marketplace.address, 'mp')
    await console.log(this.token.address, 'token')
    

  })

  it("should mint nft", async function() {

    await this.marketplace.createItem("1")
    await this.marketplace.createItem("2")
    await this.marketplace.createItem("3")
    await this.marketplace.createItem("4")
    let uri = await this.marketplace.tokenURI(1)
    
    console.log(uri)

    await expect(uri).to.equal("1")
    expect(await this.marketplace.ownerOf(1)).to.equal(this.owner.address)

  })
  

  it("should place an offer and buy", async function() {
    await this.token.transfer(this.alice.address, ethers.utils.parseEther("100000"))
    await this.token.transfer(this.bob.address, ethers.utils.parseEther("100000"))
    await this.marketplace.approve(this.marketplace.address, 1)
    await this.token.connect(this.alice).approve(this.marketplace.address, ethers.utils.parseEther("1000000"))
    await this.token.connect(this.bob).approve(this.marketplace.address, ethers.utils.parseEther("1000000"))

    let alicebalB4 = await this.token.balances(this.alice.address)
    let ownerB4Sell = await this.marketplace.ownerOf(1)
   

    console.log(ethers.utils.formatEther(alicebalB4), 'BEFORE')
    console.log(ownerB4Sell, 'BEFORE')
    
    
    await this.marketplace.listItem(1, this.marketplace.address, 10000)
    await this.marketplace.connect(this.alice).buyItem(1)

    let ownerAfterSell = await this.marketplace.ownerOf(1)
    let alicebalAfter = await this.token.balances(this.alice.address)
    

    console.log(ethers.utils.formatEther(alicebalAfter), 'AFTER')
    console.log(ownerAfterSell, 'AFTER')
    

    
    await expect(ownerB4Sell).to.equal(this.owner.address)
    await expect(ownerAfterSell).to.equal(this.alice.address)
  })

  it("should list auction item", async function() {
    await this.marketplace.approve(this.marketplace.address, 3)
    
    expect(await this.marketplace.listItemOnAuction(3, this.marketplace.address, 10000)).to.emit(this.marketplace, 'itemListedOnAuction')
  })

  it("should make a bid", async function() {
    await this.token.connect(this.alice).approve(this.marketplace.address, ethers.utils.parseEther("1000000"))
  
    await this.marketplace.connect(this.alice).makeBid(2, 100000000)
    await this.marketplace.connect(this.alice).makeBid(2, 1000000000)
    await this.marketplace.connect(this.bob).makeBid(2, 10000000000)
  })

  it("should cancel", async function() {
    
    expect(await this.marketplace.cancel(2)).to.emit(this.marketplace, 'cancelled')
  })

  it("shouldn't finish the auction", async function() {
    
    expect(await this.marketplace.finishAuction(1)).to.be.revertedWith('No bids have been placed')
  })

});

