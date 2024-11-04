use super::utils::deploy_contract;
use counter::counter::{ICounterDispatcher, ICounterDispatcherTrait};
use snforge_std::{spy_events, EventSpyTrait};

#[test]
fn test_initial_counter_value() {
    let initial_counter: u32 = 12;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterDispatcher { contract_address };

    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter, "Stored value not equal");
}

#[test]
fn test_increment_counter() {
    let initial_counter: u32 = 15;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterDispatcher { contract_address };

    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter + 1, "Stored value not equal");
}

#[test]
fn test_decrement_counter() {
    let initial_counter: u32 = 22;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterDispatcher { contract_address };

    dispatcher.decrease_counter();
    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter - 1, "Stored value not equal");
}

#[test]
fn test_emit_counter_change_events() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterDispatcher { contract_address };

    let mut spy = spy_events();
    dispatcher.increase_counter();
    dispatcher.decrease_counter();

    let events = spy.get_events();

    assert(events.events.len() == 2, 'There should be two events');

    let (_, event1) = events.events.at(0);
    assert(event1.data.at(0) == @16, 'Counter value should be 16');

    let (_, event2) = events.events.at(1);
    assert(event2.data.at(0) == @15, 'Counter value should be 15');
}
