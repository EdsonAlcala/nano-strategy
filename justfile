set dotenv-load
set export

# deployments
deploy_factory JSON_RPC_URL SENDER:
    forge script script/001_deploy_fund_factory.s.sol:DeployFundFactoryScript --rpc-url $JSON_RPC_URL --sender $SENDER --broadcast --ffi -vvvv

deploy_sample_tokens JSON_RPC_URL SENDER:
    forge script script/002_deploy_sample_tokens.s.sol:DeploySampleTokensScript --rpc-url $JSON_RPC_URL --sender $SENDER --broadcast --ffi -vvvv

deploy_local:
    echo "Deploying contracts locally"
    NETWORK_ID=$CHAIN_ID_LOCAL MNEMONIC=$MNEMONIC_LOCAL just deploy_factory $RPC_URL_LOCAL $SENDER_LOCAL
    NETWORK_ID=$CHAIN_ID_LOCAL MNEMONIC=$MNEMONIC_LOCAL just deploy_sample_tokens $RPC_URL_LOCAL $SENDER_LOCAL

deploy_base_sepolia:
    echo "Deploying contracts to Base Sepolia"
    NETWORK_ID=$CHAIN_ID_BASE_SEPOLIA MNEMONIC=$MNEMONIC_TESTNET just deploy_factory_factory $RPC_URL_BASE_SEPOLIA $SENDER_TESTNET
    NETWORK_ID=$CHAIN_ID_BASE_SEPOLIA MNEMONIC=$MNEMONIC_TESTNET just deploy_factory $RPC_URL_BASE_SEPOLIA $SENDER_TESTNET
    NETWORK_ID=$CHAIN_ID_BASE_SEPOLIA MNEMONIC=$MNEMONIC_TESTNET just deploy_sample_tokens $RPC_URL_BASE_SEPOLIA $SENDER_TESTNET

# forge
compile: 
    echo "Compiling contracts"
    forge build

# testing

test_unit:
    echo "Running unit tests"
    forge test --match-path "test/unit/**/*.sol" --rpc-url $RPC_URL_ETHEREUM_MAINNET -vvvv

test_coverage:
    forge coverage --rpc-url $RPC_URL_ETHEREUM_MAINNET --report lcov 
    lcov --remove ./lcov.info --output-file ./lcov.info 'script' 'DeployerUtils.sol' 'DeploymentUtils.sol' 'config/*' 'helpers/*'
    genhtml lcov.info -o coverage --branch-coverage --ignore-errors category

test CONTRACT:
    forge test --mc {{CONTRACT}} --ffi -vvvv

test_only CONTRACT TEST:
    forge test --mc {{CONTRACT}} --mt {{TEST}} --rpc-url $RPC_URL_ETHEREUM_MAINNET --ffi -vvvv