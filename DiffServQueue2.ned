 //borrowed from onedomain/DSQueue2.ned

//There are 5 queues. Each marked packet is mapped onto its queue.
//The default queue should not have any packets since all our traffic is marked
//RED has 6 gates, so each class, and color within class has diff probability drop
//AF11 and AF12 map to AF1queue
//AF21 and AF22 map to AF2queue
//AF31 and AF32 map to AF3queue

package inet.examples.diffserv.tcp_udp_wred;

import inet.linklayer.IOutputQueue;
import inet.linklayer.queue.FIFOQueue;
import inet.linklayer.queue.WRRScheduler;
import inet.linklayer.queue.ThresholdDropper;
import inet.networklayer.diffserv.BehaviorAggregateClassifier;

module DiffServQueue2 like IOutputQueue
{
    parameters:
        //need thresholdDropper and frame capacity since fifo is infinite
        // used in NO-RED
        int frameCapacity = default(10);
    gates:
        input in;
        output out;

    submodules:
        classifier: BehaviorAggregateClassifier {
            dscps = "AF11 AF12 AF21 AF22 AF31 AF32 BE";
            @display("p=41,284");
        }
        ThresDrop: ThresholdDropper {
                    numGates = 7;
                    frameCapacity = frameCapacity;
                    @display("p=71,117");
        }
        af1Queue: FIFOQueue {
            @display("p=191,194");
        }
        af2Queue: FIFOQueue {
            @display("p=207,128");
        }
        af3Queue: FIFOQueue {
            @display("p=223,58");
        }
        beQueue: FIFOQueue {
            @display("p=168,271");
        }
        defaultQueue: FIFOQueue {
            @display("p=139,342");
        }
        wrr: WRRScheduler {
            @display("p=348,290");
        }

    connections:
        in --> classifier.in;
        classifier.outs++ --> ThresDrop.in[0]; //AF11
        classifier.outs++ --> ThresDrop.in[1]; //AF12
        classifier.outs++ --> ThresDrop.in[2]; //AF21
        classifier.outs++ --> ThresDrop.in[3]; //AF22
        classifier.outs++ --> ThresDrop.in[4]; //AF31
        classifier.outs++ --> ThresDrop.in[5]; //AF32
        classifier.outs++ --> ThresDrop.in[6]; //BE
        
        ThresDrop.out[0] --> af1Queue.in++;
        ThresDrop.out[1] --> af1Queue.in++;

        ThresDrop.out[2] --> af2Queue.in++;
        ThresDrop.out[3] --> af2Queue.in++;

        ThresDrop.out[4] --> af3Queue.in++;
        ThresDrop.out[5] --> af3Queue.in++;

        ThresDrop.out[6] --> beQueue.in++;

        classifier.defaultOut --> defaultQueue.in++; //no class so put in default queue

        af1Queue.out --> wrr.in++;
        af2Queue.out --> wrr.in++;
        af3Queue.out --> wrr.in++;
        beQueue.out --> wrr.in++;
        defaultQueue.out --> wrr.in++;

        wrr.out --> out;
}
