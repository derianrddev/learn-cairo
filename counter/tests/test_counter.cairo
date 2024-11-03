use super::utils::deploy_contract;
use counter::counter::{ICounterDispatcher, ICounterDispatcherTrait};

#[test]
fn check_stored_counter() {
    let initial_counter: u32 = 12;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterDispatcher { contract_address };
    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter, "Stored value not equal");
}

#[test]
fn increase_counter() {
    let initial_counter: u32 = 15;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterDispatcher { contract_address };

    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter + 1, "Stored value not equal");
}