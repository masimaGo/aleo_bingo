program aleo_bingo.aleo {

    struct BingoPublicInfo {
        max_rounds_of_winners: u64,
        prize_pool: u64,
    }

    record SimpleBingo {
        private owner: address,
        public id: field,
        public public_info: BingoPublicInfo,
    }

    struct Row {
        c1: u64,
        c2: u64,
        c3: u64,
        c4: u64,
        c5: u64,
        c1_hit: bool,
        c2_hit: bool,
        c3_hit: bool,
        c4_hit: bool,
        c5_hit: bool,
    }

    struct Board {
        r1: Row,
        r2: Row,
        r3: Row,
        r4: Row,
        r5: Row,
    }

    record BingoGameCard {
        public game_id: field,
        public id: field,
        private owner: address,
        private winning_card: bool,
        private win_amount: u64,
        private content: Board,
    }

    mapping games: field => u64;
    mapping games_created: field => bool;
    mapping games_started: field => bool;
    mapping games_completed: field => bool;
    mapping players_to_game: address => field;
    mapping gamecards: field => field;
    mapping games_rounds_of_winners: field => u64;
    mapping column_game_round: field => u8;
    mapping game_round_value: field => u64;
    mapping game_round_number: field => u64;

    transition create_game(
        public max_rounds_of_winners: u64, 
        rounds_of_winners: u64,
        prize_pool: u64,
        game_id: field,
    ) -> SimpleBingo {

        let new_bingo_info: BingoPublicInfo = BingoPublicInfo {
            max_rounds_of_winners: max_rounds_of_winners,
            prize_pool: prize_pool,
        };

        let bingo_game: SimpleBingo = SimpleBingo {
            owner: self.caller,
            id: game_id,
            public_info: new_bingo_info,
        };

        return bingo_game then finalize(game_id);
    }

    finalize create_game(game_id: field) {
        assert(!Mapping::get(games_created, game_id));
        Mapping::set(games_created, game_id, true);
    }

    transition join_game(id: field, game_id: field, board: Board) -> BingoGameCard {

        let game_Card: BingoGameCard = BingoGameCard {
            game_id: game_id,
            id: id,
            owner: self.caller,
            winning_card: false,
            win_amount: 0u64,
            content: board,
        };

        return game_Card then finalize(self.caller, game_id, id);
    }

    finalize join_game(player: address, game_id: field, id: field) {
        assert(!Mapping::get(games_started, game_id));
        assert(!Mapping::get(games_completed, game_id));
        let current_game_id: field = Mapping::get(players_to_game, self.caller);
        if (game_id != current_game_id) {
            Mapping::set(players_to_game, self.caller, game_id);
        }
        Mapping::set(games, game_id, Mapping::get(games, game_id) + 1u64);
    }

    transition start_game (game: SimpleBingo) -> SimpleBingo {
        assert(game.owner == self.caller);
        return SimpleBingo {
            owner: self.caller,
            id: game.id,
            public_info: game.public_info,
        } then finalize(game.id);
    }

    finalize start_game(gameId: field) {
        assert(!Mapping::get(games_started, gameId));
        Mapping::set(games_started, gameId, true);
    }

    transition next_round(game: SimpleBingo, column: u8, number: u64, game_round_col: field, game_round_target_value: field) -> SimpleBingo {
        assert(game.owner == self.caller);
        let new_bingo_info: BingoPublicInfo = BingoPublicInfo {
            max_rounds_of_winners: game.public_info.max_rounds_of_winners,
            prize_pool: game.public_info.prize_pool,
        };
        let new_bingo_state: SimpleBingo = SimpleBingo {
            owner: self.caller,
            id: game.id,
            public_info: new_bingo_info,
        };
        return new_bingo_state then finalize(game.id, game_round_col, game_round_target_value, column, number);
    }

    finalize next_round (gameId: field, game_round_col: field, game_round_target_value: field, column: u8, number: u64 ) {
        assert(Mapping::get(games_started, gameId));
        assert(!Mapping::get(games_completed, gameId));
        let new_round_number: u64 = Mapping::get(game_round_number, gameId) + 1u64;
        Mapping::set(game_round_number, gameId, new_round_number);
        Mapping::set(column_game_round, game_round_col, column);
        Mapping::set(game_round_value, game_round_target_value, number);
    }

    function check_for_win(updated_card: Board) -> bool {
        let count: u8 = 0u8;

        if (updated_card.r1.c1_hit && updated_card.r1.c2_hit && updated_card.r1.c3_hit && updated_card.r1.c4_hit && updated_card.r1.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r2.c1_hit && updated_card.r2.c2_hit && updated_card.r2.c3_hit && updated_card.r2.c4_hit && updated_card.r2.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r3.c1_hit && updated_card.r3.c2_hit && updated_card.r3.c3_hit && updated_card.r3.c4_hit && updated_card.r3.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r4.c1_hit && updated_card.r4.c2_hit && updated_card.r4.c3_hit && updated_card.r4.c4_hit && updated_card.r4.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r5.c1_hit && updated_card.r5.c2_hit && updated_card.r5.c3_hit && updated_card.r5.c4_hit && updated_card.r5.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c1_hit && updated_card.r2.c1_hit && updated_card.r3.c1_hit && updated_card.r4.c1_hit && updated_card.r5.c1_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c2_hit && updated_card.r2.c2_hit && updated_card.r3.c2_hit && updated_card.r4.c2_hit && updated_card.r5.c2_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c3_hit && updated_card.r2.c3_hit && updated_card.r3.c3_hit && updated_card.r4.c3_hit && updated_card.r5.c3_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c4_hit && updated_card.r2.c4_hit && updated_card.r3.c4_hit && updated_card.r4.c4_hit && updated_card.r5.c4_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c5_hit && updated_card.r2.c5_hit && updated_card.r3.c5_hit && updated_card.r4.c5_hit && updated_card.r5.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c1_hit && updated_card.r2.c2_hit && updated_card.r3.c3_hit && updated_card.r4.c4_hit && updated_card.r5.c5_hit) {
            count = count + 1u8;
        } else if (updated_card.r1.c5_hit && updated_card.r2.c4_hit && updated_card.r3.c3_hit && updated_card.r4.c2_hit && updated_card.r5.c1_hit) {
            count = count + 1u8;
        }

        if (count > 0u8) {
            return true;
        }

        return false;
    }

    transition update_game(game: SimpleBingo, column: u8, number: u64) -> SimpleBingo {
        assert(game.owner == self.caller);
        let current_card_id: field = Mapping::get(gamecards, self.caller);
        assert(current_card_id != 0);
        let current_card: BingoGameCard = contract::call::ft_resolve(current_card_id, 0u256);
        let updated_card: BingoGameCard = BingoGameCard {
            game_id: current_card.game_id,
            id: current_card.id,
            owner: self.caller,
            winning_card: current_card.winning_card,
            win_amount: current_card.win_amount,
            content: Board {
                r1: Row {
                    c1: if column == 1u8 { number } else { current_card.content.r1.c1 },
                    c2: if column == 2u8 { number } else { current_card.content.r1.c2 },
                    c3: if column == 3u8 { number } else { current_card.content.r1.c3 },
                    c4: if column == 4u8 { number } else { current_card.content.r1.c4 },
                    c5: if column == 5u8 { number } else { current_card.content.r1.c5 },
                    c1_hit: if current_card.content.r1.c1 == number { true } else { current_card.content.r1.c1_hit },
                    c2_hit: if current_card.content.r1.c2 == number { true } else { current_card.content.r1.c2_hit },
                    c3_hit: if current_card.content.r1.c3 == number { true } else { current_card.content.r1.c3_hit },
                    c4_hit: if current_card.content.r1.c4 == number { true } else { current_card.content.r1.c4_hit },
                    c5_hit: if current_card.content.r1.c5 == number { true } else { current_card.content.r1.c5_hit },
                },
                r2: Row {
                    c1: if column == 1u8 { number } else { current_card.content.r2.c1 },
                    c2: if column == 2u8 { number } else { current_card.content.r2.c2 },
                    c3: if column == 3u8 { number } else { current_card.content.r2.c3 },
                    c4: if column == 4u8 { number } else { current_card.content.r2.c4 },
                    c5: if column == 5u8 { number } else { current_card.content.r2.c5 },
                    c1_hit: if current_card.content.r2.c1 == number { true } else { current_card.content.r2.c1_hit },
                    c2_hit: if current_card.content.r2.c2 == number { true } else { current_card.content.r2.c2_hit },
                    c3_hit: if current_card.content.r2.c3 == number { true } else { current_card.content.r2.c3_hit },
                    c4_hit: if current_card.content.r2.c4 == number { true } else { current_card.content.r2.c4_hit },
                    c5_hit: if current_card.content.r2.c5 == number { true } else { current_card.content.r2.c5_hit },
                },
                r3: Row {
                    c1: if column == 1u8 { number } else { current_card.content.r3.c1 },
                    c2: if column == 2u8 { number } else { current_card.content.r3.c2 },
                    c3: if column == 3u8 { number } else { current_card.content.r3.c3 },
                    c4: if column == 4u8 { number } else { current_card.content.r3.c4 },
                    c5: if column == 5u8 { number } else { current_card.content.r3.c5 },
                    c1_hit: if current_card.content.r3.c1 == number { true } else { current_card.content.r3.c1_hit },
                    c2_hit: if current_card.content.r3.c2 == number { true } else { current_card.content.r3.c2_hit },
                    c3_hit: if current_card.content.r3.c3 == number { true } else { current_card.content.r3.c3_hit },
                    c4_hit: if column == 4u8 { number } else { current_card.content.r3.c4 },
                    c5_hit: if column == 5u8 { number } else { current_card.content.r3.c5 },
                },
                r4: Row {
                    c1: if column == 1u8 { number } else { current_card.content.r4.c1 },
                    c2: if column == 2u8 { number } else { current_card.content.r4.c2 },
                    c3: if column == 3u8 { number } else { current_card.content.r4.c3 },
                    c4: if column == 4u8 { number } else { current_card.content.r4.c4 },
                    c5: if column == 5u8 { number } else { current_card.content.r4.c5 },
                    c1_hit: if column == 1u8 { number } else { current_card.content.r4.c1 },
                    c2_hit: if column == 2u8 { number } else { current_card.content.r4.c2 },
                    c3_hit: if column == 3u8 { number } else { current_card.content.r4.c3 },
                    c4_hit: if column == 4u8 { number } else { current_card.content.r4.c4 },
                    c5_hit: if column == 5u8 { number } else { current_card.content.r4.c5 },
                },
                r5: Row {
                    c1: if column == 1u8 { number } else { current_card.content.r5.c1 },
                    c2: if column == 2u8 { number } else { current_card.content.r5.c2 },
                    c3: if column == 3u8 { number } else { current_card.content.r5.c3 },
                    c4: if column == 4u8 { number } else { current_card.content.r5.c4 },
                    c5: if column == 5u8 { number } else { current_card.content.r5.c5 },
                    c1_hit: if column == 1u8 { number } else { current_card.content.r5.c1 },
                    c2_hit: if column == 2u8 { number } else { current_card.content.r5.c2 },
                    c3_hit: if column == 3u8 { number } else { current_card.content.r5.c3 },
                    c4_hit: if column == 4u8 { number } else { current_card.content.r5.c4 },
                    c5_hit: if column == 5u8 { number } else { current_card.content.r5.c5 },
                },
            },
        };
        if check_win(updated_card) {
            let game_to_end: BingoGame = contract::call::ft_resolve(current_card.game_id, 0u256);
            let owner_balance: u64 = contract::balance::get();
            let win_amount: u64 = updated_card.win_amount;
            let win_total: u64 = win_amount * game_to_end.jackpot;
            assert(win_total <= owner_balance);
            // Pay out the jackpot to the card owner
            contract::balance::transfer(self.caller, win_total);
            // Close the game
            contract::self::remove(game_to_end.game_id);
        }
        let new_card_id: field = contract::call::ft_store(&updated_card);
        let new_game = SimpleBingo { game_id: game.game_id, owner: game.owner, card: new_card_id };
        new_game
    }

    // Pay the rewards from the completed game to the winning card owner and close the game
    transition close_game(game: BingoGame) {
        assert(game.owner == self.caller);
        let owner_balance: u64 = contract::balance::get();
        let card: BingoGameCard = contract::call::ft_resolve(game.card, 0u256);
        let win_total: u64 = card.win_amount * game.jackpot;
        assert(win_total <= owner_balance);
        // Pay out the jackpot to the card owner
        contract::balance::transfer(self.caller, win_total);
        // Close the game
        contract::self::remove(game.game_id);
    }
}
