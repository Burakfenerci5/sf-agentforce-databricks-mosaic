import mlflow
import pandas as pd
from langchain.agents import initialize_agent, Tool
from langchain.chat_models import ChatDatabricks
from langchain_community.tools.databricks import DatabricksSqlTool

# 1. Define the LLM (Using Databricks Foundation Models - DBRX or Llama 3)
# This uses the Model Serving endpoint for high-speed inference
llm = ChatDatabricks(endpoint="databricks-dbrx-instruct")

# 2. Define the Tool: Access to the IoT Delta Table
# This simulates the tool connecting to your Unity Catalog table
def query_iot_data(query: str) -> str:
    # In a real scenario, this would use DatabricksSqlTool to execute SQL
    return f"Executed SQL for query: '{query}' against catalog.schema.iot_sensor_data"

tools = [
    Tool(
        name="IoT_Data_Query",
        func=query_iot_data,
        description="Useful for answering questions about real-time sensor readings and device health."
    )
]

# 3. Create the Agent Chain
agent_chain = initialize_agent(tools, llm, agent="zero-shot-react-description", verbose=True)

# 4. Wrap as an MLflow Model for Serving
class AgentModel(mlflow.pyfunc.PythonModel):
    def load_context(self, context):
        self.agent = agent_chain

    def predict(self, context, model_input):
        # Handle the input format from Salesforce
        prompt = model_input["prompt"][0]
        response = self.agent.run(prompt)
        return [{"answer": response}]

# Log and Register the Model to Unity Catalog
# This makes it available for Model Serving
with mlflow.start_run():
    mlflow.pyfunc.log_model(
        artifact_path="agent_model",
        python_model=AgentModel(),
        input_example=pd.DataFrame({"prompt": ["What is the average temperature of Device X?"]})
    )