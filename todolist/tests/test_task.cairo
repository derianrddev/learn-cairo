use starknet::ContractAddress;

use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};

use todolist::task::{ITaskDispatcher, ITaskDispatcherTrait};

fn ID() -> u64 {
    1
}
fn DESCRIPTION() -> ByteArray {
    "Learn Cairo"
}
fn COMPLETED() -> ByteArray {
    "Learn Cairo"
}

fn deploy_contract() -> ContractAddress {
    let task = declare("TaskContract").unwrap().contract_class();
    let mut calldata: Array<felt252> = array![];
    Serde::serialize(@ID(), ref calldata);
    Serde::serialize(@DESCRIPTION(), ref calldata);
    let (contract_address, _) = task.deploy(@calldata).unwrap();
    contract_address
}

#[test]
fn test_constructor() {
    let contract_address = deploy_contract();
    let task = ITaskDispatcher { contract_address };
    let id = task.get_id();
    let description = task.get_description();
    let completed = task.get_completed();
    assert(id == ID(), 'Invalid ID');
    assert(description == DESCRIPTION(), 'Invalid description');
    assert(completed == false, 'Invalid completed');
}

#[test]
fn test_set_description() {
    let contract_address = deploy_contract();
    let task = ITaskDispatcher { contract_address };
    let description = task.get_description();
    assert(description == DESCRIPTION(), 'Invalid description');
    task.set_description("Learn Next.js");
    let new_description = task.get_description();
    assert(new_description == "Learn Next.js", 'set_description method not work')
}

#[test]
fn test_set_completed() {
    let contract_address = deploy_contract();
    let task = ITaskDispatcher { contract_address };
    let completed = task.get_completed();
    assert(completed == false, 'Invalid completed');
    task.set_completed(true);
    let new_completed = task.get_completed();
    assert(new_completed == true, 'set_completed method not work')
}
