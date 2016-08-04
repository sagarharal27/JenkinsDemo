public with sharing class oAuthRESTController {
string environment;
string clientId;
string redirectUrl;
string clientSecret;
public string accesstoken{get;set;}
public string instance_url{get;set;}
public string FinalResponse{get;set;}
public oAuthRESTController()
{
clientId = '3MVG9A2kN3Bn17hsKFsX2G9wvNHicYmtMxd8J_qhHmfJqaoKXwO8DOsiO8Tot8INrcRsPgNzLr.OZA9eI0H00';
redirectUrl = 'https://c.ap2.visual.force.com/apex/HelloWorldRest';
environment = 'https://sagarsite-developer-edition.na15.force.com';
clientSecret = '4694284052807013787';
instance_url ='';
FinalResponse= 'Hello World from REST service';
}
public PageReference genCode()
{
string authUrl = '';
authUrl = environment + '/services/oauth2/authorize?response_type=code&client_id='+ clientId + '&redirect_uri='+redirectUrl;
PageReference ReturnPage = new PageReference (authUrl);
return ReturnPage;
}
public void AccessToken()
{
String tt = ApexPages.currentPage().getParameters().get('code');
String content = 'code='+tt+'&client_id='+clientId+'&client_secret='+clientSecret+'&redirect_uri='+redirectUrl+'&grant_type=authorization_code';
HttpRequest req = new HttpRequest();
string temp = 'https://sagarsite-developer-edition.na15.force.com/services/oauth2/token?code='+tt+'&client_id='+clientId+'&client_secret='+clientSecret+'&redirect_uri='+redirectUrl+'&grant_type=authorization_code';
req.setEndpoint(temp);
req.setMethod('POST');

HttpResponse response = null;
Http http = new Http();
response = http.send(req);

system.debug('$$@$#$@#$@#$@#$'+response.getBody());
Map<String, Object> JSONMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
system.debug('@#!#@!#!@#@!#@!'+JSONMap);

accesstoken =(String)JSONMap.get('access_token');
instance_url = (String)JSONMap.get('instance_url');
}
public void MyServiceCall()
{
HttpRequest req = new HttpRequest();
req.setEndpoint('https://sagarsite-developer-edition.na15.force.com/services/apexrest/HelloWorldWebservice/');
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer '+accessToken);
httpResponse response = null;
Http http = new Http();
response = http.send(req);
system.debug('$$@$#$@#$@#$@#$'+response.getBody());
FinalResponse= (String)response.getBody();
}

}