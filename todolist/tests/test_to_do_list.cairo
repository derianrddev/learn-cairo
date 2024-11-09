use starknet::{ContractAddress, ClassHash, contract_address_const};

use snforge_std::{
    declare, DeclareResultTrait, ContractClassTrait, start_cheat_caller_address_global,
    get_class_hash
};

use todolist::to_do_list::{IToDoListDispatcher, IToDoListDispatcherTrait};

fn ID() -> u64 {
    1
}
fn DESCRIPTION() -> ByteArray {
    "Learn Cairo"
}
fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn deploy_contract() -> (ContractAddress, ClassHash) {
    // Task
    let task = declare("TaskContract").unwrap().contract_class();
    let mut task_calldata: Array<felt252> = array![];
    Serde::serialize(@ID(), ref task_calldata);
    Serde::serialize(@DESCRIPTION(), ref task_calldata);
    let (task_contract_address, _) = task.deploy(@task_calldata).unwrap();
    let task_class_hash = get_class_hash(task_contract_address);
    // ToDoList
    let to_do_list = declare("ToDoListContract").unwrap().contract_class();
    let mut to_do_list_calldata: Array<felt252> = array![];
    Serde::serialize(@task_class_hash, ref to_do_list_calldata);
    let (to_do_list_contract_address, _) = to_do_list.deploy(@to_do_list_calldata).unwrap();
    (to_do_list_contract_address, task_class_hash)
}

#[test]
fn test_constructor() {
    start_cheat_caller_address_global(OWNER());
    let (contract_address, task_class_hash) = deploy_contract();
    let to_do_list = IToDoListDispatcher { contract_address };
    let expected_task_address = to_do_list.get_task_class_hash();
    let owner = to_do_list.get_owner();
    assert(owner == OWNER(), 'Invalid owner');
    assert(task_class_hash == expected_task_address, 'Invalid task class hash');
}

#[test]
fn test_add_task() {
    start_cheat_caller_address_global(OWNER());
    let (contract_address, task_class_hash) = deploy_contract();
    let to_do_list = IToDoListDispatcher { contract_address };
    to_do_list.add_task("Learn NextJS");
    let expected_task_class_hash = get_class_hash(to_do_list.get_task(1));
    let current_id = to_do_list.get_current_id();
    assert(expected_task_class_hash == task_class_hash, 'Invalid task address');
    assert(current_id == 2, 'Invalid current ID');
}
