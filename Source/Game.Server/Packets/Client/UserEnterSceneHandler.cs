using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Rooms;
using Game.Logic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.SCENE_LOGIN, "Player enter scene.")]
    public class UserEnterSceneHandler:IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {            
            var typeScene = packet.ReadInt();
            BaseRoom[] list = RoomMgr.Rooms;
            List<BaseRoom> tempList = new List<BaseRoom>();

            switch (typeScene)
            {

                case 1:
                    {
                        for (int i = 0; i < list.Length; i++)
                        {
                            if (!list[i].IsEmpty)
                            {
                                if (list[i].RoomType == eRoomType.Match || list[i].RoomType == eRoomType.Freedom)
                                {
                                    tempList.Add(list[i]);
                                }
                            }
                        }
                        
                    }
                    break;
                case 2:
                    //do something
                    {
                        for (int i = 0; i < list.Length; i++)
                        {
                            if (!list[i].IsEmpty)
                            {
                                if (list[i].RoomType == eRoomType.Dungeon)
                                {
                                    tempList.Add(list[i]);
                                }
                            }
                        }
                    }
                    break;
                default:
                    {
                        RoomMgr.EnterWaitingRoom(client.Player);
                    }
                    break;
            }
            if (tempList.Count > 0)
                client.Out.SendUpdateRoomList(tempList);
            return 1;
        }
    }
}
