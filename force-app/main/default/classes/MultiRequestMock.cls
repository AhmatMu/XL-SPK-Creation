public class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if (mock != null) {
            return mock.respond(req);
        } else {
                System.debug('HTTP callout not supported for test methods');
                return null;
                
        }
    }
	// belum dipakai
	/* 
    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    } */
}