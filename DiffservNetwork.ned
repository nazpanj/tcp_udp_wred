package inet.examples.diffserv.tcp_udp_wred;

import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.StandardHost;
import inet.util.ThruputMeteringChannel;
import ned.DatarateChannel;
import inet.util.NetAnimTrace;


network DiffservNetwork
{
    double coreDatarate @unit(bps);
    types:

        channel coreline extends ThruputMeteringChannel
        {
            delay = 2ms;
            datarate = coreDatarate;
            thruputDisplayFormat = "b B U";
        }
        channel ethernetline extends ThruputMeteringChannel
        {
            delay = 0.1us; //router to host delay, low
            datarate = 100Mbps;
            //datarate = edgeDatarate;
            thruputDisplayFormat = "b B U";
        }
    submodules:
        //clients
        //AF1
        H1: StandardHost {
            @display("p=20,22");
        }
        H2: StandardHost {
            @display("p=73,22");
        }
        H3: StandardHost {
            @display("p=135,22");
        }

 		//AF2
        H4: StandardHost {
            @display("p=66,88");
        }
        H5: StandardHost {
            @display("p=20,98");
        }
        H6: StandardHost {
            @display("p=34,154");
        }

		//AF3
        H7: StandardHost {
            @display("p=20,212");
        }
        H8: StandardHost {
            @display("p=20,258");
        }
        H9: StandardHost {
            @display("p=20,308");
        }

		//BE
        H10: StandardHost {
            @display("p=96,308");
        }
        H11: StandardHost {
            @display("p=150,308");
        }
        H12: StandardHost {
            @display("p=199,297");
        }


        //servers
        H15: StandardHost {
            @display("p=570,55");
        }
        H16: StandardHost {
            @display("p=570,119");
        }
        H17: StandardHost {
            @display("p=570,189");
        }
        H18: StandardHost {
            @display("p=570,251");
        }

        R2: Router {
            @display("p=346,143");
        }
        R1: Router {
            @display("p=238,154");
        }

        configurator: IPv4NetworkConfigurator {
            @display("p=315,35");
        }
        netAnimTrace: NetAnimTrace {
            @display("p=213,35");
        }
    connections:
        H1.ethg++ <--> ethernetline <--> R1.ethg++;
        H2.ethg++ <--> ethernetline <--> R1.ethg++;
        H3.ethg++ <--> ethernetline <--> R1.ethg++;

        H4.ethg++ <--> ethernetline <--> R1.ethg++;
        H5.ethg++ <--> ethernetline <--> R1.ethg++;
        H6.ethg++ <--> ethernetline <--> R1.ethg++;

        H7.ethg++ <--> ethernetline <--> R1.ethg++;
        H8.ethg++ <--> ethernetline <--> R1.ethg++;
        H9.ethg++ <--> ethernetline <--> R1.ethg++;

        H10.ethg++ <--> ethernetline <--> R1.ethg++;
        H11.ethg++ <--> ethernetline <--> R1.ethg++;
        H12.ethg++ <--> ethernetline <--> R1.ethg++;

        H15.ethg++ <--> ethernetline <--> R2.ethg++;
        H16.ethg++ <--> ethernetline <--> R2.ethg++;
        H17.ethg++ <--> ethernetline <--> R2.ethg++;
        H18.ethg++ <--> ethernetline <--> R2.ethg++;

        R1.pppg++ <--> coreline <--> R2.pppg++;
}
