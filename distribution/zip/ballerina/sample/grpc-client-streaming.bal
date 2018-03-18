import ballerina.io;
import ballerina.net.grpc;

endpoint grpc:Service ep {
  host:"localhost",
  port:9090
};

@grpc:serviceConfig {rpcEndpoint:"LotsOfGreetings",
                     clientStreaming:true,
generateClientConnector:true}
service<grpc:Endpoint> helloWorld bind ep {
    onOpen (endpoint client) {
        io:println("connected sucessfully.");
    }

    onMessage (endpoint client, string name) {
        io:println("greet received: " + name);
    }

    onError (endpoint client, grpc:ServerError err) {
        if (err != null) {
            io:println("Something unexpected happens at server : " + err.message);
        }
    }

    onComplete (endpoint client) {
        io:println("Server Response");
        grpc:ConnectorError err = client -> send("Ack");
        if (err != null) {
            io:println("Error at onComplete send message : " + err.message);
        }
    }
}
