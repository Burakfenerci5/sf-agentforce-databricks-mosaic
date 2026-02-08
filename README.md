# Agentforce + Databricks Mosaic AI: The Lakehouse Intelligence Bridge

### Headless Agent Architecture for the Data-Driven Enterprise

This repository demonstrates the **Agentic Data Gateway (ADG)** pattern for Databricks. It enables Salesforce Agentforce to bypass the CRM's native data limits and directly query a **Mosaic AI Agent** running on the Databricks Lakehouse.

## Strategic Value Proposition

* **Unity Catalog Grounding:** Agents are grounded in the full context of your Delta Lake (e.g., IoT streams, financial logs) without ETL.
* **Mosaic AI Power:** Leverage Databricks' "DBRX" or fine-tuned Llama 3 models hosted on secure Model Serving endpoints.
* **Zero-Copy Logic:** The intelligence stays where the data lives. Salesforce is used strictly for engagement.

## Architecture Overview

1.  **Salesforce Agentforce:** Captures the user intent (e.g., "Check the health of Pump 42").
2.  **Apex Bridge:** An invocable action bypasses Data Cloud and hits the Databricks Model Serving API.
3.  **Databricks Mosaic AI:** A LangChain agent queries the **IoT Delta Tables** and synthesizes an answer.
4.  **Response:** The insight is returned to the user in the flow of work.

## Setup Guide

### 1. Databricks Configuration
* Deploy `databricks/agent_logic.py` as a Notebook.
* Register the model to **Unity Catalog**.
* Enable a **Model Serving Endpoint**.

### 2. Salesforce Integration
* Deploy the Apex classes in `salesforce/classes/`.
* Configure a **Named Credential** in Salesforce Setup with your Databricks Workspace URL and PAT Token.
* Create a new **Agentforce Action** mapped to the `DatabricksMosaicAction` Apex class.

---
**Contributor:** Burak Fenercioglu | *AI Strategy & Forward Deployed Architect*