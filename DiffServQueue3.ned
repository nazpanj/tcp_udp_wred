 //borrowed from onedomain/DSQueue2.ned

//There are 5 queues. Each marked packet is mapped onto its queue.
//The default queue should not have any packets since all our traffic is marked
//AF11 and AF12 map to AF1queue
//AF21 and AF22 map to AF2queue
//AF31 and AF32 map to AF3queue

package inet.examples.diffserv.tcp_udp_wred;

import inet.linklayer.IOutputQueue;
import inet.linklayer.queue.DropTailQueue;
import inet.linklayer.queue.WRRScheduler;
import inet.networklayer.diffserv.BehaviorAggregateClassifier;

module DiffServQueue3 like IOutputQueue
{
     parameters:
        int frameCapacity = default(10);
    
    gates:
        input in;
        output out;

    submodules:
        classifier: BehaviorAggregateClassifier {
            dscps = "AF11 AF12 AF21 AF22 AF31 AF32 BE";
            @display("p=41,284");
        }
   
        af1Queue: DropTailQueue {
            frameCapacity = frameCapacity;
            @display("p=191,194");
        }
        af2Queue: DropTailQueue {
            frameCapacity = frameCapacity;
            @display("p=207,128");
        }
        af3Queue: DropTailQueue {
            frameCapacity = frameCapacity;
            @display("p=223,58");
        }
        beQueue:DropTailQueue {
            frameCapacity = frameCapacity;
            @display("p=168,271");
        }
        defaultQueue: DropTailQueue {
            frameCapacity = frameCapacity;
            @display("p=139,342");
        }
        wrr: WRRScheduler {
            @display("p=348,290");
        }

    connections:
        in --> classifier.in;
        classifier.outs++ --> af1Queue.in; //AF11
        //classifier.outs++ --> af1Queue.in; //AF12
        
        classifier.outs++ --> af2Queue.in; //AF21
        //classifier.outs++ --> af2Queue.in; //AF22
        
        classifier.outs++ --> af3Queue.in; //AF31
        //classifier.outs++ --> af3Queue.in; //AF32
        
        classifier.outs++ --> beQueue.in; //BE

        classifier.defaultOut --> defaultQueue.in; //no class so put in default queue

        af1Queue.out --> wrr.in++;
        af2Queue.out --> wrr.in++;
        af3Queue.out --> wrr.in++;
        beQueue.out --> wrr.in++;
        defaultQueue.out --> wrr.in++;

        wrr.out --> out;
}
