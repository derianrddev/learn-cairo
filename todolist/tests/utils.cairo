use starknet::{ContractAddress, ClassHash};
use snforge_std::{declare, DeclareResultTrait, ContractClassTrait, get_class_hash};

pub fn deploy_contract() -> (ContractAddress, ClassHash) {
    // Task
    let task = declare("TaskContract").unwrap().contract_class();
    let mut task_calldata: Array<felt252> = array![];
    Serde::serialize(@1, ref task_calldata);
    Serde::serialize(@'Learn Cairo', ref task_calldata);
    let (task_contract_address, _) = task.deploy(@task_calldata).unwrap();
    let task_class_hash = get_class_hash(task_contract_address);
    // ToDoList
    let to_do_list = declare("ToDoListContract").unwrap().contract_class();
    let mut to_do_list_calldata: Array<felt252> = array![];
    Serde::serialize(@task_class_hash, ref to_do_list_calldata);
    let (to_do_list_contract_address, _) = to_do_list.deploy(@to_do_list_calldata).unwrap();
    (to_do_list_contract_address, task_class_hash)
}
