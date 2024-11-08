use starknet::ContractAddress;

use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};

use todolist::task::{ITaskDispatcher, ITaskDispatcherTrait};

fn ID() -> u64 {
    1
}
fn DESCRIPTION() -> felt252 {
    'Learn Cairo'
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
