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
}
