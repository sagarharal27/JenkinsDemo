//Generated by wsdl2apex

public class AsyncSoapSforceComSchemasClassSoaphellow {
    public class testServiceResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            soapSforceComSchemasClassSoaphellow.testServiceResponse_element response = (soapSforceComSchemasClassSoaphellow.testServiceResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncSoapHelloWorld {
        public String endpoint_x = 'https://na15.salesforce.com/services/Soap/class/SoapHelloWorld';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public soapSforceComSchemasClassSoaphellow.CallOptions_element CallOptions;
        public soapSforceComSchemasClassSoaphellow.DebuggingInfo_element DebuggingInfo;
        public soapSforceComSchemasClassSoaphellow.SessionHeader_element SessionHeader;
        public soapSforceComSchemasClassSoaphellow.DebuggingHeader_element DebuggingHeader;
        public soapSforceComSchemasClassSoaphellow.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/SoapHelloWorld';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/SoapHelloWorld';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/SoapHelloWorld';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/SoapHelloWorld';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/SoapHelloWorld';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/SoapHelloWorld', 'soapSforceComSchemasClassSoaphellow'};
        public AsyncSoapSforceComSchemasClassSoaphellow.testServiceResponse_elementFuture beginTestService(System.Continuation continuation) {
            soapSforceComSchemasClassSoaphellow.testService_element request_x = new soapSforceComSchemasClassSoaphellow.testService_element();
            return (AsyncSoapSforceComSchemasClassSoaphellow.testServiceResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoaphellow.testServiceResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SoapHelloWorld',
              'testService',
              'http://soap.sforce.com/schemas/class/SoapHelloWorld',
              'testServiceResponse',
              'soapSforceComSchemasClassSoaphellow.testServiceResponse_element'}
            );
        }
    }
}