#[starknet::contract]
pub mod TaskContract {
    #[storage]
    struct Storage {
        id: u64,
        description: felt252,
        completed: bool
    }
}