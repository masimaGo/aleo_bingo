#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
###############################################################################
########                                                               ########
########               STEP 0: Compile the vote program                ########
########                                                               ########
###############################################################################
"
# Build the Leo vote program.
(
  leo build || exit
)

# 1: Initializing Player 1
echo "
###############################################################################
########                                                               ########
########                 STEP 1: Initializing Player 1                 ########
########                                                               ########
###############################################################################
"
echo "{
  \"program\": \"aleo_bingo.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

echo "✅ Successfully initialized Player 1."


# 2: Player 1 Starts Bingo Game
echo "
###############################################################################
########                                                               ########
########               STEP 2: Player 1 Starts Bingo Game              ########
########                                                               ########
###############################################################################
"
leo run create_game 1u64 1u64 1000000u64 21888242871839275222246405745257275088548364400416034343698204186575808495617field

# 3: Player 1 Join's Bingo Game
echo "
###############################################################################
########                                                               ########
########               STEP 3: Player 1 Join's Bingo Game              ########
########                                                               ########
###############################################################################
"

leo run join_game 33388242871839275222246405745257275088548364400416034343698204186575808495617field 21888242871839275222246405745257275088548364400416034343698204186575808495617field '{r1: { c1: 1u64, c2: 2u64, c3: 3u64, c4: 4u64, c5: 5u64, c1_hit: false, c2_hit: false, c3_hit: false, c4_hit: false, c5_hit: false },r2: { c1: 21u64, c2: 22u64, c3: 23u64, c4: 24u64, c5: 25u64, c1_hit: false, c2_hit: false, c3_hit: false, c4_hit: false, c5_hit: false },r3: { c1: 31u64, c2: 32u64, c3: 33u64, c4: 34u64, c5: 35u64, c1_hit: false, c2_hit: false, c3_hit: true, c4_hit: false, c5_hit: false },r4: { c1: 41u64, c2: 42u64, c3: 43u64, c4: 44u64, c5: 45u64, c1_hit: false, c2_hit: false, c3_hit: false, c4_hit: false, c5_hit: false },r5: { c1: 51u64, c2: 52u64, c3: 53u64, c4: 54u64, c5: 55u64, c1_hit: false, c2_hit: false, c3_hit: false, c4_hit: false, c5_hit: false }}'

# 4: Start Bingo Game
echo "
###############################################################################
########                                                               ########
########                    STEP 4: Start Bingo Game                   ########
########                                                               ########
###############################################################################
"

leo run start_game '{owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,id: 4999319372982534373748755867694182025796565730107906687827737274740990017535field.public,public_info: {max_rounds_of_winners: 1u64.public,prize_pool: 1000000u64.public},_nonce: 3044777441177486787648030450240905184976166994322930859183505762269404120249group.public}'

# 5: Start Next Round
echo "
###############################################################################
########                                                               ########
########                    STEP 5: Start Next Round                   ########
########                                                               ########
###############################################################################
"

leo run next_round '{owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,id: 4999319372982534373748755867694182025796565730107906687827737274740990017535field.public,public_info: {max_rounds_of_winners: 1u64.public,prize_pool: 1000000u64.public},_nonce: 5642110369211239051645557700215128476176343601147241738833584151261605380728group.public}' 1u8 30u64 4999319372982534373748755867694182025796565730107906687827737274740990017535field 4999319372982534373748755867694182025796565730107906687827737274740990017535field

# 6: Player Checks Card
echo "
###############################################################################
########                                                               ########
########                   STEP 6: Player Checks Card                  ########
########                                                               ########
###############################################################################
"

leo run check_card '{ owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private, game_id: 4999319372982534373748755867694182025796565730107906687827737274740990017535field.public, id: 8054857623554163949499930928912635494420666394953842859892503818823580778494field.public, winning_card: false.private, win_amount: 0u64.private, content: { r1: { c1: 1u64.private, c2: 2u64.private, c3: 3u64.private, c4: 4u64.private, c5: 5u64.private, c1_hit: false.private, c2_hit: false.private, c3_hit: false.private, c4_hit: false.private, c5_hit: false.private }, r2: { c1: 21u64.private, c2: 22u64.private, c3: 23u64.private, c4: 24u64.private, c5: 25u64.private, c1_hit: false.private, c2_hit: false.private, c3_hit: false.private, c4_hit: false.private, c5_hit: false.private }, r3: { c1: 31u64.private, c2: 32u64.private, c3: 33u64.private, c4: 34u64.private, c5: 35u64.private, c1_hit: false.private, c2_hit: false.private, c3_hit: true.private, c4_hit: false.private, c5_hit: false.private }, r4: { c1: 41u64.private, c2: 42u64.private, c3: 43u64.private, c4: 44u64.private, c5: 45u64.private, c1_hit: false.private, c2_hit: false.private, c3_hit: false.private, c4_hit: false.private, c5_hit: false.private }, r5: { c1: 51u64.private, c2: 52u64.private, c3: 53u64.private, c4: 54u64.private, c5: 55u64.private, c1_hit: false.private, c2_hit: false.private, c3_hit: false.private, c4_hit: false.private, c5_hit: false.private } }, _nonce: 3841317282315097130903283303349037649242293952605442033388176367392560963316group.public }' 1u8 30u64

# 7: Check Winners
echo "
###############################################################################
########                                                               ########
########                      STEP 7: Check Winners                    ########
########                                                               ########
###############################################################################
"

leo run check_winners '{owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,id: 4999319372982534373748755867694182025796565730107906687827737274740990017535field.public,public_info: {max_rounds_of_winners: 1u64.public,prize_pool: 1000000u64.public},_nonce: 492725964477129813614569263962088633897434166307841445177862346259250052645group.public}'