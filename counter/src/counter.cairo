#[starknet::interface]
pub trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
    fn decrease_counter(ref self: TContractState);
}

#[starknet::contract]
pub mod CounterContract {
    #[storage]
    struct Storage {
        counter: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        CounterChanged: CounterChange,
    }

    #[derive(Drop, starknet::Event)]
    pub struct CounterChange {
        pub value: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32) {
        self.counter.write(initial_value);
    }

    #[abi(embed_v0)]
    impl Counter of super::ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            let counter = self.counter.read();
            self.counter.write(counter + 1);

            self.emit(CounterChange { value: counter + 1 });
        }

        fn decrease_counter(ref self: ContractState) {
            let counter = self.counter.read();
            self.counter.write(counter - 1);

            self.emit(CounterChange { value: counter - 1 });
        }
    }
}
