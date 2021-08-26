using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using log4net.Util;
using Game.Server.GameObjects;
using System.Threading;
using Bussiness;
using SqlDataProvider.Data;


namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.GET_SIGNAWARD, "场景用户离开")]
    public class SignAwardHandler : IPacketHandler
    {        
        public int HandlePacket(GameClient client, Game.Base.Packets.GSPacketIn packet)
        {
            int awardCounts = packet.ReadInt();
            string msg = "Nhận thưởng tích lũy hằng ngày thành công!";
            if (Managers.AwardMgr.AddSignAwards(client.Player, awardCounts))
            {
                client.Out.SendMessage(eMessageType.Normal, msg);
            }
            
            return 0;
        }

    }
}
