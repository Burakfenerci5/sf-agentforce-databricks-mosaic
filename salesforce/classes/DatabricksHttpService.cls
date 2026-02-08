public class DatabricksHttpService {
    // Requires a Named Credential 'Databricks_Mosaic_Endpoint' to be configured in Salesforce Setup
    // This abstracts authentication (PAT Token) securely
    private static final String ENDPOINT = 'callout:Databricks_Mosaic_Endpoint/serving-endpoints/iot-agent/invocations';

    public static String queryServingEndpoint(String prompt) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        // Format payload strictly for Databricks Model Serving API
        // Wraps the prompt in the expected "inputs" JSON structure
        String body = '{"inputs": {"prompt": ["' + prompt + '"]}}';
        req.setBody(body);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Parse the response to extract just the answer text
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            // This assumes the model returns a list of predictions
            return String.valueOf(result.get('predictions'));
        } else {
            // Error handling for debugging
            System.debug('Databricks Error: ' + res.getBody());
            return 'Error calling Databricks: ' + res.getStatus() + ' - ' + res.getBody();
        }
    }
}