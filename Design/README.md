
# ETH Staking Token Factorial Design Analysis

## Overview

This project analyzes 22 ETH staking tokens using a fractional factorial design approach. Each token is evaluated across 9 key factors that impact staking performance and user experience. The factors are classified into two levels, with `-1` representing the **low/negative** level and `1` representing the **high/positive** level. These factors capture aspects such as liquidity, slashing risk, governance participation, and ecosystem support.

## Factors and Levels

The following factors were selected for this analysis, with each factor having two levels:
- **Fee Structure**: 
  - `-1`: Low fee (affordable or minimal fees for users)
  - `1`: High fee (higher fees on staking rewards)
- **Reward Payout Frequency**: 
  - `-1`: Infrequent payouts (monthly or longer)
  - `1`: Frequent payouts (daily or weekly)
- **APY**: 
  - `-1`: Low (closer to baseline ETH staking returns)
  - `1`: High (yield is above 8%)
- **Liquidity**: 
  - `-1`: Low (limited use in DeFi or trading platforms)
  - `1`: High (widely accepted, easy to convert)
- **Lockup Period**: 
  - `-1`: Low (immediate access, no or short lock-up)
  - `1`: High (longer unbonding periods or delays in access)
- **Slashing Risk**: 
  - `-1`: Low (minimal chance of slashing or penalties)
  - `1`: High (decentralized validators with higher risk)
- **Governance Participation**: 
  - `-1`: Low (no or limited ability to participate in protocol decisions)
  - `1`: High (active governance participation or voting rights)
- **Security & Audits**: 
  - `-1`: Low (lesser-known protocols with limited audits)
  - `1`: High (extensively audited, strong security practices)
- **Ecosystem Support**: 
  - `-1`: Low (limited integrations, niche token with minimal support)
  - `1`: High (widely used in DeFi and supported by multiple platforms)

## Token Evaluation

Each of the 22 tokens was assigned a `-1` or `1` level for each factor based on its characteristics and real-world behavior. Below is a brief explanation of why certain tokens received their respective levels:

- **Ankr Staked ETH (ankrETH)**: 
  - Low fees, infrequent payouts, highly liquid, with strong governance and security support.

- **Coinbase Wrapped Staked ETH (cbETH)**: 
  - High fees, infrequent payouts, with low governance but excellent security and ecosystem support due to Coinbase's reputation.

- **Crypto.com Staked ETH (CDCETH)**: 
  - High fees and limited liquidity, primarily supported within the Crypto.com ecosystem, making it less integrated into broader DeFi platforms.

- **Eigenpie mstETH (MSTETH)**: 
  - Offers high APY and frequent payouts but has limited liquidity and is less audited, leading to higher slashing risk.

- **ether.fi Staked ETH (EETH)**: 
  - High governance participation, frequent payouts, and strong security support, making it highly integrated into the DeFi ecosystem.

- **Frax Staked Ether (SFRXETH)**: 
  - High APY and frequent payouts with excellent liquidity, but operates in a decentralized framework with higher slashing risks.

- **Kelp DAO Restaked ETH (RSETH)**: 
  - Low liquidity and governance participation, with infrequent rewards and higher slashing risk due to its restaking mechanism.

- **Lido Staked ETH (stETH)**: 
  - One of the most liquid tokens with frequent payouts, low fees, and a strong reputation for security and governance.

- **Liquid Staked ETH (LSETH)**: 
  - Designed for liquidity with frequent payouts, though it operates in a decentralized environment, leading to higher slashing risk.

- **Mantle Staked Ether (METH)**: 
  - Newer protocol with higher fees, lower liquidity, and limited governance participation, making it a higher-risk option.

- **PUFETH (pufETH)**: 
  - Operates with low fees and frequent payouts, but lacks liquidity and has higher slashing risks due to decentralization.

- **pzETH (PZETH)**: 
  - Similar to PUFETH, this token has high APY but suffers from limited liquidity and higher slashing risks.

- **Renzo Restaked ETH (EZETH)**: 
  - Lower liquidity and higher slashing risk, operating with less governance participation and longer lock-up periods.

- **Restaked Swell Ethereum (RSWETH)**: 
  - Limited ecosystem support with higher slashing risk and infrequent payouts due to its restaking model.

- **Rocket Pool ETH (RETH)**: 
  - Highly liquid with low fees, strong governance participation, and minimal slashing risk, making it a popular option in DeFi.

- **sETH2 (SETH2)**: 
  - Infrequent payouts with low fees and strong security, but lower governance and slashing protections compared to liquid tokens.

- **Stader ETHx (ETHX)**: 
  - High liquidity and frequent payouts with strong governance participation, though it operates with higher slashing risks.

- **StakeWise Staked ETH (osETH)**: 
  - Excellent liquidity and ecosystem support with frequent payouts, making it a popular choice for DeFi yield farming.

- **SWETH (swETH)**: 
  - Highly liquid with strong yield farming opportunities and frequent rewards, though it faces higher slashing risks.

- **Wrapped Beacon ETH (WBETH)**: 
  - Strong security and liquidity due to Binance’s backing, though it operates with less governance participation.

- **Wrapped eETH (weETH)**: 
  - High liquidity and frequent payouts with a strong reputation for security, making it a popular option for DeFi integrations.

- **Wrapped Origin Ether (WOETH)**: 
  - Excellent liquidity and security with frequent rewards, though it lacks significant governance participation.

## Conclusion

This factorial design provides a structured comparison of ETH staking tokens across multiple factors. By analyzing these variables, users can better understand which tokens align with their specific preferences for fees, liquidity, risk, governance, and more.

The complete design matrix is available in the file `design_matrix.csv`.
