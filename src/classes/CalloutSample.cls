/**
 * Created by Stefan Abramiuk on 07.09.2017.
 */

public class CalloutSample {
    public HttpResponse doCallout(String type, String endpointUrl, Object parameters){
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(type);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpointUrl);
        System.debug('parameters: ' + parameters);
        if(parameters != null) {
            request.setBody(JSON.serialize(parameters, true));
            system.debug(request.getBody());
        }
        HttpResponse response = h.send(request);
        System.debug('RESPONSE: ' + response.getBody());
        return response;
    }

    private Object executeSpecificCallout(String endpointURL, Object parameters, Type responseType, Type errorResponseType) {
        Object responseMessage;
        try {
            HttpResponse calloutResponse = doCallout('POST', endpointURL, parameters);
            if(calloutResponse.getStatusCode() != 200) {
                try {
                    responseMessage = JSON.deserialize(calloutResponse.getBody(), responseType);

                } catch (System.JSONException ex) {
                    SampleException sampleEx = new SampleException();
                    sampleEx.setMessage('Some message');
                    sampleEx.initCause(ex);
                    throw sampleEx;
                }
            } else {
                try {
                    responseMessage = JSON.deserialize(calloutResponse.getBody(), errorResponseType);

                } catch (System.JSONException ex) {
                    SampleException sampleEx = new SampleException();
                    sampleEx.setMessage('Some message');
                    sampleEx.initCause(ex);
                    throw sampleEx;
                }
            }
        } catch (CalloutException ex) {
            //TODO - remove duplicates
            SampleException sampleEx = new SampleException();
            sampleEx.setMessage('Some message');
            sampleEx.initCause(ex);
            throw sampleEx;
        }
        return responseMessage;
    }

    public class SampleException extends Exception{}
}