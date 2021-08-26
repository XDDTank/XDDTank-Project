using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base;
using Game.Base.Packets;

namespace Game.Tools
{
    public class AdminClient:BaseConnector
    {
        public AdminClient(string ip, int port)
            : base(ip, port, false, new byte[(int)eStatistic.Normal], new byte[(int)eStatistic.Normal])
        { }

        public override void OnRecvPacket(Game.Base.Packets.GSPacketIn pkg)
        {
            if (pkg.Code == 0x03)  //system_message
            {
                Console.WriteLine(pkg.ReadString());
            }
        }

        public void SentCmd(string cmdline)
        {
            GSPacketIn pkg = new GSPacketIn(0x01);
            pkg.WriteString(cmdline);
            SendTCP(pkg);
        }
    }
}
