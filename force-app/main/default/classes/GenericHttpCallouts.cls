public with sharing class GenericHttpCallouts {
     
    public static HttpResponse Request(String URL, String method){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod(method);
        return http.send(request);
    }    
}
