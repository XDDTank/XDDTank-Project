using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.WEEKLY_CLICK_CNT, "场景用户离开")]
    public class UserWeeklyClickHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //GSPacketIn pkg = packet.Clone();
            //pkg.ClearContext();
            int id = client.Player.PlayerCharacter.ID;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.WEEKLY_CLICK_CNT, id);
            
            if (DateTime.Now.Date != client.Player.PlayerCharacter.LastGetEgg.Date)
            {
                pkg.WriteBoolean(true);
            }
            else
            {
                pkg.WriteBoolean(false);
            }
            client.SendTCP(pkg);
            return 0;
        }
    }
}
