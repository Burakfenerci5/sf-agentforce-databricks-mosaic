public class DatabricksMosaicAction {
    
    // Input structure received from Agentforce
    public class AgentInput {
        @InvocableVariable(required=true label='User Prompt')
        public String userPrompt;
    }
    
    // Output structure sent back to Agentforce
    public class AgentOutput {
        @InvocableVariable(label='Model Response')
        public String modelResponse;
    }

    @InvocableMethod(label='Call Databricks Mosaic AI' description='Routes user query to Databricks Model Serving for grounded inference')
    public static List<AgentOutput> callMosaicAI(List<AgentInput> inputs) {
        List<AgentOutput> outputs = new List<AgentOutput>();
        
        for (AgentInput input : inputs) {
            AgentOutput output = new AgentOutput();
            // Call the helper service to hit the Databricks API
            output.modelResponse = DatabricksHttpService.queryServingEndpoint(input.userPrompt);
            outputs.add(output);
        }
        return outputs;
    }
}