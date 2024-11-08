#[starknet::interface]
pub trait ITask<TContractState> {
    fn get_id(self: @TContractState) -> u64;
    fn get_description(self: @TContractState) -> felt252;
    fn get_completed(self: @TContractState) -> bool;
}

#[starknet::contract]
pub mod TaskContract {
    #[storage]
    struct Storage {
        id: u64,
        description: felt252,
        completed: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, id: u64, description: felt252) {
        self.id.write(id);
        self.description.write(description);
        self.completed.write(false);
    }

    #[abi(embed_v0)]
    impl TaskImpl of super::ITask<ContractState> {
        fn get_id(self: @ContractState) -> u64 {
            return self.id.read();
        }
        fn get_description(self: @ContractState) -> felt252 {
            return self.description.read();
        }
        fn get_completed(self: @ContractState) -> bool {
            return self.completed.read();
        }
    }
}
