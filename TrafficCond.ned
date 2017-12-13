//borrowed from onedomain/TC2.ned

package inet.examples.diffserv.tcp_udp_wred;

import inet.base.Join;
import inet.linklayer.ITrafficConditioner;
import inet.networklayer.diffserv.DSCPMarker;
import inet.networklayer.diffserv.MultiFieldClassifier;
import inet.networklayer.diffserv.TokenBucketMeter;


//
// Classifies traffic and maps to different streams
// AF1- gate 0, AF2 - gate 1, AF3 - gate2
//
module TrafficCond like ITrafficConditioner
{
    parameters:
        int numClasses;
        @display("i=block/classifier");

    gates:
        input in;
        output out;
    submodules:
        classifier: MultiFieldClassifier {
            @display("p=38,35");
        }
        meterAF1: TokenBucketMeter {
            @display("p=126,205");
        }
        meterAF2: TokenBucketMeter {
            @display("p=134,134");
        }
        meterAF3: TokenBucketMeter {
            @display("p=151,65");
        }
        marker: DSCPMarker {
            @display("p=269,35");
        }
        join: Join {
            @display("p=269,199");
        }
    connections:
        in --> classifier.in;

        classifier.outs++ --> meterAF1.in++; //AF1 meter - from H1, TCP - gate0
        classifier.outs++ --> meterAF2.in++; //AF2 meter - from H2, TCP - gate1
        classifier.outs++ --> meterAF3.in++; //AF3 meter - from H3, TCP - gate2

        meterAF1.greenOut --> marker.in++; //AF11
        meterAF1.redOut --> marker.in++; //AF12
        meterAF2.greenOut --> marker.in++; //AF21
        meterAF2.redOut --> marker.in++; //AF22
        meterAF3.greenOut --> marker.in++; //AF31
        meterAF3.redOut --> marker.in++; //AF32	
        
        classifier.outs++ --> marker.in++; //BE           from H4, UDP - gate 3

        classifier.defaultOut --> marker.in++; //doesn't match any class

        marker.out --> join.in++;
        join.out --> out;
}
