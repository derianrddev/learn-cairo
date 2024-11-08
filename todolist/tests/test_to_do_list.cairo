use starknet::{ContractAddress, contract_address_const};
use snforge_std::{start_cheat_caller_address_global, get_class_hash};

use super::utils::deploy_contract;
use todolist::to_do_list::{IToDoListDispatcher, IToDoListDispatcherTrait};

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

#[test]
fn test_constructor() {
    start_cheat_caller_address_global(OWNER());
    let (contract_address, task_class_hash) = deploy_contract();
    let to_do_list_contract = IToDoListDispatcher { contract_address };
    let expected_task_address = to_do_list_contract.get_task_class_hash();
    let owner = to_do_list_contract.get_owner();
    assert(owner == OWNER(), 'Invalid owner');
    assert(task_class_hash == expected_task_address, 'Invalid task class hash');
}

#[test]
fn test_add_task() {
    start_cheat_caller_address_global(OWNER());
    let (contract_address, task_class_hash) = deploy_contract();
    let to_do_list_contract = IToDoListDispatcher { contract_address };
    to_do_list_contract.add_task('Learn NextJS');
    let expected_task_class_hash = get_class_hash(to_do_list_contract.get_task(1));
    let current_id = to_do_list_contract.get_current_id();
    assert(expected_task_class_hash == task_class_hash, 'Invalid task address');
    assert(current_id == 2, 'Invalid current ID');
}
