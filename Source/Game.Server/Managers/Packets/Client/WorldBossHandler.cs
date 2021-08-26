using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Rooms;


namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.WORLDBOSS_CMD, "场景用户离开")]
    public class WorldBossHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);

            var worldBoss_cmd = packet.ReadByte();
            switch (worldBoss_cmd)
            {
                case (int)WorldBossGamePackageType.ADDPLAYERS:
                    {
                        int num2 = packet.ReadInt();
                        int num3 = packet.ReadInt();
                        client.Player.WorldBossX = num2;
                        client.Player.WorldBossY = num3;
                        if (client.Player.CurrentRoom != null)
                        {
                            client.Player.CurrentRoom.RemovePlayerUnsafe(client.Player);
                        }
                        BaseWorldBossRoom room = RoomMgr.WorldBossRoom;
                        if (client.Player.IsInWorldBossRoom)
                        {
                            pkg.WriteByte(4);
                            pkg.WriteInt(client.Player.PlayerId);
                            room.SendToALL(pkg);
                            room.RemovePlayer(client.Player);
                            client.Player.IsInWorldBossRoom = false;
                        }
                        else if (room.AddPlayer(client.Player))
                        {
                            room.UpdateRoom(client.Player);
                        }

                        Console.WriteLine("//ADDPLAYERS ");
                        break;
                    }
                case (int)WorldBossGamePackageType.BUFF_BUY:
                    {
                        
                        Console.WriteLine("//BUFF_BUY ");
                        break;
                    }
                case (int)WorldBossGamePackageType.ENTER_WORLDBOSSROOM:
                    {
                        Console.WriteLine("//ENTER_WORLDBOSSROOM ");
                        //GSPacketIn response = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, client.Player.PlayerCharacter.ID);
                        //response.WriteByte((byte)WorldBossPackageType.ENTER);
                        //response.WriteInt(client.Player.PlayerCharacter.Grade);//_loc_3.Grade = _loc_2.readInt();
                        //response.WriteInt(client.Player.PlayerCharacter.Hide);//_loc_3.Hide = _loc_2.readInt();
                        //response.WriteInt(client.Player.PlayerCharacter.Repute);//_loc_3.Repute = _loc_2.readInt();
                        //response.WriteInt(client.Player.PlayerCharacter.ID);//_loc_3.ID = _loc_2.readInt();
                        //response.WriteString(client.Player.PlayerCharacter.NickName);//_loc_3.NickName = _loc_2.readUTF();
                        //response.WriteByte(client.Player.PlayerCharacter.typeVIP);//_loc_3.typeVIP = _loc_2.readByte();
                        //response.WriteInt(client.Player.PlayerCharacter.VIPLevel);//_loc_3.VIPLevel = _loc_2.readInt();
                        //response.WriteBoolean(client.Player.PlayerCharacter.Sex);//_loc_3.Sex = _loc_2.readBoolean();
                        //response.WriteString(client.Player.PlayerCharacter.Style);//_loc_3.Style = _loc_2.readUTF();
                        //response.WriteString(client.Player.PlayerCharacter.Colors);//_loc_3.Colors = _loc_2.readUTF();
                        //response.WriteString(client.Player.PlayerCharacter.Skin);//_loc_3.Skin = _loc_2.readUTF();
                        //response.WriteInt(0);//_loc_4 = _loc_2.readInt();
                        //response.WriteInt(0);//_loc_5 = _loc_2.readInt();
                        //response.WriteInt(client.Player.PlayerCharacter.FightPower);//_loc_3.FightPower = _loc_2.readInt();
                        //response.WriteInt(client.Player.PlayerCharacter.Win);//_loc_3.WinCount = _loc_2.readInt();
                        //response.WriteInt(0);//_loc_3.TotalCount = _loc_2.readInt();
                        //response.WriteInt(client.Player.PlayerCharacter.Offer);//_loc_3.Offer = _loc_2.readInt();
                        //response.WriteByte(10);//_loc_6.playerStauts = _loc_2.readByte();
                        //client.Player.Out.SendTCP(response);
                        //break;
                      
                        pkg.WriteByte(2);
                        pkg.WriteBoolean(true);
                        pkg.WriteBoolean(false);
                        pkg.WriteInt(0);
                        pkg.WriteInt(0);
                        client.Out.SendTCP(pkg); 
                        return 0;


                    }
                case (int)WorldBossGamePackageType.LEAVE_ROOM:
                    {
                        BaseWorldBossRoom worldBossRoom = RoomMgr.WorldBossRoom;
                        pkg.WriteByte(4);
                        pkg.WriteInt(client.Player.PlayerId);
                        worldBossRoom.SendToALL(pkg);
                        worldBossRoom.RemovePlayer(client.Player);
                        client.Player.IsInWorldBossRoom = false;
                       

                        Console.WriteLine("//LEAVE_ROOM ");
                        break;
                    }
                case (int)WorldBossGamePackageType.MOVE:
                    {
                        Console.WriteLine("//MOVE ");
                        break;
                    }
                case (int)WorldBossGamePackageType.REQUEST_REVIVE:
                    {
                        Console.WriteLine("//REQUEST_REVIVE ");
                        break;
                    }
                case (int)WorldBossGamePackageType.STAUTS:
                    {

                        byte num6 = packet.ReadByte();
                        if ((num6 != 3) || (client.Player.WorldBossState != 3))
                        {
                            pkg.WriteByte(7);
                            pkg.WriteInt(client.Player.PlayerId);
                            pkg.WriteByte(num6);
                            pkg.WriteInt(client.Player.WorldBossX);
                            pkg.WriteInt(client.Player.WorldBossY);
                            RoomMgr.WorldBossRoom.SendToALL(pkg);
                            if ((num6 == 3) && (client.Player.CurrentRoom.Game != null))
                            {
                                client.Player.CurrentRoom.Game.Stop();
                                client.Player.CurrentRoom.Game.RemovePlayer(client.Player, true);
                            }
                        }
                        client.Player.WorldBossState = num6;
                       // RoomMgr.WorldBossRoom.SendUpdateRank();
                     //   RoomMgr.WorldBossRoom.SendPrivateInfo(client.Player);
                      //  break;

                        Console.WriteLine("//STAUTS");
                        break;
                    }
                default:
                    Console.WriteLine("//worldBoss_cmd: " + worldBoss_cmd);
                    break;
            }
            return 0;
        }
    }
}
