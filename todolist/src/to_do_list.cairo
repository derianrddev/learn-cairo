#[starknet::interface]
pub trait IToDoList<TContractState> {
    fn add_task(ref self: TContractState, description: felt252);
}

#[starknet::contract]
pub mod ToDoListContract {
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use core::starknet::{ContractAddress, get_caller_address, ClassHash, syscalls};   

    #[storage]
    struct Storage {
        owner: ContractAddress,
        current_id: u64,
        tasks: Map<u64, ContractAddress>,
        task_class_hash: ClassHash,
    }

    #[constructor]
    fn constructor(ref self: ContractState, task_class_hash: felt252) {
        self.owner.write(get_caller_address());
        self.task_class_hash.write(task_class_hash.try_into().unwrap());
        self.current_id.write(1);
    }

    #[abi(embed_v0)]
    impl ToDoList of super::IToDoList<ContractState> {
        fn add_task(ref self: ContractState, description: felt252) {
            let mut call_data: Array<felt252> = array![];
            Serde::serialize(@self.current_id.read(), ref call_data);
            Serde::serialize(@description, ref call_data);
            Serde::serialize(@false, ref call_data);
            let (new_task_address, _) = syscalls::deploy_syscall(
                self.task_class_hash.read(), 12345, call_data.span(), false
            )
                .unwrap();
            self.tasks.entry(self.current_id.read()).write(new_task_address);
            self.current_id.write(self.current_id.read() + 1);
        } 
    }
}
