
# Staked ETH Analysis for Blockworks

Welcome to the repository for my **Staked ETH Analysis** conducted as part of my take-home assignment for Blockworks Research. This project explores various staked ETH tokens using an experimental design approach to evaluate retention rates and compare fee structures across the ecosystem.

## Repository Structure

This repository contains the data, code, and outputs used in the analysis:

- **Data Folder**: Contains the transaction data pulled from Dune Analytics. Additionally, a Python script is provided to automatically pull this data directly from Dune.  
  - `data/transactions_data.csv`: The transaction data file used in the analysis.
  - `GetData.py`: Python script that automates the data extraction process from Dune Analytics. This program is not needed to run the analysis, but is available to show how I pulled the datasets used.

- **Design Folder**: Contains the experimental design matrix and a detailed description of the token classification process. Each token was assigned a specific level for factors such as retention rate, fee structure, and other protocol features.
  - `design/design_matrix.csv`: The design matrix showing the experimental setup.
  - `design/README.md`: Descriptions of how each token was assigned levels for the factors being analyzed.

- **Analysis.R Script**: The primary script that performs the analysis, generating the figures and final results.
  - `Analysis.R`: R script that runs the fractional factorial design analysis, visualizes the data, and computes the results. All that is needed to replicate this analysis is this script. The data pulls directly from the stored CSVs in GitHub.

## Overview

The purpose of this analysis is to:
1. Compare staked ETH tokens based on several factors such as retention rate, fee structures, and other protocol characteristics.
2. Identify patterns and differences between these tokens using a fractional factorial design.
3. Provide suggestions to improve retention rates or fee structure efficiency for various protocols.

## Key Tokens Analyzed

The analysis includes tokens such as:
- **Lido stETH**
- **Rocket Pool rETH**
- **Coinbase cbETH**
- **Frax sFRXETH**
- **Stader ETHx**
- and many more, representing a wide spectrum of the Ethereum staking ecosystem.

## Instructions

To replicate the analysis or explore the data:
1. Review the **design** folder for detailed descriptions of the token classification.
2. Run the **Analysis.R** script to generate the visualizations and results.
