// SPDX-License-Identifier: MIT
use ink_lang as ink;

#[ink::contract]
mod staking {
    use @openzeppelin/contracts/token/ERC20/IERC20 as ERC20;

    #[ink(storage)]
    pub struct Staking {
        rewards_token: AccountId,
        staking_token: AccountId,
        reward_rate: u256,
        last_update_time: Timestamp,
        reward_per_token_stored: u256,
        user_reward_per_token_paid: ink::collections::HashMap<AccountId, u256>,
        rewards: ink::collections::HashMap<AccountId, u256>,
        total_supply: Balance,
        balances: ink::collections::HashMap<AccountId, Balance>,
    }

    #[ink(event)]
    pub struct Staked {
        #[ink(topic)]
        user: AccountId,
        #[ink(topic)]
        amount: Balance,
    }

    #[ink(event)]
    pub struct WithdrewStake {
        #[ink(topic)]
        user: AccountId,
        #[ink(topic)]
        amount: Balance,
    }

    #[ink(event)]
    pub struct RewardsClaimed {
        #[ink(topic)]
        user: AccountId,
        #[ink(topic)]
        amount: Balance,
    }

    impl Staking {
        #[ink(constructor)]
        pub fn new(rewards_token: AccountId, staking_token: AccountId) -> Self {
            let caller = Self::env().caller();
            Self {
                rewards_token,
                staking_token,
                reward_rate: 100,
                last_update_time: Self::env().block_timestamp(),
                reward_per_token_stored: 0,
                user_reward_per_token_paid: Default::default(),
                rewards: Default::default(),
                total_supply: 0,
                balances: vec![(caller, 0)].into_iter().collect(),
            }
        }

        #[ink(message)]
        pub fn reward_per_token(&self) -> u256 {
            if self.total_supply == 0 {
                return self.reward_per_token_stored;
            }

            self.reward_per_token_stored
                + (((Self::env().block_timestamp() - self.last_update_time)
                    * self.reward_rate
                    * 1e18)
                    / self.total_supply)
        }

        #[ink(message)]
        pub fn earned(&self, account: AccountId) -> u256 {
            ((self.balances[&account]
                * (self.reward_per_token() - self.user_reward_per_token_paid[&account]))
                / 1e18)
                + self.rewards[&account]
        }

        #[ink(message)]
        pub fn stake(&mut self, amount: Balance) {
            let caller = self.env().caller();
            self.update_reward(caller);
            self.total_supply += amount;
            self.balances
                .entry(caller)
                .and_modify(|e| *e += amount)
                .or_insert(amount);
            self.env().emit_event(Staked { user: caller, amount });
            let success = ERC20::transfer_from(
                &self.staking_token,
                &caller,
                &self.env().account_id(),
                amount,
            );
            if !success {
                Self::env().panic();
            }
        }

        #[ink(message)]
        pub fn withdraw(&mut self, amount: Balance) {
            let caller = self.env().caller();
            self.update_reward(caller);
            self.total_supply -= amount;
            self.balances
                .entry(caller)
                .and_modify(|e| *e -= amount)
                .or_insert(0);
            self.env().emit_event(WithdrewStake { user: caller, amount });
            let success = ERC20::transfer(&self.staking_token, &caller, amount);
            if !success {
                Self::env().panic();
            }
        }

        #[ink(message)]
        pub fn claim_reward(&mut self) {
            let caller = self.env().caller();
            self.update_reward(caller);
            let reward = self.rewards[&caller];
            self.rewards.insert(caller, 0);
            self.env().emit_event(RewardsClaimed { user: caller, amount: reward });
            let success = ERC20::transfer(&self.rewards_token, &caller, reward);
            if !success {
                Self::env().panic();
            }
        }

        #[ink(message)]
        pub fn get_staked(&self, account: AccountId) -> Balance {
            self.balances[&account]
        }

        fn update_reward(&mut self, account: AccountId) {
            self.reward_per_token_stored = self.reward_per_token();
            self.last_update_time = Self::env().block_timestamp();
            self.rewards.insert(account, self.earned(account));
            self.user_reward_per_token_paid.insert(account, self.reward_per_token_stored);
        }
    }
}
