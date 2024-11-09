#[starknet::interface]
pub trait ITask<TContractState> {
    fn get_id(self: @TContractState) -> u64;
    fn get_description(self: @TContractState) -> ByteArray;
    fn set_description(ref self: TContractState, description: ByteArray);
    fn get_completed(self: @TContractState) -> bool;
    fn set_completed(ref self: TContractState, completed: bool);
}

#[starknet::contract]
pub mod TaskContract {
    #[storage]
    struct Storage {
        id: u64,
        description: ByteArray,
        completed: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, id: u64, description: ByteArray) {
        self.id.write(id);
        self.description.write(description);
        self.completed.write(false);
    }

    #[abi(embed_v0)]
    impl TaskImpl of super::ITask<ContractState> {
        fn get_id(self: @ContractState) -> u64 {
            return self.id.read();
        }
        fn get_description(self: @ContractState) -> ByteArray {
            return self.description.read();
        }
        fn set_description(ref self: ContractState, description: ByteArray) {
            self.description.write(description);
        }
        fn get_completed(self: @ContractState) -> bool {
            return self.completed.read();
        }
        fn set_completed(ref self: ContractState, completed: bool) {
            self.completed.write(completed);
        }
    }
}
