
import requests
import time
import pandas as pd

# Define your API key and query ID
DUNE_API_KEY = "DUNE_API_KEY"
QUERY_ID = "4175998" # https://dune.com/queries/4175998

# Define headers
headers = {
    "x-dune-api-key": DUNE_API_KEY
}

# Function to execute the query
def execute_query(query_id):
    url = f"https://api.dune.com/api/v1/query/{query_id}/execute"
    response = requests.post(url, headers=headers)
    if response.status_code == 200:
        execution_id = response.json()['execution_id']
        return execution_id
    else:
        raise Exception(f"Error executing query: {response.status_code}, {response.text}")

# Function to check the status of the query execution
def check_query_status(execution_id):
    url = f"https://api.dune.com/api/v1/execution/{execution_id}/status"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()['state']
    else:
        raise Exception(f"Error checking query status: {response.status_code}, {response.text}")

# Function to fetch query results
def fetch_query_results(execution_id):
    url = f"https://api.dune.com/api/v1/execution/{execution_id}/results"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()['result']['rows']
        return pd.DataFrame(data)
    else:
        raise Exception(f"Error fetching query results: {response.status_code}, {response.text}")

# Main execution
execution_id = execute_query(QUERY_ID)
status = check_query_status(execution_id)

# Polling until the query is completed
while status != "QUERY_STATE_COMPLETED":
    print(f"Query is still {status}. Waiting...")
    time.sleep(10)
    status = check_query_status(execution_id)

# Fetch results once the query is completed
df = fetch_query_results(execution_id)

# Display or process the data
print(df)



