# Bingo Smart Contract

This is a Rust Smart Contract for a simple bingo game on the Flow blockchain. The contract allows users to participate in bingo games, purchase bingo cards, select numbers, and receive prizes for winning.

## Getting Started

Before you can deploy and interact with this contract, make sure you have set up the Flow development environment and installed the necessary tools.

### Prerequisites

- Flow CLI: [Install Flow CLI](https://docs.onflow.org/flow-cli/install/)
- Rust: [Install Rust](https://www.rust-lang.org/tools/install)

### Installation

1. Clone this repository:

   ```shell
   git clone https://github.com/your-username/bingo-smart-contract.git
   cd bingo-smart-contract
   ```

2. Build the Smart Contract:

   ```shell
   cargo build --target wasm32-unknown-unknown
   ```

3. Deploy the contract to the Flow emulator:

   ```shell
   flow emulator start
   flow project deploy
   ```

## Usage

### Initialize a Bingo Game

To initialize a new bingo game, use the `initialize_game` transition. The game owner should execute this transition.

```rust
// Example code for initializing a new game
let game_id: UInt64 = 0
let game_owner: Address = 0x1
transaction {
    prepare(acct: AuthAccount) {
        acct.contracts.add(
            name: "SimpleBingo",
            code: SimpleBingo.Code
        )
    }
}
```

### Purchase Bingo Cards

Players can purchase bingo cards using the `purchase_card` transition. They need to specify the game ID they want to participate in.

```rust
// Example code for purchasing a bingo card
let game_id: UInt64 = 0
let card_owner: Address = 0x2
transaction {
    execute {
        let gameRef = getAccount(game_owner)
            .getCapability<&SimpleBingo.SimpleBingo{SimpleBingo.SimpleBingo}(borrow: true)
            .borrow()
            ?? panic("Could not borrow a reference to the game")
        gameRef.purchase_card(game_id: game_id, card_price: 100.0)
    }
}
```

### Select Numbers and Win

Players can select numbers on their bingo cards using the `update_game` transition. If a player achieves a winning pattern, the prize will be automatically transferred to their account.

```rust
// Example code for updating a bingo card
let game_id: UInt64 = 0
let card_owner: Address = 0x2
transaction {
    execute {
        let gameRef = getAccount(card_owner)
            .getCapability<&SimpleBingo.SimpleBingo{SimpleBingo.SimpleBingo}(borrow: true)
            .borrow()
            ?? panic("Could not borrow a reference to the game")
        gameRef.update_game(game_id: game_id, column: 2, number: 17)
    }
}
```

### Closing a Game

Once a game has concluded, the game owner can use the `close_game` transition to close the game and distribute the remaining jackpot.

```rust
// Example code for closing a bingo game
let game_id: UInt64 = 0
let game_owner: Address = 0x1
transaction {
    execute {
        let gameRef = getAccount(game_owner)
            .getCapability<&SimpleBingo.SimpleBingo{SimpleBingo.SimpleBingo}(borrow: true)
            .borrow()
            ?? panic("Could not borrow a reference to the game")
        gameRef.close_game(game_id: game_id)
    }
}
```

## Contributing

We welcome contributions to improve and expand this bingo smart contract. If you have ideas for features or bug fixes, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
``

masimabgo - ds
